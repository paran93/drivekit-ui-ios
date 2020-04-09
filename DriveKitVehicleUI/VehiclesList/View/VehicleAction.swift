//
//  VehicleOption.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccess

public enum VehicleAction : String, CaseIterable  {
    case show
    case rename
    case replace
    case delete
    
    func title() -> String {
        switch (self) {
        case .delete:
            return "dk_vehicle_delete".dkVehicleLocalized()
        case .replace:
            return "dk_vehicle_replace".dkVehicleLocalized()
        case .show:
            return "dk_vehicle_show".dkVehicleLocalized()
        case .rename:
            return "dk_vehicle_rename".dkVehicleLocalized()
        }
    }
    
    func alertAction(pos: Int, viewModel: VehiclesListViewModel) -> UIAlertAction {
        var completionHandler : ((UIAlertAction) -> Void)? = nil
        switch self {
        case .show:
            completionHandler = {  _ in
                let detailVC = VehicleDetailVC(viewModel: VehicleDetailViewModel(vehicle: viewModel.vehicles[pos], vehicleDisplayName: viewModel.vehicleName(pos: pos)))
                viewModel.delegate?.pushViewController(detailVC, animated: true)
            }
        case .rename:
            completionHandler = {  _ in
                viewModel.renameVehicle(pos: pos)
            }
        case .replace:
            completionHandler = {  _ in
                viewModel.delegate?.showVehiclePicker(vehicle: viewModel.vehicles[pos])
            }
        case .delete:
            completionHandler = {  _ in
                viewModel.deleteVehicle(pos: pos)
            }
        }
        return UIAlertAction(title: self.title(), style: .default, handler: completionHandler)
    }
    
}
