//
//  TripListViewModel.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 02/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverData
import DriveKitDBTripAccess

class TripListViewModel {
    var trips : [TripsByDate] = []
    var status: TripSyncStatus = .noError
    weak var delegate: TripsDelegate? = nil {
        didSet {
            if self.delegate != nil {
                self.fetchTrips()
            }
        }
    }
    
    public func fetchTrips() {
        DriveKitDriverData.shared.getTripsOrderByDateDesc(completionHandler: {status, trips in
            DispatchQueue.main.async {
                self.status = status
                self.trips = self.sortTrips(trips: trips)
                self.delegate?.onTripsAvailable()
            }
        })
    }
    
    
    func sortTrips(trips : [Trip]) -> [TripsByDate] {
        let tripSorted = trips.orderByDay(descOrder: DriveKitDriverDataUI.shared.dayTripDescendingOrder)
        return tripSorted
    }
}

protocol TripsDelegate : AnyObject {
    func onTripsAvailable()
}
