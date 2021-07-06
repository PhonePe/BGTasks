//
//  BGLoggerManager.swift
//  BGFramework
//
//  Created by Shridhara V on 25/05/21.
//

import Foundation

final public class BGLoggerManager {
    
    public static let shared = BGLoggerManager()
    
    public func register(logger: BGLogger) {
        if allowMultipleLoggers {
            self.loggers.append(logger)
        } else {
            self.loggers = [logger]
        }
    }
    
    private init() {
        #if DEBUG
        loggers.append(ConsoleLogger())
        #endif
    }
    
    private var loggers = [BGLogger]()
    private let allowMultipleLoggers = false
}

extension BGLoggerManager: BGLogger {
    public func taskRegistered(withIdentifier identifier: String) {
        loggers.forEach {
            $0.taskRegistered(withIdentifier: identifier)
        }
    }
    
    public func failedToRegister(withIdentifier identifier: String) {
        loggers.forEach {
            $0.failedToRegister(withIdentifier: identifier)
        }
    }
    
    public func taskScheduled(withIdentifier identifier: String) {
        loggers.forEach {
            $0.taskScheduled(withIdentifier: identifier)
        }
    }
    
    public func failedToScheduleTask(withIdentifier identifier: String) {
        loggers.forEach {
            $0.failedToScheduleTask(withIdentifier: identifier)
        }
    }
    
    public func backgroundTaskLaunched(for taskData: BGTaskData) {
        loggers.forEach {
            $0.backgroundTaskLaunched(for: taskData)
        }
    }
    
    public func expirationHandler(for taskData: BGTaskData) {
        loggers.forEach {
            $0.expirationHandler(for: taskData)
        }
    }
    
    public func taskCompleted(for taskData: BGTaskData, timeTakenDuration: TimeInterval) {
        loggers.forEach {
            $0.taskCompleted(for: taskData, timeTakenDuration: timeTakenDuration)
        }
    }
    
    public func syncBegan(forUsecaseIdentifier identifier: String, inBGTask taskData: BGTaskData) {
        loggers.forEach {
            $0.syncBegan(forUsecaseIdentifier: identifier, inBGTask: taskData)
        }
    }
    
    public func syncEnded(forUsecaseIdentifier identifier: String, result: UsecaseSyncResult, inBGTask taskData: BGTaskData) {
        loggers.forEach {
            $0.syncEnded(forUsecaseIdentifier: identifier, result: result, inBGTask: taskData)
        }
    }
}
