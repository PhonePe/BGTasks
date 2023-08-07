//
//  MockNotificationCenter.swift
//  BGFramework_Tests
//
//  Created by Shridhara V on 02/07/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

public final class MockNotificationCenter: NotificationCenter {
    public private(set) var postedNotificationNames: [(name: Notification.Name, obj: Any?, userInfo: [AnyHashable: Any]?)] = []
    private var callSuperMethods = false
    
    override public func post(_ notification: Notification) {
        postedNotificationNames.append((notification.name, notification.object, notification.userInfo))
        if callSuperMethods {
            super.post(notification)
        }
    }
    
    override public func post(name aName: NSNotification.Name, object anObject: Any?) {
        postedNotificationNames.append((aName, anObject, nil))
        if callSuperMethods {
            super.post(name: aName, object: anObject)
        }
    }
    
    override public func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]? = nil) {
        postedNotificationNames.append((aName, anObject, aUserInfo))
        if callSuperMethods {
            super.post(name: aName, object: anObject, userInfo: aUserInfo)
        }
    }
    
    public override init() {
        super.init()
    }
    
    public init(callSuperMethods: Bool) {
        self.callSuperMethods = callSuperMethods
        super.init()
    }
}
