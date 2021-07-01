//
//  UtilityClasses.swift
//  BGFramework_Tests
//
//  Created by Shridhara V on 21/05/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

@testable import BGFramework
import BackgroundTasks

class TestBGConfigurationProvider: BGConfigurationProvidable {
    var scheduleSettings: BGConfigurationProvider.ScheduleSettings {
        return .init(enable: true)
    }
    
    let registrationData: BGConfigurationProvider.RegistrationData?
    
    init(registrationData: BGConfigurationProvider.RegistrationData?) {
        self.registrationData = registrationData
    }
}

class TestBGTaskSchedulerWrapper: BGTaskSchedulerWrapperProtocol {
    
    static func resetTestData() {
        pendingTaskRequests = []
        submitCalledIdentifiers = []
        launchHandlers = [:]
        
        registerCalledIdentifiers = []
    }
    
    static var submitCalledIdentifiers: Set<String> = []
    static var registerCalledIdentifiers: Set<String> = []
    private static var launchHandlers: [String: (BGTaskWrapperProtocol) -> Void] = [:]
    
    static var pendingTaskRequests: [TaskRequestWrapper] = []
    
    static func register(forTaskWithIdentifier identifier: String, using queue: DispatchQueue?, launchHandler: @escaping (BGTaskWrapperProtocol) -> Void) -> Bool {
        registerCalledIdentifiers.insert(identifier)
        launchHandlers[identifier] = launchHandler
        return true
    }
    
    static func submit(_ taskRequest: TaskRequestWrapper) throws {
        submitCalledIdentifiers.insert(taskRequest.identifier)
    }
    
    static func cancel(taskRequestWithIdentifier identifier: String) {
    }
    
    static func cancelAllTaskRequests() {
    }
    
    static func getPendingTaskRequests(completionHandler: @escaping ([TaskRequestWrapper]) -> Void) {
        completionHandler(pendingTaskRequests)
    }
    
    static func launchFor(identifier: String, type: Constants.BGTaskType, callExpiration delay: TimeInterval? = nil) {
        switch type {
        case .apprefresh:
            launchHandlers[identifier]?(TestBGAppRefreshTask(identifier: identifier, callExpiration: delay))
        case .processing:
            launchHandlers[identifier]?(TestBGProcessingTask(identifier: identifier, callExpiration: delay))
        }
    }
}

class TestBGTaskOrchestrator: BGTaskOrchestratorProtocol {
    static func canRegisterTask(identifier: String, bundle: BundleHelper.Type) -> Bool {
        return true
    }
    
    func canSchedule(for type: BGTaskSchedulerType, identifier: String, bundle: BundleHelper.Type) -> Bool {
        return true
    }
    
    let registeredUsecases: [BGSyncRegistrationData]
    
    required init(registeredUsecases: [BGSyncRegistrationData]) {
        self.registeredUsecases = registeredUsecases
    }
}

class TestBGTask: BGTaskWrapperProtocol {
    var identifier: String
    
    var expirationHandler: (() -> Void)? {
        didSet {
            Self.didExpirationHandlerSet = true
        }
    }
    
    func setTaskCompleted(success: Bool) {
        Self.setTaskCompletedMethodCalled = true
        Self.taskStatus = success
    }
    
    init(identifier: String, callExpiration delay: TimeInterval?) {
        self.identifier = identifier
        
        if let delay = delay {
            performWith(delay: delay) {
                self.expirationHandler?()
            }
        }
    }
    
    static var didExpirationHandlerSet = false
    static var setTaskCompletedMethodCalled = false
    static var taskStatus = false
    
    static func resetTestData() {
        didExpirationHandlerSet = false
        setTaskCompletedMethodCalled = false
        taskStatus = false
    }
}

class TestBGProcessingTask: TestBGTask, BGProcessingTaskWrapperProtocol {
}

class TestBGAppRefreshTask: TestBGTask, BGAppRefreshTaskWrapperProtocol {
}
