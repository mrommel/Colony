//
//  GenerateGameView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 23.03.21.
//

import Foundation
import SwiftUI
import SmartAssets
import SmartMacOSUILibrary

struct GenerateGameView: View {
    
    @ObservedObject
    var viewModel: GenerateGameViewModel
    
    var body: some View {
        
        VStack {
            
            Text("SmartColony").font(.largeTitle)
            
            Divider()
            
            Text("Loading")
            ActivityIndicator(isAnimating: self.$viewModel.loading, style: .spinning)
        }
    }
}
