//
//  GameConditionType.swift
//  Colony
//
//  Created by Michael Rommel on 02.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

public protocol GameConditionType {
    
    var summary: String { get }
}

extension GameConditionType {
}

extension GameConditionType where Self: RawRepresentable, Self.RawValue: FixedWidthInteger {
}

protocol GameConditionDelegate {
    
    func won(with type: GameConditionType)
    func lost(with type: GameConditionType)
}
