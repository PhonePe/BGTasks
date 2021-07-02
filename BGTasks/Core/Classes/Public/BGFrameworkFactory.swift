//
//  BGFrameworkFactory.swift
//  BGFramework
//
//  Created by Shridhara V on 17/03/21.
//

import Foundation

public protocol BGFrameworkFactoryProtocol {
    @available(iOS 13.0, *)
    static func registrationController() -> BGSyncRegistrationProtocol
}

final public class BGFrameworkFactory: BGFrameworkFactoryProtocol {
    
    @available(iOS 13.0, *)
    public static func registrationController() -> BGSyncRegistrationProtocol {
        return BGServiceBuilders.shared.registrationController
    }
}
