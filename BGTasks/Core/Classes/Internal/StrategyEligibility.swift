//
//  StrategyEligibility.swift
//  BGTasks
//
//  Created by Shridhara V on 02/11/21.
//

import Foundation

extension BGSyncRegistrationData.Configuration.Strategy {
    func isItEligible(lastSyncTime: TimeInterval) -> Bool {
        let lastSyncDate = Date(timeIntervalSince1970: lastSyncTime)
        let currentDate = Date()
        
        guard lastSyncTime > 0 else {
            // It means this is the 1st time.
            return true
        }
        
        guard lastSyncDate <= currentDate else {
            // This will never happen unless user sets the device date to future.
            // Returnring true so that 'lastSyncTime' gets updated and works properly from then onwards.
            return true
        }
        
        let diff = currentDate.timeIntervalSince(lastSyncDate)
        
        switch self {
        case .everyTime:
            return true
        case .onceADayAnyTime:
            return lastSyncDate.dayOfMonth < currentDate.dayOfMonth
        case .every4Hours:
            let hours4InSeconds: TimeInterval = secondsFor(hours: 4)
            return diff >= hours4InSeconds
        case .every12Hours:
            let hours12InSeconds: TimeInterval = secondsFor(hours: 12)
            print("diff: \(diff), hours12InSeconds: \(hours12InSeconds)")
            return diff >= hours12InSeconds
        case .every24Hours:
            let hours24InSeconds: TimeInterval = secondsFor(hours: 24)
            return diff >= hours24InSeconds
        }
    }
}

func secondsFor(hours: TimeInterval) -> TimeInterval {
    return hours * 60 * 60
}

extension Date {
    var dayOfMonth: Int {
        return Calendar.current.dateComponents([.day], from: self).day ?? 0
    }
}
