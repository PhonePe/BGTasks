//
//  SenpaiExpectation.swift
//  BGFramework_Tests
//
//  Created by Shridhara V on 02/07/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Nimble

//public extension TimeInterval {
//
//    init(dispatchTimeInterval: DispatchTimeInterval) {
//        switch dispatchTimeInterval {
//        case .seconds(let value):
//            self = Double(value)
//        case .milliseconds(let value):
//            self = Double(value) / 1_000
//        case .microseconds(let value):
//            self = Double(value) / 1_000_000
//        case .nanoseconds(let value):
//            self = Double(value) / 1_000_000_000
//        case .never:
//            self = 0
//        @unknown default:
//            self = 0
//        }
//    }
//}
//
//public class SenpaiExpectation<T> {
//    public init(expectation: Expectation<T>) {
//        self.expectation = expectation
//    }
//    
//    public func finally(_ predicate: Predicate<T>,
//                        timeout: TimeInterval = TimeInterval(dispatchTimeInterval: AsyncDefaults.timeout),
//                        pollInterval: TimeInterval = TimeInterval(dispatchTimeInterval:AsyncDefaults.pollInterval),
//                        description: String? = nil) {
//        
//        self.expectation.toEventually(predicate, timeout: DispatchTimeInterval.seconds(Int(timeout)), pollInterval: DispatchTimeInterval.milliseconds(Int(pollInterval)), description: description)
//    }
//    
//    public func finallyNot(_ predicate: Predicate<T>,
//                           timeout: TimeInterval = TimeInterval(dispatchTimeInterval: AsyncDefaults.timeout),
//                           pollInterval: TimeInterval = TimeInterval(dispatchTimeInterval:AsyncDefaults.pollInterval),
//                           description: String? = nil) {
//        expectation.toEventuallyNot(predicate, timeout: DispatchTimeInterval.seconds(Int(timeout)), pollInterval: DispatchTimeInterval.milliseconds(Int(pollInterval)), description: description)
//    }
//    
//    public func to(_ predicate: Predicate<T>, description: String? = nil) {
//        expectation.to(predicate, description: description)
//    }
//
//    public func toNot(_ predicate: Predicate<T>, description: String? = nil) {
//        expectation.toNot(predicate, description: description)
//    }
//    
//    public func notTo(_ predicate: Predicate<T>, description: String? = nil) {
//        toNot(predicate, description: description)
//    }
//    
//    private let expectation: Expectation<T>
//}
