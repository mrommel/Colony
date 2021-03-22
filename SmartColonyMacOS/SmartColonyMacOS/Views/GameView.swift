//
//  ContentView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 21.03.21.
//

import SwiftUI
import SmartMacOSUILibrary

struct GameView: View {
    
    @ObservedObject
    var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            Image("background_macos")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if self.viewModel.showMenu == true {
                    MenuView(viewModel: self.viewModel.menuViewModel)
                }
                
                if self.viewModel.showNewGameMenu == true {
                    CreateGameMenuView(viewModel: self.viewModel.createGameMenuViewModel)
                }

                if self.viewModel.showMap == true {
                    MapScrollContentView(viewModel: self.viewModel.mapViewModel)
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    //.frame(width: 1000, height: 500, alignment: .center)
                }
            }.padding(.vertical, 25)
        }
        .toolbar {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }
    
    init() {
        
        self.viewModel = GameViewModel()
    }
    
    private func addItem() {
        
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView()
    }
}
