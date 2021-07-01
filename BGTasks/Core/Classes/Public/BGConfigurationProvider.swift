//
//  BGConfigurationProvider.swift
//  BGFramework
//
//  Created by Shridhara V on 15/03/21.
//

import Foundation

public protocol BGConfigurationProtocol {
    var configurationType: BGConfigurationProvider.ConfigurationType { get }
}

protocol BGConfigurationProvidable {
    var registrationData: BGConfigurationProvider.RegistrationData? { get }
    var scheduleSettings: BGConfigurationProvider.ScheduleSettings { get }
}

final public class BGConfigurationProvider: BGConfigurationProvidable {
    public static let shared = BGConfigurationProvider()
    
    public var registrationData: RegistrationData? {
        return configuration[.registrationData] as? RegistrationData
    }
    
    public var scheduleSettings: ScheduleSettings {
        return (configuration[.scheduleSettings] as? ScheduleSettings) ?? ScheduleSettings(enable: false)
    }
    
    public func configure(config: BGConfigurationProtocol) {
        switch config.configurationType {
        case .registrationData:
            configureRegistrationData(config: config as? RegistrationData)
        case .scheduleSettings:
            configureScheduleSettings(config: config as? ScheduleSettings)
        }
    }
    
    private init() {
    }
    
    private var configuration: [ConfigurationType: BGConfigurationProtocol] = [:]
    private var centralManager: BGFrameworkCentralManager?
    private let initializer = BGFrameworkInitializer()
}

extension BGConfigurationProvider {
    public enum ConfigurationType {
        case registrationData
        case scheduleSettings
    }
    
    public struct RegistrationData: BGConfigurationProtocol {
        public let configurationType: ConfigurationType = .registrationData

        public let permittedIdentifiers: [BGTaskSchedulerType: String]
        
        public let processingTaskScheduleInterval: TimeInterval //Default 2hrs
        public let appRefreshTaskScheduleInterval: TimeInterval //Default 2hrs
        public let historyDataTTLInDays: Int //Default 7 days
        public let maxConcurrentSyncCount: Int //Default 4
        
        public init(permittedIdentifiers: [BGTaskSchedulerType: String],
                    processingTaskScheduleInterval: TimeInterval? = nil,
                    appRefreshTaskScheduleInterval: TimeInterval? = nil,
                    timeToLiveHistoryData: Int? = nil,
                    maxConcurrentSyncCount: Int? = nil) {
            
            self.permittedIdentifiers = permittedIdentifiers
            
            self.processingTaskScheduleInterval = processingTaskScheduleInterval ?? (2 * 60 * 60)
            self.appRefreshTaskScheduleInterval = appRefreshTaskScheduleInterval ?? (2 * 60 * 60)
            self.historyDataTTLInDays = timeToLiveHistoryData ?? 7
            self.maxConcurrentSyncCount = maxConcurrentSyncCount ?? 4
        }
    }
    
    public struct ScheduleSettings: BGConfigurationProtocol {
        public let configurationType: ConfigurationType = .scheduleSettings
        
        public let enable: Bool
        
        public init(enable: Bool) {
            self.enable = enable
        }
    }
}

// MARK: - Private
extension BGConfigurationProvider {
    
    private func configureRegistrationData(config: RegistrationData?) {
        guard let config = config else {
            return
        }
        
        if self.centralManager != nil {
            assertionFailure("Can't register more than once")
        }
        
        configuration[.registrationData] = config
        
        self.centralManager = BGFrameworkCentralManager(
            registrationDataController: BGServiceBuilders.shared.registrationController,
            configurationProvidable: self,
            moc: BGServiceBuilders.shared.coreDataStackProvider.newBackgroundContext
        )
        
        let ttl = Int64(Date().timeIntervalSince1970) - Int64(config.historyDataTTLInDays * 24 * 60 * 60)
        CDHistoryUtil.deletePastHistoryItemsUpto(createdAt: ttl,
                                                 moc: BGServiceBuilders.shared.coreDataStackProvider.newBackgroundContext)
    }
    
    private func configureScheduleSettings(config: ScheduleSettings?) {
        guard let config = config else {
            return
        }
        
        configuration[.scheduleSettings] = config
        
        self.centralManager?.scheduleRequiredTasks()
    }
}
