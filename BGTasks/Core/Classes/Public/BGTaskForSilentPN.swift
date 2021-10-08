//
//  BGTaskForSilentPN.swift
//  BGTasks
//
//  Created by Shridhara V on 07/10/21.
//

import Foundation

public class BGTaskForSilentPN: BGTaskWrapperProtocol {
    
    public var expirationHandler: (() -> Void)?
    
    let identifier = "com.silent.pn"
    
    func setTaskCompleted(success: Bool) {
        expirationHandler = nil
    }
    
    public init() {
    }
}
