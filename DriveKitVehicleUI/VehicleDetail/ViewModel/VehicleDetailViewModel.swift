//
//  VehicleDetailViewModel.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBVehicleAccess
import DriveKitVehicle

protocol VehicleDetailDelegate : AnyObject {
    func needUpdate()
}

class VehicleDetailViewModel {
    
    let vehicleDisplayName: String
    let vehicle: DKVehicle
    var groupFields: [DKVehicleGroupField] = []
    private var updatedFields: [DKVehicleField] = []
    private var updateFieldsValue: [String] = []
    private var errorFields: [DKVehicleField] = []
    
    weak var delegate : VehicleDetailDelegate? = nil
    
    init(vehicle: DKVehicle, vehicleDisplayName: String) {
        self.vehicle = vehicle
        self.vehicleDisplayName = vehicleDisplayName
        let groups = DKVehicleGroupField.allCases
        for groupField in groups {
            if groupField.isDisplayable(vehicle: vehicle) {
                groupFields.append(groupField)
            }
        }
    }
    
    func getField(groupField: DKVehicleGroupField) -> [DKVehicleField] {
        return groupField.getFields(vehicle: vehicle)
    }
    
    func getFieldValue(field: DKVehicleField) -> String {
        if let index = updatedFields.firstIndex(where: {$0.title == field.title}), index < updateFieldsValue.count {
            return updateFieldsValue[index]
        } else{
            return field.getValue(vehicle: vehicle) ?? ""
        }
    }
    
    func addUpdatedField(field: DKVehicleField, value: String) {
        delegate?.needUpdate()
        if let index = updatedFields.firstIndex(where: {$0.title == field.title}) {
            updatedFields.remove(at: index)
            updateFieldsValue.remove(at: index)
        }
        updatedFields.append(field)
        updateFieldsValue.append(value)
    }
    
    func mustUpdate() -> Bool {
        return !updatedFields.isEmpty
    }
    
    func updateFields(completion : @escaping (Bool) -> ()) {
        if updatedFields.count > 0 {
            errorFields.removeAll()
            updateField(pos: 0, completion: completion)
        } else {
            completion(true)
        }
    }
    
    private func updateField(pos: Int, completion : @escaping (Bool) -> ()) {
        if pos >= updatedFields.count {
            completion(self.updatedFields.count == 0)
        }else{
            let field = updatedFields[pos]
            field.onFieldUpdated(value: updateFieldsValue[pos], vehicle: vehicle, completion: { [weak self] status in
                var inc = 0
                if status {
                    self?.updatedFields.removeFirst()
                    self?.updateFieldsValue.removeFirst()
                } else{
                    self?.addErrorField(field: field)
                    inc = 1
                }
                self?.updateField(pos: inc, completion: completion)
            })
        }
    }
    
    func hasError(field: DKVehicleField) -> Bool {
        return errorFields.contains(where: {$0.title == field.title})
    }
    
    private func addErrorField(field: DKVehicleField) {
        if !hasError(field: field) {
            errorFields.append(field)
        }
    }
}
