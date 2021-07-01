//
//  BGLoggerManager.swift
//  BGFramework
//
//  Created by Shridhara V on 25/05/21.
//

import Foundation

final class BGLoggerManager {
    
    static let shared = BGLoggerManager()
    
    func register(logger: BGLogger) {
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
    func taskRegistered(withIdentifier identifier: String) {
        loggers.forEach {
            $0.taskRegistered(withIdentifier: identifier)
        }
    }
    
    func failedToRegister(withIdentifier identifier: String) {
        loggers.forEach {
            $0.failedToRegister(withIdentifier: identifier)
        }
    }
    
    func taskScheduled(withIdentifier identifier: String) {
        loggers.forEach {
            $0.taskScheduled(withIdentifier: identifier)
        }
    }
    
    func failedToScheduleTask(withIdentifier identifier: String) {
        loggers.forEach {
            $0.failedToScheduleTask(withIdentifier: identifier)
        }
    }
    
    func backgroundTaskLaunched(for taskData: BGTaskData) {
        loggers.forEach {
            $0.backgroundTaskLaunched(for: taskData)
        }
    }
    
    func expirationHandler(for taskData: BGTaskData) {
        loggers.forEach {
            $0.expirationHandler(for: taskData)
        }
    }
    
    func taskCompleted(for taskData: BGTaskData, timeTakenDuration: TimeInterval) {
        loggers.forEach {
            $0.taskCompleted(for: taskData, timeTakenDuration: timeTakenDuration)
        }
    }
    
    func syncBegan(forUsecaseIdentifier identifier: String, inBGTask taskData: BGTaskData) {
        loggers.forEach {
            $0.syncBegan(forUsecaseIdentifier: identifier, inBGTask: taskData)
        }
    }
    
    func syncEnded(forUsecaseIdentifier identifier: String, result: UsecaseSyncResult, inBGTask taskData: BGTaskData) {
        loggers.forEach {
            $0.syncEnded(forUsecaseIdentifier: identifier, result: result, inBGTask: taskData)
        }
    }
    
}
