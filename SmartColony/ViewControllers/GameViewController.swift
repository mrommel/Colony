//
//  GameViewController.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import UIKit
import SpriteKit
import SmartAILibrary

class GameViewController: UIViewController {
    
    // gesture recognizers
    var pinchGestureRecognizer: UIPinchGestureRecognizer?
    var longPressRecognizer: UILongPressGestureRecognizer?
    var doubleTapGestureRecognizer: UITapGestureRecognizer?
    
    // model
    var viewModel: GameViewModel? = nil
    
    // scenes
    var gameLoadingScene: GameLoadingScene?
    var gameScene: GameScene? = nil
    //var gameClosingScene: GameClosingScene?
    
    // The current zoom scale of the camera
    private var zoomScale: Double = Globals.Constants.initialScale
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewModel = self.viewModel else {
            fatalError("ViewModel not initilized")
        }
        
        
        
        self.start(game: self.viewModel?.game)
        
        /*switch viewModel.type {
        case .level:
            self.startGameWith(levelMeta: self.viewModel?.levelMeta)
        case .game:
            self.restart(game: self.viewModel?.game)
        case .map:
            self.startGameWith(map: self.viewModel?.map)
        }*/
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }

        self.gameScene = nil
        view.presentScene(nil)

        print("-- Game dismissed --")

        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.gameScene?.updateLayout()
    }
    
    func setupGestureRecognizer() {
           
        self.pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(GameViewController.updateScale(sender:)))
        self.view.addGestureRecognizer(self.pinchGestureRecognizer!)
       
        self.longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GameViewController.handleLongPress(sender:)))
        //self.view.addGestureRecognizer(self.longPressRecognizer!)
       
        self.doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleDoubleTap(sender:)))
        self.doubleTapGestureRecognizer?.numberOfTapsRequired = 2
        //self.view.addGestureRecognizer(self.doubleTapGestureRecognizer!)
    }

    @objc func updateScale(sender: UIPinchGestureRecognizer) {

        guard let scene = self.gameScene else { return }
        guard let recognizer = self.pinchGestureRecognizer else { return }

        if recognizer.state == .changed {

            zoomScale = zoomScale / Double(recognizer.scale)
            scene.zoom(to: zoomScale)
            recognizer.scale = 1
        }
    }
   
    @objc func handleLongPress(sender: UITapGestureRecognizer) {

        print("long press")
        /*let screenPoint = sender.location(in: self.view)
        let transformedPoint = self.gameScene?.cameraNode.convert(screenPoint, from: self.gameScene!.viewHex)
        let hex = HexMapDisplay.shared.toHexPoint(screen: transformedPoint!)
       
        print("long press at: \(hex)")*/
    }
   
    @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
       print("double tap")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController {
    
    func start(game: GameModel?) {
        
        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
    
        self.gameLoadingScene = GameLoadingScene(size: view.bounds.size)
        self.gameLoadingScene?.completion = {
            
            self.gameScene = GameScene(size: view.bounds.size)
            self.gameScene?.viewModel = GameSceneViewModel(with: game)
            self.gameScene?.scaleMode = .resizeFill
            self.gameScene?.gameDelegate = self
            game?.userInterface = self.gameScene
            
            view.presentScene(self.gameScene)
            view.ignoresSiblingOrder = false
        }
        
        view.presentScene(self.gameLoadingScene)
        view.ignoresSiblingOrder = false
        
        #if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        #endif

        self.setupGestureRecognizer()
    }
}

extension GameViewController: GameDelegate {
    
    func exit() {
        self.navigationController?.popViewController(animated: true)
    }
}
