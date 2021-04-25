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
    
    //let proxy: GeometryProxy
    
    class Coordinator: NSObject {
        var gameScene: GameScene?
        
        func resizeScene(to size: CGSize) {
            gameScene?.size = size
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
            //print("update scene size: \(contentSize * CGFloat(3.0))")
            context.coordinator.resizeScene(to: contentSize)
            
            context.coordinator.gameScene?.viewModel = GameSceneViewModel(with: game)
        
            view.presentScene(context.coordinator.gameScene)
            view.ignoresSiblingOrder = false
            
            context.coordinator.gameScene?.updateLayout()
        }
    }
}
