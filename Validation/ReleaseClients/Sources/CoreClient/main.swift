import SwiftDeviceKitCore
let device = Device.current
print(device.description, device.cpu, device.screens.count, Device.allRealDevices.count)
