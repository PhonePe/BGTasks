//
//  Bundle+BG.swift
//  BGFramework
//
//  Created by Shridhara V on 24/03/21.
//

import Foundation

extension Bundle {
    static func frameworkBundle() -> Bundle {
        #if SPM_BUILD
        return Bundle.module
        #else
        let bundle = Bundle(for: BundleToken.self)
        return bundle
        #endif
    }
}

#if !SPM_BUILD
private final class BundleToken {
    private init() {
        //This class is used just to create Bundle object.
    }
}
#endif
