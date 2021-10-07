//
//  Constants.swift
//  BGFramework
//
//  Created by Shridhara V on 16/03/21.
//

import Foundation

public struct Constants {
    
    public enum BGTaskType: CustomStringConvertible {
        case apprefresh
        case processing
        case silentPN
        
        public var description: String {
            switch self {
            case .apprefresh:
                return "apprefresh"
            case .processing:
                return  "processing"
            case .silentPN:
                return "silentPN"
            }
        }
    }
    
    enum TaskCategory: CaseIterable {
        case connectivityTasks
        case withoutConnectivityTasks
    }
}

extension Constants.TaskCategory {
    var requiresNetworkConnectivity: Bool {
        switch self {
        case .connectivityTasks:
            return true
        case .withoutConnectivityTasks:
            return false
        }
    }
}

func debugLog(_ message: @autoclosure () -> String) {
//    print(message())
}
