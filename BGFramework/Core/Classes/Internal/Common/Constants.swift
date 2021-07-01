//
//  Constants.swift
//  BGFramework
//
//  Created by Shridhara V on 16/03/21.
//

import Foundation

struct Constants {
    
    enum BGTaskType: CustomStringConvertible {
        case apprefresh
        case processing
        
        var description: String {
            switch self {
            case .apprefresh:
                return "apprefresh"
            case .processing:
                return  "processing"
            }
        }
    }
    
    enum TaskCategory {
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
