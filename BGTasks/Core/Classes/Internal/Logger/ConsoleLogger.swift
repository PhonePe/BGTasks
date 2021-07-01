//
//  ConsoleLogger.swift
//  BGFramework
//
//  Created by Shridhara V on 25/05/21.
//

import Foundation

final class ConsoleLogger: BGLogger {
    
    func taskRegistered(withIdentifier identifier: String) {
        logToConsole("Task Registered for identifier: \(identifier)")
    }
    
    func failedToRegister(withIdentifier identifier: String) {
        logToConsole("failed to register for identifier: \(identifier)")
    }
    
    func taskScheduled(withIdentifier identifier: String) {
        logToConsole("Task scheduled for identifier: \(identifier)")
    }
    
    func failedToScheduleTask(withIdentifier identifier: String) {
        logToConsole("Failed to schedule task for identifier: \(identifier)")
    }
    
    func backgroundTaskLaunched(for taskData: BGTaskData) {
        logToConsole("Background task launched for \(taskData)")
    }
    
    func expirationHandler(for taskData: BGTaskData) {
        logToConsole("Expiration Handler called for \(taskData)")
    }
    
    func taskCompleted(for taskData: BGTaskData, timeTakenDuration: TimeInterval) {
        logToConsole("Task completed for \(taskData)")
    }
    
    func syncBegan(forUsecaseIdentifier identifier: String, inBGTask taskData: BGTaskData) {
        logToConsole("Sync began for usecase: \(identifier), in \(taskData)")
    }
    
    func syncEnded(forUsecaseIdentifier identifier: String, result: UsecaseSyncResult, inBGTask taskData: BGTaskData) {
        logToConsole("Sync ended for usecase: \(identifier), in \(taskData)")
    }
    
    private func logToConsole(_ message: String) {
        print(message)
    }
}
