//
//  BGTaskOrchestrator.swift
//  BGFramework
//
//  Created by Shridhara V on 16/03/21.
//

import Foundation

protocol BGTaskOrchestratorProtocol {
    init(registeredUsecases: [BGSyncRegistrationData])
    
    func canSchedule(for type: BGTaskSchedulerType, identifier: String, bundle: BundleHelper.Type) -> Bool
    
    static func canRegisterTask(identifier: String, bundle: BundleHelper.Type) -> Bool
}

extension BGTaskOrchestratorProtocol {
    func canSchedule(for type: BGTaskSchedulerType, identifier: String) -> Bool {
        return self.canSchedule(for: type, identifier: identifier, bundle: MainBundleHelper.self)
    }
    
    static func canRegisterTask(identifier: String) -> Bool {
        return canRegisterTask(identifier: identifier, bundle: MainBundleHelper.self)
    }
}

final class BGTaskOrchestrator: BGTaskOrchestratorProtocol {
    
    required init(registeredUsecases: [BGSyncRegistrationData]) {
        self.registeredUsecases = registeredUsecases
    }
    
    func canSchedule(for type: BGTaskSchedulerType, identifier: String, bundle: BundleHelper.Type) -> Bool {
        guard Self.canRegisterTask(identifier: identifier, bundle: bundle) else {
            return false
        }
        
        let anyUsecasesFound = self.registeredUsecases.contains { $0.configuration.requiresNetworkConnectivity == type.requiresNetworkConnectivity }
        return anyUsecasesFound
    }
    
    static func canRegisterTask(identifier: String, bundle: BundleHelper.Type) -> Bool {
        let permittedIdentifiers = bundle.permittedIdentifiers()
        return permittedIdentifiers.contains(identifier)
    }
    
    private let registeredUsecases: [BGSyncRegistrationData]
}

protocol BundleHelper {
    static func permittedIdentifiers() -> [String]
}

enum MainBundleHelper: BundleHelper {
    static func permittedIdentifiers() -> [String] {
        guard let identifiers = Bundle.main.object(forInfoDictionaryKey: "BGTaskSchedulerPermittedIdentifiers") as? [String] else {
            return []
        }
        
        return identifiers
    }
}
