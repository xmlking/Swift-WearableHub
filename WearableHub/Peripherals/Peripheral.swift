import Foundation
import RxSwift

public enum ConnectionStatus {
    case Connected
    case Disconnected
    case BluetoothUnavailable
    case DeviceUnavailable
}

public protocol Peripheral {
    
    var name: String { get }
    var sensors: [Observable<SensorData>] { get }
    
    func getSupportedSensors() -> [SensorType]
    func connect() -> Observable<ConnectionStatus>
}


