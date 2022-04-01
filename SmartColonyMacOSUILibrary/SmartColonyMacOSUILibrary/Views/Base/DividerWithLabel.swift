//
//  DividerWithLabel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 22.03.22.
//

import SwiftUI

struct DividerWithLabel: View {

    let labelText: String
    let horizontalPadding: CGFloat
    let color: Color

    init(_ labelText: String, horizontalPadding: CGFloat = 10, color: Color = .gray) {

        self.labelText = labelText
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {

        HStack {
            self.line

            Label(self.labelText)
                .foregroundColor(self.color)

            self.line
        }
    }

    var line: some View {

        VStack {
            Divider()
                .background(self.color)
        }
        .frame(minWidth: 10)
        .padding(self.horizontalPadding)
    }
}
