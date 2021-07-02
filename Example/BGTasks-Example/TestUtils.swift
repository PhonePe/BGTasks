//
//  TestUtils.swift
//  BGFramework
//
//  Created by Shridhara V on 02/07/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

final public class TestUtils {
    #if DEBUG
    public static let isRunningTest = ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil
    #else
    public static let isRunningTest = false
    #endif
    
    private init() {
        //Empty private init to avoid external intialization
    }
}
