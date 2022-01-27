//
//  CheckboxCircleToggleStyle.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.04.21.
//

import SwiftUI

public struct CheckboxCircleToggleStyle: ToggleStyle {

    public init() {

    }

    public func makeBody(configuration: Configuration) -> some View {

        Button(
            action: {
                configuration.isOn.toggle()
            },
            label: {
                HStack(spacing: 10) {
                    Image(systemName: configuration.isOn ? "checkmark.circle" : "circle")
                        .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                        .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))

                    configuration.label
                }
            }
        )
            .buttonStyle(PlainButtonStyle())
    }
}
