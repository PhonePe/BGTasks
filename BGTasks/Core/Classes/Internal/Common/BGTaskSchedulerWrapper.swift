//
//  BGTaskSchedulerWrapper.swift
//  BGFramework
//
//  Created by Shridhara V on 17/03/21.
//

import Foundation
import BackgroundTasks

protocol BGTaskSchedulerWrapperProtocol {
    @discardableResult
    static func register(forTaskWithIdentifier identifier: String, using queue: DispatchQueue?, launchHandler: @escaping (BGTaskWrapperProtocol) -> Void) -> Bool

    static func submit(_ taskRequest: TaskRequestWrapper) throws

    static func cancel(taskRequestWithIdentifier identifier: String)
    static func cancelAllTaskRequests()

    static func getPendingTaskRequests(completionHandler: @escaping ([TaskRequestWrapper]) -> Void)
}

final class BGTaskSchedulerWrapper: BGTaskSchedulerWrapperProtocol {
    
    @discardableResult
    static func register(forTaskWithIdentifier identifier: String, using queue: DispatchQueue?, launchHandler: @escaping (BGTaskWrapperProtocol) -> Void) -> Bool {
        if #available(iOS 13.0, *) {
            return BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: queue, launchHandler: launchHandler)
        } else {
            return false
        }
    }
    
    static func submit(_ taskRequest: TaskRequestWrapper) throws {
        if #available(iOS 13.0, *) {
            if let bgTask = taskRequest as? BGTaskRequest {
                try BGTaskScheduler.shared.submit(bgTask)
            } else {
                assertionFailure("The given object is not a BGTaskRequest")
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    static func cancel(taskRequestWithIdentifier identifier: String) {
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: identifier)
        } else {
            // Fallback on earlier versions
        }
    }
    
    static func cancelAllTaskRequests() {
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.cancelAllTaskRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    static func getPendingTaskRequests(completionHandler: @escaping ([TaskRequestWrapper]) -> Void) {
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.getPendingTaskRequests(completionHandler: completionHandler)
        } else {
            // Fallback on earlier versions
        }
    }
}

protocol BGTaskWrapperProtocol {
    var identifier: String { get }
    var expirationHandler: (() -> Void)? { get set }
    func setTaskCompleted(success: Bool)
}

protocol BGProcessingTaskWrapperProtocol: BGTaskWrapperProtocol {
}

protocol BGAppRefreshTaskWrapperProtocol: BGTaskWrapperProtocol {
}

@available(iOS 13.0, *)
extension BGTask: BGTaskWrapperProtocol {
}

@available(iOS 13.0, *)
extension BGProcessingTask: BGProcessingTaskWrapperProtocol {
}

@available(iOS 13.0, *)
extension BGAppRefreshTask: BGAppRefreshTaskWrapperProtocol {
}

protocol TaskRequestWrapper {
    var identifier: String { get }
    var earliestBeginDate: Date? { get set }
}

@available(iOS 13.0, *)
extension BGTaskRequest: TaskRequestWrapper {
}
