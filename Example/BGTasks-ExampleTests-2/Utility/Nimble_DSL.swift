//
//  Nimble_DSL.swift
//  BGFramework_Tests
//
//  Created by Shridhara V on 02/07/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Nimble

public func expecting<T>(_ expression: @autoclosure @escaping () throws -> T?,
                         file: FileString = #file,
                         line: UInt = #line) -> SenpaiExpectation<T> {
    return SenpaiExpectation(expectation: expect(file: file, line: line, try expression()))
}

public func expecting<T>(_ file: FileString = #file,
                         line: UInt = #line,
                         expression: @escaping () throws -> T?) -> SenpaiExpectation<T> {
    
    // swiftlint:disable all
    return SenpaiExpectation(expectation:
        expect(try expression()))
}

public func waitTill(timeout: TimeInterval = 1, action: @escaping (@escaping () -> Void) -> Void) {
    waitUntil(timeout: DispatchTimeInterval.seconds(Int(timeout)), action: action)
}

public func waitUntil(timeout: TimeInterval = 1, action: @escaping (@escaping () -> Void) -> Void) {
    waitUntil(timeout: DispatchTimeInterval.seconds(Int(timeout)), action: action)
}
