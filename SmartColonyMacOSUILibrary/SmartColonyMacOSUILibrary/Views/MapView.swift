//
//  SKMapView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SwiftUI
import SpriteKit
import SmartAILibrary
import SmartAssets

// resize https://www.hackingwithswift.com/forums/swiftui/swiftui-spritekit-macos-catalina-10-15/2662
struct MapView : NSViewRepresentable {
    
    @Binding
    var game: GameModel?
    
    //@Binding
    //var magnification: CGFloat
    
    @Binding
    var focus: HexPoint?
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    class Coordinator: NSObject {
        var gameScene: GameScene?
        
        func resizeScene(to size: CGSize) {
            self.gameScene?.size = size
        }
    }
    
    func makeCoordinator() -> Coordinator {
        // add bindings here
        return Coordinator()
    }
    
    func makeNSView(context: Context) -> SKView {
        
        let view = SKView(frame: .zero)
        view.preferredFramesPerSecond = 60
        
        #if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        #endif
        
        // init SpriteKit Scene
        let gameScene = GameScene(size: .zero)
        gameScene.scaleMode = .resizeFill
        gameScene.backgroundColor = NSColor.clear
        
        context.coordinator.gameScene = gameScene
        
        return view
    }
 
    func updateNSView(_ view: SKView, context: Context) {

        //print("updated new game: \(self.game)")
        if self.game != nil {
            
            let contentSize = self.game?.contentSize() ?? CGSize(width: 100, height: 100)
            if context.coordinator.gameScene?.size != contentSize {
                context.coordinator.resizeScene(to: contentSize)
            }
            
            if context.coordinator.gameScene?.viewModel == nil {
                context.coordinator.gameScene?.viewModel = GameSceneViewModel(with: game)
            }
 
            if self.gameEnvironment.displayOptions.value.showHexCoordinates {
                context.coordinator.gameScene?.showHexCoords()
            } else {
                context.coordinator.gameScene?.hideHexCoords()
            }
            
            if self.gameEnvironment.displayOptions.value.showCompleteMap {
                context.coordinator.gameScene?.showCompleteMap()
            } else {
                context.coordinator.gameScene?.showVisibleMap()
            }
            
            if self.gameEnvironment.displayOptions.value.showYields {
                context.coordinator.gameScene?.showYields()
            } else {
                context.coordinator.gameScene?.hideYields()
            }
            
            if self.gameEnvironment.displayOptions.value.showResourceMarkers {
                context.coordinator.gameScene?.showResourceMarkers()
            } else {
                context.coordinator.gameScene?.hideResourceMarkers()
            }
            
            if self.gameEnvironment.displayOptions.value.showWater {
                context.coordinator.gameScene?.showWater()
            } else {
                context.coordinator.gameScene?.hideWater()
            }
        
            view.presentScene(context.coordinator.gameScene)
            view.ignoresSiblingOrder = false
            
            context.coordinator.gameScene?.updateLayout()
        }
    }
}
