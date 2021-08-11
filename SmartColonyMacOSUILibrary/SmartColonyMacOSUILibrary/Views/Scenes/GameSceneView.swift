//
//  GameSceneView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SwiftUI
import SpriteKit
import SmartAILibrary
import SmartAssets

// resize https://www.hackingwithswift.com/forums/swiftui/swiftui-spritekit-macos-catalina-10-15/2662
struct GameSceneView: NSViewRepresentable {
    
    let viewModel: GameSceneViewModel?
    
    @Binding
    var magnification: CGFloat
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    class Coordinator: NSObject {
        var gameScene: GameScene?
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeNSView(context: Context) -> SKView {
        
        print("makeNSView")
        
        let view = SKView(frame: .zero)
        view.preferredFramesPerSecond = 60
        view.allowsTransparency = true
        
        #if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        #endif
        
        // init SpriteKit Scene
        let gameScene = GameScene(size: .zero)
        gameScene.scaleMode = .resizeFill
        gameScene.backgroundColor = NSColor.clear
        
        context.coordinator.gameScene = gameScene
        
        view.presentScene(context.coordinator.gameScene)
        view.ignoresSiblingOrder = false
        
        return view
    }
 
    func updateNSView(_ view: SKView, context: Context) {
        
        if self.viewModel?.game == nil {
            
            print("++ updateNSView: viewmodel game is nil - mitigate")
            self.viewModel?.game = self.gameEnvironment.game.value
        }
        
        if context.coordinator.gameScene?.viewModel == nil {
            context.coordinator.gameScene?.viewModel = self.viewModel
            context.coordinator.gameScene?.setupMap()
        }
        
        //print("## current: \(context.coordinator.gameScene?.currentZoom) => \(self.magnification)")
        if context.coordinator.gameScene?.currentZoom != self.magnification {
            context.coordinator.gameScene?.zoom(to: self.magnification)
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
        
        context.coordinator.gameScene?.updateLayout()
    }
}
