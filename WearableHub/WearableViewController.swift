import UIKit
import RxSwift
import SWRevealViewController
import SocketIOClientSwift

class WearableViewController: UIViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var connectSpinner: UIActivityIndicatorView!
    
    var socket = SocketIOClient(socketURL: NSURL(string: "http://apsrt1453:3010")!, options: [.Nsp("/iot")]);
    
//    var microsoftBand: Peripheral?
    var microsoftBand: RxMicrosoftBand?
    
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // revealToggle
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // check if backend is set to local by user
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("localTesting") {
            print("localTesting? True")
            
            if let backendUrl = userDefaults.stringForKey("backendUrl") where !backendUrl.isEmpty {
                if !backendUrl.isEmpty {
                    print("backendUrl: \(backendUrl)" )
                    self.socket = SocketIOClient(socketURL: NSURL(string: backendUrl)!, options: [.Nsp("/iot")]);
                }
            } else {
                //self.socket = SocketIOClient(socketURL: NSURL(string: "http://172.20.10.5:3010")!, options: [.Nsp("/iot")]);
                self.socket = SocketIOClient(socketURL: NSURL(string: "http://sumanths-mbp.fritz.box:3010")!, options: [.Nsp("/iot")]);
            }
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
        microsoftBand = RxMicrosoftBand()
        connectSpinner.startAnimating()
        microsoftBand?.connect()
            .subscribe(
                onNext: { status in
                    self.onConnectionStatusChanged(self.microsoftBand!, status: status)
                },
                onError: { error in
                    print(error)
                },
                onCompleted: {
                    self.showMobileEdgeDialog("\(self.microsoftBand!.name) Connection Completed")
                },
                onDisposed: {
                    self.showMobileEdgeDialog("\(self.microsoftBand!.name) Connection Disposed")
                }
            ).addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //notification about connection status change
    func onConnectionStatusChanged(device: Peripheral,  status: ConnectionStatus) {
        connectSpinner.stopAnimating()
        switch status {
        case .Connected:
            print("Connected to \(device.name)")
            //connectButton.hidden = true
            //iconnectButton.hidden = false
            onConnected(device)
            //self.cloudSync.startSync(device)
            
        case .Disconnected:
            showMobileEdgeDialog("\(device.name) Dissconected")
            //connectButton.hidden = false
            //diconnectButton.hidden = true
            
        case .BluetoothUnavailable:
            showMobileEdgeDialog("\(device.name) Bluetooth Unavailable")
            
            
        case .DeviceUnavailable:
            showMobileEdgeDialog("\(device.name) Unavailable")
        }
    }
    
    func onConnected(device: Peripheral) {
        for sensor in device.sensors {
            sensor
                .take(6)
                .subscribe(
                    onNext: { data in
                        switch data.type {
                        case .Accelerometer:
                            print(data.asJSON())
                        default:
                            print(data.asJSON())
                        }
                    },
                    onError: { error in
                        print("error: \(error)")
                    },
                    onCompleted: {
                        
                        print("Completed")
                    },
                    onDisposed: {
                        print("Disposed")
                    }
                ).addDisposableTo(disposeBag)
        }
    }
    
    func showMobileEdgeDialog(message:String){
        let alert = UIAlertController(title: "Wearable Hub", message: message, preferredStyle: .Alert)
        let continueAction = UIAlertAction(title: "Continue", style: .Default, handler: nil)
        alert.addAction(continueAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

