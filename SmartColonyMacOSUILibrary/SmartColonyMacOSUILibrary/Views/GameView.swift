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
            
            /*ScrollableView(scrollTo: self.$viewModel.scrollTarget,
                           clickOn: self.$viewModel.clickPosition,
                           magnification: self.$viewModel.scale) {
                
                MapView(viewModel: self.viewModel.mapViewModel)
            }
            .background(Color.black.opacity(0.5))*/
            
            ScrollableView(scrollTo: self.$viewModel.scrollTarget,
                           clickOn: self.$viewModel.clickPosition,
                           magnification: self.$viewModel.scale) {
                
                SKMapView(game: self.$game)
                    .onReceive(self.gameEnvironment.game) { game in
                        
                        if let game = game {
                            // update viewport size
                            self.contentSize = game.contentSize()
                            
                            print("received a new game: \(game.mapSize().name())")
                            print("set size: \(self.contentSize * 3.0)")
                            self.game = game
                        }
                    }
                    .frame(width: self.contentSize.width * 3.0, height: self.contentSize.height * 3.0, alignment: .topLeading)
                    .background(Color.red.opacity(0.5))
                
            }
            .background(Color.black.opacity(0.5))
            
            BottomLeftBarView(viewModel: self.viewModel.mapViewModel)
            
            BottomRightBarView(viewModel: self.viewModel.mapViewModel)
        }
    }
}
