//
//  GameButtonStyle.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI

public enum GameButtonState {
    
    case normal
    case highlighted
    
    case text
}

public struct GameButtonStyle: ButtonStyle {
    
    let state: GameButtonState
    
    public init(state: GameButtonState = .normal) {
        
        self.state = state
    }
    
    private func backgroundImage(pressed: Bool) -> NSImage {
        
        switch self.state {
        
        case .normal, .text:
            //return ImageCache.shared.image(for: pressed ? "grid9-button-active" : "grid9-button-clicked")
            return ImageCache.shared.image(for: "grid9-button-clicked")
            
        case .highlighted:
            //return ImageCache.shared.image(for: pressed ? "grid9-button-active" : "grid9-button-highlighted")
            return ImageCache.shared.image(for: "grid9-button-highlighted")
            
        }
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        
        configuration.label
            .font(.headline)
            .frame(width: self.state == .text ? 300 : 200, height: self.state == .text ? 60 : 24, alignment: .center)
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
