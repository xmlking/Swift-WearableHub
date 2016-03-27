import Foundation

public enum ConnectionStatus {
    case Connected
    case Disconnected
    case BluetoothUnavailable
    case DeviceUnavailable
}

public protocol ConnectionStatusDelegate {
    func connectionStatusChanged(deviceName:String, withStatus status:ConnectionStatus)
}

public protocol Peripheral {
    
    var deviceName: String { get }
    var connectionStatusDelegate:ConnectionStatusDelegate! { set get }
    
    func getSupportedSensors() -> [SensorType]
    
    func connect(connectionStatusDelegate:ConnectionStatusDelegate!)
    
    func disconnect()
 
}


public extension Peripheral  {
    func updateConnectionStatus(status:ConnectionStatus){
        if let delegate = connectionStatusDelegate {
            delegate.connectionStatusChanged(deviceName , withStatus: status)
        }
    }
    mutating func connect(connectionStatusDelegate:ConnectionStatusDelegate!){
        self.connectionStatusDelegate = connectionStatusDelegate
    }
}

