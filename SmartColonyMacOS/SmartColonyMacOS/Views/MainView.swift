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

class DemoGameModel: GameModel {
    
    init() {
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()
        
        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = DemoGameModel.mapFilled(with: .grass, sized: .small)
        mapModel.set(terrain: .plains, at: HexPoint(x: 1, y: 2))
        mapModel.set(hills: true, at: HexPoint(x: 1, y: 2))
        mapModel.set(resource: .wheat, at: HexPoint(x: 1, y: 2))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 2))
        mapModel.set(resource: .iron, at: HexPoint(x: 3, y: 2))
        
        super.init(victoryTypes: [.cultural], handicap: .chieftain, turnsElapsed: 0, players: [barbarianPlayer, aiPlayer, humanPlayer], on: mapModel)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    static func mapFilled(with terrain: TerrainType, sized size: MapSize) -> MapModel {

        let mapModel = MapModel(size: size)

        let mapSize = mapModel.size
        for x in 0..<mapSize.width() {

            for y in 0..<mapSize.height() {

                mapModel.set(terrain: terrain, at: HexPoint(x: x, y: y))
            }
        }

        return mapModel
    }
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
