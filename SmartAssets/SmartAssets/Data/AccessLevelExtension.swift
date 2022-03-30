//
//  AccessLevelExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 20.03.22.
//

import SmartAILibrary

extension AccessLevel {

    public func name() -> String {

        switch self {

        case .none: return "none"
        case .limited: return "limited"
        case .open: return "open"
        case .secret: return "secret"
        case .topSecret: return "top secret"
        }
    }

    public func iconTexture() -> String {

        switch self {

        case .none: return "accessLevel-none"
        case .limited: return "accessLevel-limited"
        case .open: return "accessLevel-open"
        case .secret: return "accessLevel-secret"
        case .topSecret: return "accessLevel-topSecret"
        }
    }
}
