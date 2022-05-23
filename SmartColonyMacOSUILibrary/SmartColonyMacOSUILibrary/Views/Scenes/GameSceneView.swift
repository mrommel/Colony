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

protocol MouseAwareDelegate: AnyObject {

    func customMouseMoved(with event: NSEvent)
    func customMouseDragged(with event: NSEvent)

    func customRightMouseDown(with event: NSEvent)
    func customMouseDown(with event: NSEvent)
    func customMouseUp(with event: NSEvent)
}

class MouseAwareSKView: SKView {

    weak var mouseAwareDelegate: MouseAwareDelegate?

    public override init(frame frameRect: NSRect) {

        super.init(frame: frameRect)

        self.preferredFramesPerSecond = 30
        self.allowsTransparency = true

        #if DEBUG
        self.showsFPS = true
        self.showsNodeCount = true
        #endif
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateTrackingAreas() {

        self.addTrackingArea(
            NSTrackingArea(
                rect: self.bounds,
                options: [.activeInActiveApp, .mouseMoved, .mouseEnteredAndExited],
                owner: self,
                userInfo: nil
            )
        )
    }

    override func mouseMoved(with event: NSEvent) {

        self.mouseAwareDelegate?.customMouseMoved(with: event)
    }

    override func rightMouseDown(with event: NSEvent) {

        self.mouseAwareDelegate?.customRightMouseDown(with: event)
    }

    override func mouseDown(with event: NSEvent) {

        self.mouseAwareDelegate?.customMouseDown(with: event)
    }

    override func mouseDragged(with event: NSEvent) {

        self.mouseAwareDelegate?.customMouseDragged(with: event)
    }

    override func mouseUp(with event: NSEvent) {

        self.mouseAwareDelegate?.customMouseUp(with: event)
    }
}

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

    func makeNSView(context: Context) -> MouseAwareSKView {

        let view = MouseAwareSKView(frame: .zero)

        // init SpriteKit Scene
        let gameScene = GameScene(size: .zero)
        gameScene.scaleMode = .resizeFill
        gameScene.backgroundColor = NSColor.clear

        context.coordinator.gameScene = gameScene

        view.presentScene(context.coordinator.gameScene)
        view.ignoresSiblingOrder = false

        view.mouseAwareDelegate = gameScene

        return view
    }

    func updateNSView(_ view: MouseAwareSKView, context: Context) {

        if self.viewModel?.gameModel == nil {

            print("++ updateNSView: viewmodel game is nil - mitigate")
            self.viewModel?.gameModel = self.gameEnvironment.game.value
        }

        if context.coordinator.gameScene?.viewModel == nil {
            context.coordinator.gameScene?.viewModel = self.viewModel
            context.coordinator.gameScene?.setupMap()
        }

        // print("## current: \(context.coordinator.gameScene?.currentZoom) => \(self.magnification)")
        if context.coordinator.gameScene?.currentZoom != self.magnification {
            context.coordinator.gameScene?.zoom(to: self.magnification)
        }

        context.coordinator.gameScene?.updateLayout()
    }
}
