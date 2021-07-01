//
//  BGFrameworkFactory.swift
//  BGFramework
//
//  Created by Shridhara V on 17/03/21.
//

import Foundation

public protocol BGFrameworkFactoryProtocol {
    static func registrationController() -> BGSyncRegistrationProtocol
}

final public class BGFrameworkFactory: BGFrameworkFactoryProtocol {
    
    public static func registrationController() -> BGSyncRegistrationProtocol {
        return BGServiceBuilders.shared.registrationController
    }
}
