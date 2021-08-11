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
            
                VStack(alignment: .center, spacing: 10) {
                    Button(action: {
                        print("tutorials")
                    }) {
                        Text("Tutorials")
                    }.buttonStyle(GameButtonStyle())
                    
                    Button("Resume Game") {
                        print("resume game")
                    }.buttonStyle(GameButtonStyle())
                    
                    Button("New Game") {
                        print("new game")
                        self.viewModel.startNewGame()
                    }
                    .buttonStyle(GameButtonStyle(state: .highlighted))
                    
                    Button("Load Game") {
                        print("load game")
                    }.buttonStyle(GameButtonStyle())
                    
                    Button("Options") {
                        print("options")
                    }.buttonStyle(GameButtonStyle())
                    
                    Button("Pedia") {
                        print("pedia")
                        self.viewModel.startPedia()
                    }.buttonStyle(GameButtonStyle())
                    
                    Button("Quit") {
                        self.viewModel.showingQuitConfirmationAlert = true
                    }
                    .buttonStyle(GameButtonStyle())
                    .padding(.top, 45)
                }
            }
            
            Spacer(minLength: 1)
            
        }.padding(.vertical, 25)
        
        .alert(isPresented: self.$viewModel.showingQuitConfirmationAlert) {
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
