//
//  BGSyncRegistrationProtocol.swift
//  BGFramework
//
//  Created by Shridhara V on 16/03/21.
//

import Foundation

public protocol BGSyncItemRegistrationDataProtocol: AnyObject {
    var registeredUsecases: [BGSyncRegistrationData] { get }
}

public protocol BGSyncRegistrationProtocol: BGSyncItemRegistrationDataProtocol {
    @available(iOS 13.0, *)
    func registerSyncItem(_ data: BGSyncRegistrationData)
    @available(iOS 13.0, *)
    func unRegisterSyncItem(_ identifier: String)
    @available(iOS 13.0, *)
    func resetAllSyncItems()
}

public typealias LaunchHandler = (@escaping (_ completed: Bool) -> Void) -> Void

public struct BGSyncRegistrationData {
    
    public let identifier: String
    public let configuration: Configuration
    public let handler: LaunchHandler
    
    public init(identifier: String,
                configuration: Configuration,
                handler: @escaping LaunchHandler) {
        self.identifier = identifier
        self.configuration = configuration
        self.handler = handler
    }
    
    public struct Configuration {
        public let strategy: Strategy
        public let requiresNetworkConnectivity: Bool
        
        public init(strategy: Strategy, requiresNetworkConnectivity: Bool = true) {
            self.strategy = strategy
            self.requiresNetworkConnectivity = requiresNetworkConnectivity
        }
        
        public enum Strategy: String, CaseIterable {
            case everyTime
            case onceADayAnyTime
            case every4Hours
            case every12Hours
            case every24Hours
        }
    }
}
