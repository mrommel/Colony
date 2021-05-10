//
// MenuView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import SwiftUI
import SmartMacOSUILibrary

struct MenuView: View {
    
    @ObservedObject
    var viewModel: MenuViewModel
    
    var body: some View {
        
        VStack {
            
            Spacer(minLength: 1)
            
            Text("SmartColony")
                .font(.largeTitle)
            
            Divider()
            
            GroupBox {
            
                Button(action: {
                    print("tutorials")
                }) {
                    Text("Tutorials")
                }.buttonStyle(MenuButtonStyle())
                
                Button("Resume Game") {
                    print("resume game")
                }.buttonStyle(MenuButtonStyle())
                
                Button("New Game") {
                    print("new game")
                    viewModel.startNewGame()
                }.buttonStyle(SelectedMenuButtonStyle())
                
                Button("Load Game") {
                    print("load game")
                }.buttonStyle(MenuButtonStyle())
                
                Button("Options") {
                    print("options")
                }.buttonStyle(MenuButtonStyle())
                
                Button("Pedia") {
                    print("pedia")
                }.buttonStyle(MenuButtonStyle())
                
                Button("Quit") {
                    viewModel.showingQuitConfirmationAlert = true
                }
                .buttonStyle(MenuButtonStyle())
                .padding(.top, 45)
            }
            
            Spacer(minLength: 1)
            
        }.padding(.vertical, 25)
        
        .alert(isPresented: $viewModel.showingQuitConfirmationAlert) {
            Alert(
                title: Text("Quit"),
                message: Text("Do you really want to quit?"),
                primaryButton: .destructive(Text("Quit")) {
                    NSApplication.shared.terminate(self)
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct MenuView_Previews: PreviewProvider {

    //static var gameViewModel: GameViewModel = GameViewModel(game: DemoGameModel())
    static var viewModel = MenuViewModel()
    
    static var previews: some View {
        
        MenuView(viewModel: viewModel)
    }
}
