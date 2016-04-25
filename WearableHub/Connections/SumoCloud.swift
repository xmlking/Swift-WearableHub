import Foundation
import RxSwift
 
 public class SumoCloudSync: NSObject, CloudConnection {
    public let name = "Sumo Cloud Backend"
    public let subscriber = ["category": "wearables" , "userid":"sumo", "device":"msband"]

    public var fromCloud: Observable<AnyObject>
    public var toCloud: Observable<AnyObject> //// PublishSubject<JSONDictionary?>()

    override init() {
        //super.init()
        fromCloud = Observable.create { observer -> Disposable in
            observer.on(.Next("fromCloud"))
            return AnonymousDisposable {
                //task.cancel()
            }
        }
        
        toCloud = Observable.create { observer -> Disposable in
            observer.on(.Next("toCloud"))
            return AnonymousDisposable {
                //task.cancel()
            }
        }
    }
    
    public func connect() -> Observable<CloudConnectionStatus> {
        return Observable.create { observer -> Disposable in
            observer.on(.Next(.Connected))
            
            return AnonymousDisposable {
                //task.cancel()
                print("Sumo Cloud Connection Disposed")
            }
        }
    }
 }