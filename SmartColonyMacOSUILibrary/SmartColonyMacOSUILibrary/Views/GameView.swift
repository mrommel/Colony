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
            
            self.content
            
            VStack {
                Spacer()
            
                Text("offset: \(String(format: "%.1f", self.$viewModel.contentOffset.wrappedValue.x)), \(String(format: "%.1f", self.$viewModel.contentOffset.wrappedValue.y)), zoom: \(String(format: "%.2f", self.$viewModel.magnification.wrappedValue))")
                    .background(Color.black.opacity(0.5))
            }
            
            BottomLeftBarView()
            
            //BottomRightBarView()
        }
    }
    
    private var content: AnyView {
        
        switch self.viewModel.presentedView {
        
        case .loading:
            return AnyView(self.loadingView)
        case .ready:
            return AnyView(self.readyView)
        }
    }
}

extension GameView {
    
    private var loadingView: some View {
        
        Text("Loading")
            .onReceive(self.gameEnvironment.game) { game in
                
                if let game = game {
                    // update viewport size
                    self.contentSize = game.contentSize()
                    self.game = game
                    self.viewModel.presentedView = .ready
                }
            }
    }
    
    private var readyView: some View {
        
        //ScrollableView(scrollPosition: self.$viewModel.contentOffset/*,
        //                 magnification: self.$viewModel.magnification,
        //                 magnificationTarget: self.$viewModel.magnificationTarget*/) {
            
        MapView(game: self.$game,
                magnification: self.$viewModel.magnification,
                focus: self.$viewModel.focusPosition)
                //.frame(width: self.contentSize.width * 3.0, height: self.contentSize.height * 3.0, alignment: .topLeading)
            /*Color.clear
                .frame(width: self.contentSize.width * 3.0, height: self.contentSize.height * 3.0, alignment: .topLeading)*/
        //}
        //.background(Color.black.opacity(0.3))
    }
}
