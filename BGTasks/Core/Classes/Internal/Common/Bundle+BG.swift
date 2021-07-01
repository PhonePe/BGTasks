//
//  Bundle+BG.swift
//  BGFramework
//
//  Created by Shridhara V on 24/03/21.
//

import Foundation

extension Bundle {
    static func frameworkBundle() -> Bundle {
        let bundle = Bundle(for: BundleToken.self)
        return bundle
    }
}

private final class BundleToken {
    private init() {
        //This class is used just to create Bundle object.
    }
}
