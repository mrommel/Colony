//
//  GameScrollContentView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import Cocoa
import SwiftUI
import SmartAILibrary

// https://www.calincrist.com/blog/2020-04-12-how-to-get-notified-for-changes-in-swiftui/
public struct GameScrollContentView: NSViewRepresentable {

    @ObservedObject
    var viewModel: GameScrollContentViewModel

    typealias UIViewType = GameScrollView

    var scrollView: GameScrollView = GameScrollView(frame: .zero)
    var gameView: GameHostingView = GameHostingView(viewModel: GameViewModel())
    
    public init(viewModel: GameScrollContentViewModel) {
        
        self.viewModel = viewModel
    }

    public func makeNSView(context: Context) -> GameScrollView {
        
        self.scrollView.setAccessibilityEnabled(true)
        self.scrollView.hasVerticalScroller = true
        self.scrollView.hasHorizontalScroller = true
        
        self.scrollView.allowsMagnification = true
        self.scrollView.magnification = 0.5
        self.scrollView.minMagnification = 0.1
        self.scrollView.maxMagnification = 4
        
        /*self.gameView?.delegate = context.coordinator
         self.gameView?.setViewSize(self.viewModel.zoom)
         
         self.viewModel.didChange = { pt in
         self.gameView?.redrawTile(at: pt)
         }
         
         self.viewModel.shouldRedraw = {
         self.gameView?.redrawAll()
         }*/
        
        self.scrollView.documentView = self.gameView
        
        return scrollView
    }

    public func updateNSView(_ scrollView: GameScrollView, context: Context) {

        if let gameView = scrollView.documentView as? GameHostingView {

            gameView.rootView.assign(game: self.viewModel.game)
        }
    }

    public func makeCoordinator() -> GameScrollContentView.Coordinator {
        
        Coordinator(gameScrollContentView: self)
    }

    final public class Coordinator: NSObject, GameViewDelegate {
        
        var gameScrollContentView: GameScrollContentView?

        init(gameScrollContentView: GameScrollContentView?) {

            self.gameScrollContentView = gameScrollContentView
        }

        func moveBy(dx: CGFloat, dy: CGFloat) {

            self.gameScrollContentView?.scrollView.scrollBy(dx: dx, dy: dy)
        }

        func focus(on tile: Tile) {

            self.gameScrollContentView?.viewModel.setFocus(to: tile)
        }
        
        func draw(at point: HexPoint) {

            self.gameScrollContentView?.viewModel.draw(at: point)
        }
        
        func options() -> GameDisplayOptions? {
            
            return self.gameScrollContentView?.viewModel.options()
        }
    }
}
