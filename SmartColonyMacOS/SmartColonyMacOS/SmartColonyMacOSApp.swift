//
//  SmartColonyMacOSApp.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 21.03.21.
//

import SwiftUI

// https://troz.net/post/2021/swiftui_mac_menus/
class GameCommandsModel: ObservableObject {
    
    @ObservedObject
    var viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    func centerCapital() {
        self.viewModel.centerCapital()
    }
    
    func zoomIn() {
        self.viewModel.zoomIn()
    }
    
    func zoomOut() {
        self.viewModel.zoomOut()
    }
    
    func zoomReset() {
        self.viewModel.zoomReset()
    }
}

struct GameCommands: Commands {
    //@Binding var sorting: Int
    
    @ObservedObject
    var commandModel: GameCommandsModel
    
    var body: some Commands {
        CommandMenu("Game") {

            Button(action: {
                self.commandModel.centerCapital()
            }, label: {
                Image(systemName: "star.circle")
                Text("Center to capital")
            })
            
            Divider()
            
            Button("Zoom In") {
                self.commandModel.zoomIn()
            }.keyboardShortcut("+")
            
            Button("Zoom Out") {
                self.commandModel.zoomOut()
            }.keyboardShortcut("-")
    
            Button("Zoom 1:1") {
                self.commandModel.zoomReset()
            }.keyboardShortcut("r")
            
            Divider()
        }
    }
}

@main
struct SmartColonyMacOSApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @ObservedObject
    var viewModel: MainViewModel
    
    @ObservedObject
    var commandModel: GameCommandsModel
    
    init() {
        
        let mainViewModel = MainViewModel()
        
        self.viewModel = mainViewModel
        self.commandModel = GameCommandsModel(viewModel: mainViewModel)
    }

    var body: some Scene {
        WindowGroup<MainView> {
            MainView(viewModel: viewModel)
        }
        .commands {
            GameCommands(commandModel: commandModel)
        }
    }
}
