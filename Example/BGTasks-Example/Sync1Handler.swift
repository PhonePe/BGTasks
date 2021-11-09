//
//  Sync1Handler.swift
//  BGFramework_Example
//
//  Created by Shridhara V on 17/03/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import BGTasks

class Sync1Handler {
    
    init() {
        if #available(iOS 13.0, *) {
            BGFrameworkFactory.registrationController().registerSyncItem(
                BGSyncRegistrationData(
                    identifier: "id_1",
                    configuration: BGSyncRegistrationData.Configuration(strategy: .onceADayAnyTime), handler: { completion in
                        self.sync(completion)
                    }))
        }
    }
    
    func sync(_ completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            completion(true)
        }
    }
}
