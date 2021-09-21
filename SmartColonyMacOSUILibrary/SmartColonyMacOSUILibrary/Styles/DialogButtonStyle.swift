//
//  DialogButtonStyle.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.08.21.
//

import SwiftUI
import SmartAssets

public enum DialogButtonState {

    case normal
    case highlighted
}

public struct DialogButtonStyle: ButtonStyle {

    let state: DialogButtonState

    @Environment(\.isEnabled)
    private var isEnabled: Bool

    public init(state: DialogButtonState = .normal) {

        self.state = state
    }

    private func backgroundImage(pressed: Bool) -> NSImage {

        switch self.state {

        case .normal:
            return ImageCache.shared.image(for: "grid9-button-clicked")

        case .highlighted:
            return ImageCache.shared.image(for: "grid9-button-highlighted")

        }
    }

    public func makeBody(configuration: Self.Configuration) -> some View {

        configuration.label
            .font(.body)
            .frame(width: 84, height: 14, alignment: .center)
            .multilineTextAlignment(.center)
            .padding(6)
            .background(
                Image(nsImage: self.backgroundImage(pressed: configuration.isPressed))
                    .resizable(capInsets: EdgeInsets(all: 15))
                    .colorMultiply(self.isEnabled ? .white : .gray)
            )
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .foregroundColor(.primary)
    }
}

#if DEBUG
struct DialogButtonStyle_Previews: PreviewProvider {

    static var previews: some View {

        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        Button("Normal", action: { })
            .buttonStyle(DialogButtonStyle())

        Button("Highlighted", action: { })
            .buttonStyle(DialogButtonStyle(state: .highlighted))

        Button("Normal", action: { })
            .buttonStyle(DialogButtonStyle())
            .disabled(true)

        Button("Highlighted", action: { })
            .buttonStyle(DialogButtonStyle(state: .highlighted))
            .disabled(true)
    }
}
#endif
