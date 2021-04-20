//
//  SmartColonyMacOSApp.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 21.03.21.
//

import SwiftUI
import SmartMacOSUILibrary
import Combine
import SmartAILibrary

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
    
    func centerOnCursor() {
        self.viewModel.centerOnCursor()
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
            
            Button(action: {
                self.commandModel.centerOnCursor()
            }, label: {
                Image(systemName: "paperplane.circle.fill")
                Text("Center on cursor")
            })
            
            Divider()
            
            Button(action: {
                self.commandModel.zoomIn()
            }, label: {
                Image(systemName: "plus.magnifyingglass")
                Text("Zoom In")
            }).keyboardShortcut("+")
            
            Button(action: {
                self.commandModel.zoomOut()
            }, label: {
                Image(systemName: "minus.magnifyingglass")
                Text("Zoom Out")
            }).keyboardShortcut("-")
            
            Button(action: {
                self.commandModel.zoomReset()
            }, label: {
                Image(systemName: "1.magnifyingglass")
                Text("Zoom 1:1")
            }).keyboardShortcut("r")
            
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
        WindowGroup {
            MainView(viewModel: viewModel)
        }
        .commands {
            GameCommands(commandModel: commandModel)
        }
    }
}
