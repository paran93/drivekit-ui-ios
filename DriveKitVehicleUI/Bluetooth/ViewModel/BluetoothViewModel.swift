//
//  BluetoothViewModel.swift
//  IFPClient
//
//  Created by Meryl Barantal on 03/01/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitTripAnalysis
import DriveKitVehicle
import DriveKitDBVehicleAccess

public class BluetoothViewModel {

    private let vehicle : DKVehicle
    var devices : [BluetoothData] = []
    var device : BluetoothData? = nil
    
    init(vehicle: DKVehicle) {
        self.vehicle = vehicle
    }
    
    var vehicleName : String {
        return vehicle.computeName()
    }
    
    var bluetoothName : String {
        return device?.name ?? ""
    }

    func getBluetoothDevices() -> [BluetoothData] {
        self.devices = DriveKitTripAnalysis.shared.getAvailableBluetoothDevices()
        return self.devices
    }
    
    func addBluetoothToVehicle(pos: Int, completion : @escaping (DKVehicleBluetoothStatus) -> ()){
        device = self.devices[pos]
        let bluetooth = DKBluetooth(name: device?.name ?? "", macAddress: device?.macAddress ?? "")
        DriveKitVehicle.shared.addBluetooth(vehicleId: vehicle.vehicleId, bluetooth: bluetooth, completionHandler: completion)
    }
    
    
}
