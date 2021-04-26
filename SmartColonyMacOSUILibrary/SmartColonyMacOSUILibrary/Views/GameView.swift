//
//  GameView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.04.21.
//

import SwiftUI
import SmartAILibrary

public struct GameView: View {
    
    @ObservedObject
    private var viewModel: GameViewModel
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @State
    var game: GameModel?
    
    @State
    var contentSize: CGSize = CGSize(width: 100, height: 100)
    
    public init(viewModel: GameViewModel) {
        
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        ZStack {
            
            ScrollableView(scrollTo: self.$viewModel.scrollTarget,
                           magnification: self.$viewModel.scale) {
                
                MapView(game: self.$game, magnification: self.$viewModel.scale,
                        focus: self.$viewModel.focusPosition)
                    .onReceive(self.gameEnvironment.game) { game in
                        
                        if let game = game {
                            // update viewport size
                            self.contentSize = game.contentSize()
                            
                            print("received a new game: \(game.mapSize().name())")
                            //print("set size: \(self.contentSize * 3.0)")
                            self.game = game
                        }
                    }
                    .frame(width: self.contentSize.width * 3.0, height: self.contentSize.height * 3.0, alignment: .topLeading)
                
            }
            .background(Color.black.opacity(0.5))
            
            BottomLeftBarView()
            
            BottomRightBarView()
        }
    }
}
