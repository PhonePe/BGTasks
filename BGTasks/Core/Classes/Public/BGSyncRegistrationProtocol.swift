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
    func registerSyncItem(_ data: BGSyncRegistrationData)
    func unRegisterSyncItem(_ identifier: String)
    func resetAllSyncItems()
}

public typealias LaunchHandler = (@escaping (_ completed: Bool) -> Void) -> Void

public struct BGSyncRegistrationData {
    
    public let identifier: String
    public let configuration: Configuration
    public let handler: LaunchHandler
    
    public init(identifier: String,
                configuration: Configuration = .init(),
                handler: @escaping LaunchHandler) {
        self.identifier = identifier
        self.configuration = configuration
        self.handler = handler
    }
    
    public struct Configuration {
        public let strategy: Strategy
        public let requiresNetworkConnectivity: Bool
        
        public init(strategy: Strategy = .everyTime, requiresNetworkConnectivity: Bool = true) {
            self.strategy = strategy
            self.requiresNetworkConnectivity = requiresNetworkConnectivity
        }
        
        public enum Strategy: String, Decodable {
            case everyTime
        }
    }
}
