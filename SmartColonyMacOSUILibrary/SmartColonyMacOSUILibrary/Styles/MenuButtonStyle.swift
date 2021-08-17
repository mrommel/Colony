//
//  MenuButtonStyle.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.03.21.
//

import SwiftUI
import SmartAssets

public struct MenuButtonStyle: ButtonStyle {

    public init() {

    }

    public func makeBody(configuration: Self.Configuration) -> some View {

        configuration.label
            .frame(minWidth: 0, maxWidth: 200)
            .padding(10)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .shadow(color: .white, radius: configuration.isPressed ? 2: 5, x: configuration.isPressed ? -2: -5, y: configuration.isPressed ? -2: -5)
                        .shadow(color: .black, radius: configuration.isPressed ? 2: 5, x: configuration.isPressed ? 2: 5, y: configuration.isPressed ? 2: 5)
                        .blendMode(.overlay)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(Globals.Colors.buttonBackground))
                }
            )
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .foregroundColor(.primary)
            .padding(.horizontal, 20)
    }
}

public struct SelectedMenuButtonStyle: ButtonStyle {

    public init() {

    }

    public func makeBody(configuration: Self.Configuration) -> some View {

        configuration.label
            .frame(minWidth: 0, maxWidth: 200)
            .padding(10)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .shadow(color: .white, radius: configuration.isPressed ? 2: 5, x: configuration.isPressed ? -2: -5, y: configuration.isPressed ? -2: -5)
                        .shadow(color: .black, radius: configuration.isPressed ? 2: 5, x: configuration.isPressed ? 2: 5, y: configuration.isPressed ? 2: 5)
                        .blendMode(.overlay)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(Globals.Colors.buttonSelectedBackground))
                }
            )
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .foregroundColor(.primary)
            .padding(.horizontal, 20)
    }
}
