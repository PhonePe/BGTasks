//
//  GenericSyncHandler.swift
//  BGFramework_Example
//
//  Created by Shridhara V on 26/03/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import BGFramework

class GenericSyncHandler {
    
    init(identifier: String, duration: TimeInterval, requiresNetworkConnectivity: Bool) {
        if #available(iOS 13.0, *) {
            PPBGRegistrationController.shared.registerSyncItem(identifier: identifier) { completion in
                self.sync(duration: duration, completion: completion)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func sync(duration: TimeInterval, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + duration) {
            completion(true)
        }
    }
}
