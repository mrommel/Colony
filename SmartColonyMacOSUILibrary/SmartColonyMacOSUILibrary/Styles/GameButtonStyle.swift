//
//  GameButtonStyle.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI

public struct GameButtonStyle: ButtonStyle {
    
    public init() {
        
    }
    
    private func backgroundImage(pressed: Bool) -> NSImage {
        
        return ImageCache.shared.image(for: pressed ? "grid9-button-clicked" : "grid9-button-active")
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        
        configuration.label
            .font(.headline)
            .frame(width: 160, height: 24, alignment: .center)
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
        
        Button("Test", action: { })
            .buttonStyle(GameButtonStyle())
    }
}
#endif
