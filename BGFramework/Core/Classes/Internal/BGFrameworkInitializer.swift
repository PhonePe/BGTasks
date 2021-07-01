//
//  BGFrameworkInitializer.swift
//  BGFramework
//
//  Created by Shridhara V on 25/03/21.
//

import Foundation

final class BGFrameworkInitializer {
    
    init() {
        _ = BGServiceBuilders.shared.coreDataStackProvider
    }
}
