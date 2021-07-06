//
//  BGLogger.swift
//  BGFramework
//
//  Created by Shridhara V on 25/05/21.
//

import Foundation

public protocol BGLogger {
    func taskRegistered(withIdentifier identifier: String)
    func failedToRegister(withIdentifier identifier: String)
    
    func taskScheduled(withIdentifier identifier: String)
    func failedToScheduleTask(withIdentifier identifier: String)
    
    func backgroundTaskLaunched(for taskData: BGTaskData)
    func expirationHandler(for taskData: BGTaskData)
    func taskCompleted(for taskData: BGTaskData, timeTakenDuration: TimeInterval)
    
    func syncBegan(forUsecaseIdentifier identifier: String, inBGTask taskData: BGTaskData)
    func syncEnded(forUsecaseIdentifier identifier: String, result: UsecaseSyncResult, inBGTask taskData: BGTaskData)
}

public struct BGTaskData: CustomStringConvertible {
    public let taskUniqueId: String
    public let identifier: String
    public let taskType: Constants.BGTaskType
    
    public var description: String {
        return "BGTask(taskUniqueId: \(taskUniqueId), identifier: \(identifier), taskType: \(taskType))"
    }
}

public struct UsecaseSyncResult {
    public let status: Bool
    public let timeTakenDuration: TimeInterval
}
