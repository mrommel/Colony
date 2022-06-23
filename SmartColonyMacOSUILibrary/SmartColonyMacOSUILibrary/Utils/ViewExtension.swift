//
//  ViewExtension.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 11.01.22.
//

import SwiftUI
import SmartAssets

extension View {

    public func border<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S: ShapeStyle {

        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}

struct DialogBackground: ViewModifier {

    func body(content: Content) -> some View {
        content
            .background(
                Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                    .resizable(capInsets: EdgeInsets(all: 45))
            )
    }
}

extension View {

    public func dialogBackground() -> some View {
        self.modifier(DialogBackground())
    }
}
