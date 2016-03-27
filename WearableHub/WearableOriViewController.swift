import UIKit
import SWRevealViewController
import SocketIOClientSwift

class WearableOriViewController: UIViewController, MSBClientManagerDelegate {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    var socket = SocketIOClient(socketURL: NSURL(string: "http://apsrt1453:3010")!, options: [.Nsp("/iot")]);
    
    weak var client: MSBClient?
    var microsoftBand: RxMicrosoftBand?
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
    }
    
    func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
 
    }
    
    func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
 
    }
    
    
    func showMobileEdgeDialog(message:String){
        let alert = UIAlertController(title: "Wearable Hub", message: message, preferredStyle: .Alert)
        let continueAction = UIAlertAction(title: "Continue", style: .Default, handler: nil)
        alert.addAction(continueAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

