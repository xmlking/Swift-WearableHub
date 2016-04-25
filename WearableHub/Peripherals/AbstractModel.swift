import Foundation

public typealias JSONDictionary = [String: AnyObject]

public enum SensorType {
    case Accelerometer, Temperature, Humidity, Magnetometer, Gyroscope, Barometer, Optical, AmbientLight, Calories, Gsr, Pedometer, HeartRate, SkinTemperature, UV
}

func getCurrentMillis()->NSInteger{
    return  NSInteger(NSDate().timeIntervalSince1970 * 1000)
}

public protocol SensorData {
    var timestamp:NSInteger { get }
    var type:SensorType { get }
    
    func asJSON() -> JSONDictionary
}

extension SensorData {
    public var timestamp: NSInteger {
        return getCurrentMillis()
    }
    
    public func _asJSON() -> JSONDictionary {
        var data = JSONDictionary()
        data["timestamp"] = timestamp
        return data
    }
    
}

struct AccelerometerData: SensorData {
    let x:Double
    let y:Double
    let z:Double
    let type = SensorType.Accelerometer
    
    init(x:Double, y:Double, z:Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["accelerometer"] = ["x":x,"y":y,"z":z]
        return data
    }
}

struct GyroscopeData : SensorData{
    let x:Double
    let y:Double
    let z:Double
    let type = SensorType.Gyroscope
    
    init(x:Double, y:Double, z:Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["gyroscope"] = ["x":x,"y":y,"z":z]
        return data
    }
}

struct MagnetometerData : SensorData{
    let x:Double
    let y:Double
    let z:Double
    let type = SensorType.Magnetometer
    
    init(x:Double, y:Double, z:Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["magnetometer"] = ["x":x,"y":y,"z":z]
        return data
    }
}

struct TemperatureData : SensorData {
    let temperature:Double
    let type = SensorType.Temperature
    
    init(temperature:Double) {
        self.temperature = temperature
    }
    
    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["temperature"] = temperature
        return data
    }
}

struct HumidityData : SensorData {
    let humidity:Double
    let type = SensorType.Humidity
    
    init(humidity:Double) {
        self.humidity = humidity
    }
    
    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["humidity"] = humidity
        return data
    }
}

struct BarometerData : SensorData {
    let temperature:Double
    let airPressure:Double
    let type = SensorType.Barometer
    
    init(temperature:Double, airPressure:Double) {
        self.temperature = temperature
        self.airPressure = airPressure
    }
    
    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["barometer"] = ["temperature":temperature,"airPressure":airPressure]
        return data
    }
}


struct AmbientLightData : SensorData {
    let brightness:Int
    let type = SensorType.AmbientLight
    
    init(brightness:Int) {
        self.brightness = brightness
    }
    
    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["brightness"] = [brightness]
        return data
    }
}


struct CaloriesData : SensorData {
    let calories:UInt
    let type = SensorType.Calories

    init(calories:UInt) {
        self.calories = calories
    }
    
    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["calories"] = [calories]
        return data
    }
}

struct GsrData : SensorData{
    let resistance:UInt
    let type = SensorType.Gsr
    
    init(resistance:UInt) {
        self.resistance = resistance
    }
    
    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["resistance"] = [resistance]
        return data
    }
}


struct PedometerData : SensorData{
    let steps:UInt
    let type = SensorType.Pedometer
    
    init(steps:UInt) {
        self.steps = steps
    }
    
    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["steps"] = [steps]
        return data
    }
}


struct HeartRateData : SensorData {
    let heartRate:UInt
    let type = SensorType.HeartRate
    
    init(heartRate:UInt) {
        self.heartRate = heartRate
    }

    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["heartRate"] = [heartRate]
        return data
    }
}

struct SkinTemperatureData : SensorData{
    let temperature:Double
    let type = SensorType.SkinTemperature
    
    init(temperature:Double) {
        self.temperature = temperature
    }
    
    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["temperature"] = [temperature]
        return data
    }
}

struct UVData : SensorData{
    let indexLevel:UInt
    let type = SensorType.UV
    
    init(indexLevel:UInt) {
        self.indexLevel = indexLevel
    }
    
    func asJSON() -> JSONDictionary {
        var data = (self as SensorData)._asJSON()
        data["indexLevel"] = [indexLevel]
        return data
    }
}