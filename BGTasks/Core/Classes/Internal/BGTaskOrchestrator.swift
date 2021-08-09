//
//  BGTaskOrchestrator.swift
//  BGFramework
//
//  Created by Shridhara V on 16/03/21.
//

import Foundation

protocol BGTaskOrchestratorProtocol {
    init(registeredUsecases: [BGSyncRegistrationData],
         bgRefreshStatusAvailability: BGRefreshStatusAvailability.Type)
    
    func canSchedule(for type: BGTaskSchedulerType, identifier: String, bundle: BundleHelper.Type) -> Bool
    
    static func canRegisterTask(identifier: String, bundle: BundleHelper.Type) -> Bool
}

extension BGTaskOrchestratorProtocol {
    init(registeredUsecases: [BGSyncRegistrationData]) {
        self.init(registeredUsecases: registeredUsecases,
                  bgRefreshStatusAvailability: AppBGRefreshStatusAvailability.self)
    }
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
    
    required init(registeredUsecases: [BGSyncRegistrationData],
                  bgRefreshStatusAvailability: BGRefreshStatusAvailability.Type) {
        self.registeredUsecases = registeredUsecases
        self.bgRefreshStatusAvailability = bgRefreshStatusAvailability
    }
    
    func canSchedule(for type: BGTaskSchedulerType, identifier: String, bundle: BundleHelper.Type) -> Bool {
        guard bgRefreshStatusAvailability.isAvailable else {
            return false
        }
        
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
    private let bgRefreshStatusAvailability: BGRefreshStatusAvailability.Type
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


protocol BGRefreshStatusAvailability {
    static var isAvailable: Bool { get }
}

enum AppBGRefreshStatusAvailability: BGRefreshStatusAvailability {
    static var isAvailable: Bool {
        
        let status: UIBackgroundRefreshStatus = performOnMainThreadIfPossible(perform: UIApplication.shared.backgroundRefreshStatus)
        
        return status == .available
    }
}

func performOnMainThreadIfPossible<T>(perform: @escaping @autoclosure () -> T,
                                      timeout: Double = 1) -> T {
    let tokenRefreshSemaphore = DispatchSemaphore(value: 0)
    
    var value: T!
    DispatchQueue.main.async {
        value = perform()
        tokenRefreshSemaphore.signal()
    }
    
    _ = tokenRefreshSemaphore.wait(timeout: .now() + timeout)
    
    if value == nil {
        value = perform()
    }
    
    return value
}
