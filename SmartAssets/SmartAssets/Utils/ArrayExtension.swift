//
//  ArrayExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 02.12.20.
//

import Foundation
import SmartAILibrary

extension Array {

    public func item(from point: HexPoint) -> Element {

        let index = (abs(point.x) + point.y) % self.count

        return self[index]
    }
}
