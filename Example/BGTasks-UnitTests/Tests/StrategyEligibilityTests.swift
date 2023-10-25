//
//  StrategyEligibilityTests.swift
//  BGTasks-ExampleTests
//
//  Created by Shridhara V on 02/11/21.
//

import XCTest
import Nimble
import Quick
@testable import BGTasks
import BackgroundTasks
import Senpai

class StrategyEligibilityTests: QuickSpec {
    
    override func spec() {
        
        describe("eligibilty") {
            beforeEach {
                
            }
            
            for type in BGSyncRegistrationData.Configuration.Strategy.allCases {
                context("Type=\(type)") {
                    it("lastSyncTime=0") {
                        testWith(type: type, lastSyncTime: 0, expectedResult: true)
                    }
                    
                    it("lastSyncTime<0") {
                        testWith(type: type, lastSyncTime: -1, expectedResult: true)
                    }
                    
                    it("lastSyncTime as a future time") {
                        testWith(type: type, lastSyncTime: Date().timeIntervalSince1970 + 100, expectedResult: true)
                    }
                }
            }
            
            context("Type=everyTime") {
                it("lastSyncTime>0") {
                    testWith(type: .everyTime, lastSyncTime: 1, expectedResult: true)
                }
            }
            
            let hourBasedtypes: [BGSyncRegistrationData.Configuration.Strategy] = [.every4Hours, .every12Hours, .every24Hours]
            
            for type in hourBasedtypes {
                context("Type=\(type)") {
                    it("less than \(type.hours)hrs") {
                        let lastSyncTime = Date().timeIntervalSince1970 - secondsFor(hours: type.hours-1)
                        testWith(type: type, lastSyncTime: lastSyncTime, expectedResult: false)
                    }
                    
                    it("more than \(type.hours)hrs") {
                        let lastSyncTime = Date().timeIntervalSince1970 - secondsFor(hours: type.hours + 1)
                        testWith(type: type, lastSyncTime: lastSyncTime, expectedResult: true)
                    }
                }
            }
            
            context("Type=onceADayAnyTime") {
                it("on the same day") {
                    let lastSyncTime = Date().timeIntervalSince1970 - 10
                    testWith(type: .onceADayAnyTime, lastSyncTime: lastSyncTime, expectedResult: false)
                }
                
                it("on the previous day") {
                    let lastSyncTime = secondsFor(hours: 24)
                    testWith(type: .onceADayAnyTime, lastSyncTime: lastSyncTime, expectedResult: true)
                }
            }
        }
    }
}

extension BGSyncRegistrationData.Configuration.Strategy {
    var hours: TimeInterval {
        switch self {
        case .everyTime, .onceADayAnyTime:
            fatalError("Unknown")
        case .every4Hours:
            return 4
        case .every12Hours:
            return 12
        case .every24Hours:
            return 24
        }
    }
}

fileprivate func testWith(type: BGSyncRegistrationData.Configuration.Strategy,
                          lastSyncTime: TimeInterval,
                          expectedResult: Bool,
                          function: StaticString = #function,
                          line: UInt = #line) {
    let result = type.isItEligible(lastSyncTime: lastSyncTime)
    expecting(result).to(equal(expectedResult), description: testFunctionDescription(function: function, line: line))
}

struct Test {
    var clo: (() -> Void)?
    
    init(clo: (() -> Void)?) {
        self.clo = clo
    }
}
