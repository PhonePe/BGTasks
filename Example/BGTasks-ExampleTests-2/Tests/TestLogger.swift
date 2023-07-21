//
//  TestLogger.swift
//  BGFramework_Tests
//
//  Created by Shridhara V on 25/05/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
@testable import BGTasks

class TestLogger: BGLogger {
    
    func taskRegistered(withIdentifier identifier: String) {
        
    }
    
    func failedToRegister(withIdentifier identifier: String) {
        
    }
    
    func taskScheduled(withIdentifier identifier: String) {
        
    }
    
    func failedToScheduleTask(withIdentifier identifier: String) {
        
    }
    
    func backgroundTaskLaunched(for taskData: BGTaskData) {
        
    }
    
    func expirationHandler(for taskData: BGTaskData) {
        
    }
    
    func taskCompleted(for taskData: BGTaskData, timeTakenDuration: TimeInterval) {
        
    }
    
    func syncBegan(forUsecaseIdentifier identifier: String, inBGTask taskData: BGTaskData) {
        
    }
    
    func syncEnded(forUsecaseIdentifier identifier: String, result: UsecaseSyncResult, inBGTask taskData: BGTaskData) {
        
    }
}
