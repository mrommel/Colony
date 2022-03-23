//
//  SegmentedProgressView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 22.03.22.
//

import SwiftUI

struct SegmentedProgressView: View {

    var value: Int
    var maximum: Int = 7
    
    var height: CGFloat = 10
    var spacing: CGFloat = 2
    var selectedColor: Color = .accentColor
    var unselectedColor: Color = Color.secondary.opacity(0.3)

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0 ..< maximum) { index in
                Rectangle()
                    .foregroundColor(index < self.value ? self.selectedColor : self.unselectedColor)
            }
        }
        .frame(maxHeight: height)
        .clipShape(Capsule())
    }
}
