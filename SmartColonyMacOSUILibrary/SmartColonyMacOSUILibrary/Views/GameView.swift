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
                //GeometryReader { proxy in
                    SKMapView(game: self.$game)
                        .onReceive(self.gameEnvironment.game) { game in
                            // update viewport size
                            self.contentSize = game?.contentSize() ?? CGSize(width: 100, height: 100)
                            
                            print("received a new game: \(game?.mapSize().name() ?? "abc")")
                            print("size: \(self.contentSize)")
                            self.game = game
                        }
                        
                //}
                .frame(width: self.contentSize.width * 3.0, height: self.contentSize.height * 3.0, alignment: .topLeading)
                
            }
            .background(Color.black.opacity(0.5))
            
            //Text("focus: \(self.viewModel.scrollTarget?.x ?? 0.0), \(self.viewModel.scrollTarget?.y ?? 0.0)")
            
            BottomLeftBarView(viewModel: self.viewModel.mapViewModel)
            
            BottomRightBarView(viewModel: self.viewModel.mapViewModel)
        }
    }
}
