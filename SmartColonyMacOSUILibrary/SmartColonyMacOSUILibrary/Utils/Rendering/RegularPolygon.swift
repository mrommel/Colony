//
//  RegularPolygon.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.05.21.
//

import SwiftUI
import SmartAILibrary

public struct RegularPolygon: Shape {

    let sides: UInt
    private let inset: CGFloat

    public init(sides: UInt) {

        self.init(sides: sides, inset: 0)
    }

    init(sides: UInt, inset: CGFloat) {

        self.sides = sides
        self.inset = inset
    }

    public func path(in rect: CGRect) -> Path {

        let path = Path.regularPolygon(sides: self.sides, in: rect, inset: inset)
        let rotatedPath = path.rotation(Angle.degrees(90), anchor: .center).path(in: rect)

        return rotatedPath
    }
}

extension RegularPolygon: InsettableShape {

    public func inset(by amount: CGFloat) -> RegularPolygon {

        return RegularPolygon(sides: self.sides, inset: self.inset + amount)
    }
}
