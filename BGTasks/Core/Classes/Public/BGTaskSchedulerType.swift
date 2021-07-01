//
//  BGTaskSchedulerType.swift
//  BGFramework
//
//  Created by Shridhara V on 19/03/21.
//

import Foundation

public enum BGTaskSchedulerType {
    case appRefreshTask
    case processingTaskWithConnectivityWithExternalPower
    case processingTaskWithConnectivityWithoutExternalPower
    case processingTaskWithoutConnectivity
}

extension BGTaskSchedulerType {
    var taskType: Constants.BGTaskType {
        switch self {
        case .appRefreshTask:
            return .apprefresh
        case .processingTaskWithConnectivityWithExternalPower,
             .processingTaskWithConnectivityWithoutExternalPower,
             .processingTaskWithoutConnectivity:
            return .processing
        }
    }
    
    var requiresNetworkConnectivity: Bool {
        switch self {
        case .appRefreshTask:
            return true
        case .processingTaskWithConnectivityWithExternalPower:
            return true
        case .processingTaskWithConnectivityWithoutExternalPower:
            return true
        case .processingTaskWithoutConnectivity:
            return false
        }
    }
    
    ///Consider default value for 'nil' returned value.
    var requiresExternalPower: Bool? {
        switch self {
        case .appRefreshTask:
            return nil
        case .processingTaskWithConnectivityWithExternalPower:
            return true
        case .processingTaskWithConnectivityWithoutExternalPower:
            return false
        case .processingTaskWithoutConnectivity:
            return nil
        }
    }
}
