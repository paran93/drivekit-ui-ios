//
//  DKImages.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 28/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public enum DKImages : String {
    case ecoAccel = "dk_common_eco_accel",
    info = "dk_common_info",
    infoFilled = "dk_common_info_filled",
    ecoDecel = "dk_common_eco_decel",
    ecoMaintain = "dk_common_eco_maintain",
    ecoDriving = "dk_common_ecodriving",
    ecoDrivingFilled = "dk_common_ecodriving_filled",
    safetyAccel = "dk_common_safety_accel",
    safetyDecel = "dk_common_safety_decel",
    safetyAdherence = "dk_common_safety_adherence",
    safety = "dk_common_safety",
    safetyFilled = "dk_common_safety_filled",
    distraction = "dk_common_distraction",
    distractionFilled = "dk_common_distraction_filled"
    
    public var image : UIImage? {
        if let image = UIImage(named: self.rawValue, in: .main, compatibleWith: nil) {
            return image.withRenderingMode(.alwaysTemplate)
        } else {
            return UIImage(named: self.rawValue, in: .driveKitCommonUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        }
    }
}
