//
//  GameButtonStyle.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAssets

public enum GameButtonState {

    case disabled
    case normal
    case highlighted

    case text
    case reply
}

public struct GameButtonStyle: ButtonStyle {

    let state: GameButtonState

    public init() {

        self.state = .normal
    }

    public init(state: GameButtonState = .normal) {

        self.state = state
    }

    private func backgroundImage(pressed: Bool) -> NSImage {

        switch self.state {

        case .disabled:
            return ImageCache.shared.image(for: "grid9-button-disabled")

        case .normal, .text, .reply:
            // return ImageCache.shared.image(for: pressed ? "grid9-button-active" : "grid9-button-clicked")
            return ImageCache.shared.image(for: "grid9-button-clicked")

        case .highlighted:
            // return ImageCache.shared.image(for: pressed ? "grid9-button-active" : "grid9-button-highlighted")
            return ImageCache.shared.image(for: "grid9-button-highlighted")
        }
    }

    func font() -> Font? {

        switch self.state {

        case .disabled:
            return .headline
        case .normal:
            return .headline
        case .highlighted:
            return .headline
        case .text:
            return .headline
        case .reply:
            return .system(size: 10)
        }
    }

    private func width() -> CGFloat? {

        switch self.state {

        case .disabled:
            return 200
        case .normal:
            return 200
        case .highlighted:
            return 200
        case .text:
            return 300
        case .reply:
            return 300
        }
    }

    private func height() -> CGFloat? {

        switch self.state {

        case .disabled:
            return 24
        case .normal:
            return 24
        case .highlighted:
            return 24
        case .text:
            return 60
        case .reply:
            return nil
        }
    }

    public func makeBody(configuration: Self.Configuration) -> some View {

        configuration.label
            .font(self.font())
            .frame(width: self.width(), height: self.height(), alignment: .center)
            .multilineTextAlignment(.center)
            .padding(10)
            .background(
                Image(nsImage: self.backgroundImage(pressed: configuration.isPressed))
                    .resizable(capInsets: EdgeInsets(all: 15))
            )
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .foregroundColor(.primary)
    }
}

#if DEBUG
struct GameButtonStyle_Previews: PreviewProvider {

    static var previews: some View {

        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        Button("Normal", action: { })
            .buttonStyle(GameButtonStyle())

        Button("Highlighted", action: { })
            .buttonStyle(GameButtonStyle(state: .highlighted))

        Button("Lorem ipsum dolor situ omne mundi habeamus", action: { })
            .buttonStyle(GameButtonStyle(state: .text))
    }
}
#endif
