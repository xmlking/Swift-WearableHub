import Foundation
import RxSwift


public class RxMicrosoftBand: NSObject, Peripheral, MSBClientManagerDelegate {

    var client: MSBClient!
    public var deviceName: String
    public var connectionStatusDelegate:ConnectionStatusDelegate!
    
    override init() {
        self.deviceName = "Microsoft Band"
        super.init()
        MSBClientManager.sharedManager().delegate = self
    }
    
    public func getSupportedSensors() -> [SensorType] {
        return [.Accelerometer,.AmbientLight,.Calories,.Gyroscope,.Gsr,.Pedometer,.HeartRate,.SkinTemperature,.Barometer]
    }
    
    public func connect(connectionStatusDelegate:ConnectionStatusDelegate!) {
        //connect(connectionStatusDelegate)
        
        if let client = MSBClientManager.sharedManager().attachedClients().first as? MSBClient {
            self.client = client
            
            MSBClientManager.sharedManager().connectClient(self.client)
        } else {
            updateConnectionStatus(.DeviceUnavailable)
        }
    }
    
    public func disconnect(){
        if let currentClient = client {
            MSBClientManager.sharedManager().cancelClientConnection(currentClient)
        }
    }
    
    public func connect() -> Observable<ConnectionStatus> {
        return Observable.create { observer -> Disposable in
            
            if let client = MSBClientManager.sharedManager().attachedClients().first as? MSBClient {
                self.client = client
                
                MSBClientManager.sharedManager().connectClient(self.client)
            } else {
                observer.onNext(.DeviceUnavailable)
            }
            
            return AnonymousDisposable {
                if let currentClient = self.client {
                    MSBClientManager.sharedManager().cancelClientConnection(currentClient)
                }
            }
        }
    }
    
    public func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        updateConnectionStatus(.Connected)
    }
    
    public func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        updateConnectionStatus(.Disconnected)
    }
    
    public func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        updateConnectionStatus(.DeviceUnavailable)
    }
    
    var accelerometer: Observable<AccelerometerData> {
        get {
                return Observable.create { observer -> Disposable in
                    _ = try? self.client.sensorManager.startAccelerometerUpdatesToQueue(nil, withHandler: { (data, error) in
                        
                        let accelerometedData = AccelerometerData()
                        accelerometedData.x = data.x
                        accelerometedData.y = data.y
                        accelerometedData.z = data.z
                        
                        observer.onNext(accelerometedData)
                    })
                
                    return AnonymousDisposable {
                         _ = try! self.client.sensorManager.stopAccelerometerUpdatesErrorRef()
                        print("accelerometer :  disposabled")
                    }
                }.shareReplayLatestWhileConnected()
            } // Set the initial value of the var
    }
    

}