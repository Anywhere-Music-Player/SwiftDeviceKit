import SwiftDeviceKitSystem
let device = Device.current
print(device.description, device.cpu, device.screens.count, Device.allRealDevices.count)
print(device.systemName as Any, device.thermalState as Any, Device.volumeTotalCapacity as Any)
#if !os(tvOS)
print(device.batteryState as Any)
#endif
