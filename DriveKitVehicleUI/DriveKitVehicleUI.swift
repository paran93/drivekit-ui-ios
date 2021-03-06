//
//  DriveKitVehiclUI.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 07/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitCommonUI
import DriveKitVehicle
import DriveKitDBVehicleAccess

public class DriveKitVehicleUI {
    
    public static let shared = DriveKitVehicleUI()
    
    var vehicleTypes : [DKVehicleType] = [.car]
    var brands : [DKVehicleBrand] = DKVehicleBrand.allCases
    var categories : [DKVehicleCategory] = DKVehicleCategory.allCases
    var categoryConfigType : DKCategoryConfigType = .bothConfig
    var vehicleEngineIndexes : [DKVehicleEngineIndex] = DKVehicleEngineIndex.allCases
    var brandsWithIcons : Bool = true
    
    var canAddVehicle: Bool = true
    var maxVehicles: Int? = nil
    var canRemoveBeacon : Bool = true
    
    var vehicleActions : [DKVehicleActionItem] = DKVehicleAction.allCases
    var detectionModes: [DKDetectionMode] = [.disabled, .gps, .beacon, .bluetooth]
    var customFields = [DKVehicleGroupField: [DKVehicleField]]()
    
    var beaconDiagnosticEmail : DKContentMail? = nil
    var beaconDiagnosticSupportLink: String? = nil
    var vehiclePickerExtraStep : DKVehiclePickerExtraStep? = nil
    
    private init() {}
    
    public func initialize() {
        DriveKitNavigationController.shared.vehicleUI = self
    }
    
    public func configureVehicleTypes(types: [DKVehicleType]){
        if !types.isEmpty {
            self.vehicleTypes = types
        }
    }
    
    public func configureBrands(brands : [DKVehicleBrand]) {
        if !brands.isEmpty {
            self.brands = brands
        }
    }
    
    public func configureCategories(categories: [DKVehicleCategory]) {
        if !categories.isEmpty {
            self.categories = categories
        }
    }
    
    public func configureCategoryConfigType(type : DKCategoryConfigType) {
        self.categoryConfigType = type
    }
    
    public func configureEngineIndexes(engineIndexes: [DKVehicleEngineIndex]) {
        if !engineIndexes.isEmpty {
            self.vehicleEngineIndexes = engineIndexes
        }
    }

    public func showBrandsWithIcons(show : Bool) {
        self.brandsWithIcons = show
    }
    
    public func enableAddVehicle(enable: Bool) {
        self.canAddVehicle = enable
    }
    
    public func configureMaxVehicles(max: Int?) {
        if let max = max, max >= 0 {
            self.maxVehicles = max
        }
    }
    
    public func configureDetectionModes(detectionModes: [DKDetectionMode]) {
        if !detectionModes.isEmpty {
            self.detectionModes = detectionModes
        }
    }
    
    public func configureVehicleActions(vehicleActions : [DKVehicleActionItem]) {
        self.vehicleActions = vehicleActions
    }
    
    public func addCustomVehicleField(groupField: DKVehicleGroupField, fieldsToAdd: [DKVehicleField]) {
        self.customFields[groupField] = fieldsToAdd
    }
    
    public func configureBeaconDetailEmail(beaconDiagnosticEmail: DKContentMail?) {
        self.beaconDiagnosticEmail = beaconDiagnosticEmail
    }
    
    public func configureBeaconDiagnosticSupportURL(url: String?) {
        self.beaconDiagnosticSupportLink = url
    }
    
    public func enableRemoveBeacon(canRemoveBeacon: Bool){
        self.canRemoveBeacon = canRemoveBeacon
    }
    
    public func configureVehiclePickerExtraStep(extarStep: DKVehiclePickerExtraStep) {
        self.vehiclePickerExtraStep = extarStep
    }
}

extension Bundle {
    static let vehicleUIBundle = Bundle(identifier: "com.drivequant.drivekit-vehicle-ui")
}

extension String {
    public func dkVehicleLocalized() -> String {
        return self.dkLocalized(tableName: "DKVehicleLocalizable", bundle: Bundle.vehicleUIBundle ?? .main)
    }
}

extension DriveKitVehicleUI : DriveKitVehicleUIEntryPoint {
    public func getVehicleListViewController() -> UIViewController {
        return VehiclesListVC()
    }
    
    public func getVehicleDetailViewController(vehicleId: String, completion : @escaping (UIViewController?) -> ()) {
        DriveKitVehicle.shared.getVehicle(vehicleId: vehicleId, completionHandler: {status, vehicle in
            DispatchQueue.main.async {
                if let vehicle = vehicle {
                    let viewModel = VehicleDetailViewModel(vehicle: vehicle, vehicleDisplayName: vehicle.computeName())
                    completion(VehicleDetailVC(viewModel: viewModel))
                }else{
                    completion(nil)
                }
            }
        })
    }
    
    public func getVehicleNameWith(vehicleId: String, completion: @escaping (String?) -> ()) {
        DriveKitVehicle.shared.getVehicle(vehicleId: vehicleId, completionHandler: {status, vehicle in
            completion(vehicle?.computeName())
        })
    }
    
    public func getBeaconDiagnosticViewController(parentView: UIViewController) -> UIViewController {
        let vehicles = DriveKitVehicle.shared.vehiclesQuery().noFilter().query().execute()
        var uuid : String? = nil
        for vehicle in vehicles {
            if let beacon = vehicle.beacon {
                uuid = beacon.proximityUuid
                break
            }
        }
        if let proxUuid = uuid {
            let beacon = DKBeacon(uniqueId: nil, proximityUuid: proxUuid, major: -1, minor: -1)
            let viewModel = BeaconViewModel(scanType: .diagnostic, beacon: beacon, vehicles: vehicles)
            return BeaconScannerVC(viewModel: viewModel, step: .initial, parentView: parentView)
        } else {
            let viewModel = BeaconViewModel(scanType: .diagnostic)
            return BeaconScannerVC(viewModel: viewModel, step: .beaconNotConfigured, parentView: parentView)
        }
    }
}

public protocol DKVehiclePickerExtraStep {
    func viewController(vehicleId: String) -> UIViewController?
}
