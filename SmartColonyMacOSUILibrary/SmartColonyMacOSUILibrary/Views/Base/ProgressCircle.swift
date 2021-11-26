//
//  ProgressCircle.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SwiftUI

public struct ProgressCircle: View {

    public enum Stroke {
        case line
        case dotted

        func strokeStyle(lineWidth: CGFloat) -> StrokeStyle {
            switch self {
            case .line:
                return StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            case .dotted:
                return StrokeStyle(lineWidth: lineWidth, lineCap: .round, dash: [12])
            }
        }
    }

    @Binding
    private var value: CGFloat

    private let maxValue: CGFloat
    private let style: Stroke
    private let backgroundEnabled: Bool
    private let backgroundColor: Color
    private let foregroundColor: Color
    private let lineWidth: CGFloat

    public init(
        value: Binding<CGFloat>,
        maxValue: CGFloat,
        style: Stroke = .line,
        backgroundEnabled: Bool = true,
        backgroundColor: Color = Color(NSColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)),
        foregroundColor: Color = Color.black,
        lineWidth: CGFloat = 10) {

            self._value = value
            self.maxValue = maxValue
            self.style = style
            self.backgroundEnabled = backgroundEnabled
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.lineWidth = lineWidth
        }

    public var body: some View {
        ZStack {
            if self.backgroundEnabled {
                Circle()
                    .stroke(lineWidth: self.lineWidth)
                    .foregroundColor(self.backgroundColor)
            }

            Circle()
                .trim(from: 0, to: self.value / self.maxValue)
                .stroke(style: self.style.strokeStyle(lineWidth: self.lineWidth))
                .foregroundColor(self.foregroundColor)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeIn)
        }
    }
}
