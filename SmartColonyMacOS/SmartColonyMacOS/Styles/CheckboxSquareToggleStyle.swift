//
//  CheckboxSquareToggleStyle.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.04.21.
//

import SwiftUI

struct CheckboxSquareToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
