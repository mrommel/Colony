//
//  ProgressBar.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SwiftUI

public struct ProgressBar: View {
    
    @Binding
    private var value: CGFloat
    private let maxValue: CGFloat
    private let backgroundEnabled: Bool
    private let backgroundColor: Color
    private let foregroundColor: Color
    
    public init(value: Binding<CGFloat>,
         maxValue: CGFloat,
         backgroundEnabled: Bool = true,
         backgroundColor: Color = Color(NSColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)),
         foregroundColor: Color = Color.black) {
        
        self._value = value
        self.maxValue = maxValue
        self.backgroundEnabled = backgroundEnabled
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    public var body: some View {
        // 1
        ZStack {
            // 2
            GeometryReader { geometryReader in
                // 3
                if self.backgroundEnabled {
                    Capsule()
                        .foregroundColor(self.backgroundColor) // 4
                }
                
                Capsule()
                    .frame(width: self.progress(value: self.value,
                                                maxValue: self.maxValue,
                                                width: geometryReader.size.width)) // 5
                    .foregroundColor(self.foregroundColor) // 6
                    .animation(.easeIn) // 7
            }
        }
    }
    
    private func progress(value: CGFloat, maxValue: CGFloat, width: CGFloat) -> CGFloat {
        
        let percentage = value / maxValue
        return width *  CGFloat(percentage)
    }
}
