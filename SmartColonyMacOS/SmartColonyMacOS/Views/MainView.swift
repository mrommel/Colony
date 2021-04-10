//
//  MainView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 21.03.21.
//

import SwiftUI
import SmartMacOSUILibrary
import SmartAILibrary

struct MainView: View {
    
    @ObservedObject
    var viewModel: MainViewModel
    
    @State
    var cursor: CGPoint = .zero
    
    @State
    var scale: CGFloat = 1.0
    
    @State
    var contentOffset: CGPoint = .zero
    
    var body: some View {
        ZStack {
            Image("background_macos")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity, alignment: .topLeading)

            VStack {
                
                if self.viewModel.presentedView == .menu {
                    MenuView(viewModel: self.viewModel.menuViewModel)
                }
                
                if self.viewModel.presentedView == .newGameMenu {
                    CreateGameMenuView(viewModel: self.viewModel.createGameMenuViewModel)
                }
                
                if self.viewModel.presentedView == .loadingGame {
                    GenerateGameView(viewModel: self.viewModel.generateGameViewModel)
                }
                
                if self.viewModel.presentedView == .game {
                    
                    ZStack {
                        TrackableScrollView(
                            axes: [.horizontal, .vertical],
                            showsIndicators: true,
                            cursor: self.$cursor,
                            scale: self.$scale,
                            contentOffset: self.$contentOffset) {
                            
                            GameView(viewModel: self.viewModel.gameViewModel)
                        }
                        .background(Color.black.opacity(0.5))
                        
                        BottomLeftBarView(viewModel: self.viewModel.gameViewModel)
                        
                        BottomRightBarView(viewModel: self.viewModel.gameViewModel)
                    }
                }
            }
            .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity, alignment: .topLeading)
            .padding(.all, 1)
            
            /*Text("\(cursorFormatter.transform(screenPoint: self.cursor, contentSize: self.viewModel.gameViewModel.size, shift: self.viewModel.gameViewModel.shift).x)")
                .background(Color.black.opacity(0.5))*/
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        /*.toolbar {
            Button(action: self.viewModel.doTurn) {
                Label("Turn", systemImage: "arrow.right.circle.fill")
            }
        }*/
    }
    
    var cursorFormatter: CursorTransformator = {
        let formatter = CursorTransformator()
        return formatter
    }()
}

struct MainView_Previews: PreviewProvider {

    static var gameViewModel: GameViewModel = GameViewModel(game: DemoGameModel())
    static var viewModel = MainViewModel(
        presentedView: .game,
        gameViewModel: gameViewModel)
    
    static var previews: some View {
        
        MainView(viewModel: viewModel)
    }
}
