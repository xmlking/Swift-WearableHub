import Foundation
import RxSwift

enum ConsentError: ErrorType {
    case NotSpecified
    case Declined
}


public class RxMicrosoftBand: NSObject, Peripheral, MSBClientManagerDelegate {

    var client: MSBClient!
    public let name = "Microsoft Band"
    var connectionStatus: AnyObserver<ConnectionStatus>! //PublishSubject???
    public var sensors = [Observable<SensorData>]()
    
    override init() {
        super.init()
        MSBClientManager.sharedManager().delegate = self

        sensors.append( Observable.create { observer -> Disposable in
            _ = try? self.client.sensorManager.startAccelerometerUpdatesToQueue(nil, withHandler: { (data, error) in
                
                let accelerometedData = AccelerometerData(x: data.x, y: data.y, z: data.z)
                observer.onNext(accelerometedData)
            })
            
            return AnonymousDisposable {
                _ = try! self.client.sensorManager.stopAccelerometerUpdatesErrorRef()
                print("Accelerometer Disposed")
            }
            }.shareReplayLatestWhileConnected()
        )
        
        sensors.append( Observable.create { observer -> Disposable in
            
            _ = try! self.client.sensorManager.startSkinTempUpdatesToQueue(nil, withHandler: { (data, error) in
                
                let skinTemperatureData = SkinTemperatureData(temperature: data.temperature)
                
                observer.onNext(skinTemperatureData)
            })
            
            return AnonymousDisposable {
                _ = try! self.client.sensorManager.stopSkinTempUpdatesErrorRef()
                print("Skin Temperature Disposed")
            }
            }.shareReplayLatestWhileConnected()
        )
        
        sensors.append( Observable.create { observer -> Disposable in
            
            func updateHeartRate() {
                _ = try! self.client.sensorManager.startHeartRateUpdatesToQueue(nil, withHandler: { (data, error) in
                    
                    let heartRateData = HeartRateData(heartRate: data.heartRate)
                    if (data.quality == .Locked) {
                        observer.onNext(heartRateData)
                    }
                })
            }
            

            let consent = self.client.sensorManager.heartRateUserConsent()
            
            switch (consent) {
            case .Granted:
                updateHeartRate()
                
            case .NotSpecified, .Declined:
                //Ask for permition
                self.client.sensorManager.requestHRUserConsentWithCompletion({ (isGrunted, error) -> Void in
                    if (isGrunted){
                        updateHeartRate()
                    } else {
                        observer.on(.Error(error ?? ConsentError.Declined))
                    }
                })
            };
            
            return AnonymousDisposable {
                _ = try! self.client.sensorManager.stopHeartRateUpdatesErrorRef()
                print("HeartRate Disposed")
            }
            }.shareReplayLatestWhileConnected()
        )
        
        
    }
    
    public func getSupportedSensors() -> [SensorType] {
        return [.Accelerometer,.AmbientLight,.Calories,.Gyroscope,.Gsr,.Pedometer,.HeartRate,.SkinTemperature,.Barometer]
    }
    
    public func connect() -> Observable<ConnectionStatus> {
        return Observable.create { (observer: AnyObserver<ConnectionStatus>) -> Disposable in
            print("\(self.name) Connection Subscribed")
            self.connectionStatus = observer
            if let client = MSBClientManager.sharedManager().attachedClients().first as? MSBClient {
                self.client = client
                MSBClientManager.sharedManager().connectClient(self.client)
            } else {
                observer.on(.Next(.DeviceUnavailable))
            }
            
            return AnonymousDisposable {
                if let currentClient = self.client {
                    MSBClientManager.sharedManager().cancelClientConnection(currentClient)
                    print("\(self.name) Connection Disposed")
                }
            }
        }
    }
    
    public func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        self.connectionStatus.on(.Next(.Connected))
    }
    
    public func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        self.connectionStatus.on(.Next(.Disconnected))
    }
    
    public func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        self.connectionStatus.on(.Error(error))
    }
    
}
