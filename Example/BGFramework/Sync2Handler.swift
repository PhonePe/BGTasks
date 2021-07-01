//
//  Sync2Handler.swift
//  BGFramework_Example
//
//  Created by Shridhara V on 17/03/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import BGFramework

class Sync2Handler {
    
    init() {
        if #available(iOS 13.0, *) {
            PPBGRegistrationController.shared.registerSyncItem(identifier: "id_2") { completion in
                self.sync(completion)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func sync(_ completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            completion(true)
        }
    }
}
