//
//  ViewExtension.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 11.01.22.
//

import SwiftUI

extension View {

    public func border<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S: ShapeStyle {

        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}
