import Foundation
import RxSwift

public enum CloudConnectionStatus {
    case Connected
    case Disconnected
    case NetworkUnavailable
}

public protocol CloudConnection {
    
    var name: String { get }
    var subscriber : [String:String] { get }
    var fromCloud: Observable<AnyObject> { get }
    var toCloud: Observable<AnyObject> { get } // PublishSubject ???
    
    func connect() -> Observable<CloudConnectionStatus>
}