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
            
            Spacer(minLength: 1)
            
            Text("SmartColony").font(.largeTitle)
            
            Divider()
            
            Text("Loading")
            ActivityIndicator(isAnimating: self.$viewModel.loading, style: .spinning)
            
            Spacer(minLength: 1)
        }
    }
}

struct GenerateGameView_Previews: PreviewProvider {

    //static var gameViewModel: GameViewModel = GameViewModel(game: DemoGameModel())
    static var viewModel = GenerateGameViewModel()
    
    static var previews: some View {
        
        GenerateGameView(viewModel: viewModel)
    }
}
