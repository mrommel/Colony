//
//  GameViewController.swift
//  Colony
//
//  Created by Michael Rommel on 26.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var pinchGestureRecognizer: UIPinchGestureRecognizer?
    var longPressRecognizer: UILongPressGestureRecognizer?
    var doubleTapGestureRecognizer: UITapGestureRecognizer?

    var viewModel: GameViewModel?

    // scenes
    var gameLoadingScene: GameLoadingScene?
    var gameScene: GameScene?

    // The current zoom scale of the camera
    private var zoomScale: CGFloat = GameScene.Constants.initialScale

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewModel = self.viewModel else {
            fatalError("ViewModel not initilized")
        }
        
        switch viewModel.type {
        case .level:
            self.startGameWith(levelMeta: self.viewModel?.levelMeta)
        case .game:
            self.restart(game: self.viewModel?.game)
        case .map:
            self.startGameWith(map: self.viewModel?.map)
        }
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

    func startGameWith(levelMeta: LevelMeta?) {

        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
        
        self.gameLoadingScene = GameLoadingScene(size: view.bounds.size)
        self.gameLoadingScene?.completion = {
            
            self.gameScene = GameScene(size: view.bounds.size)
            self.gameScene?.viewModel = GameSceneViewModel(with: levelMeta)
            self.gameScene?.scaleMode = .resizeFill
            self.gameScene?.gameDelegate = self
            
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
    
    func restart(game: Game?) {
        
        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
        
        self.gameLoadingScene = GameLoadingScene(size: view.bounds.size)
        self.gameLoadingScene?.completion = {
        
            self.gameScene = GameScene(size: view.bounds.size)
            self.gameScene?.viewModel = GameSceneViewModel(with: game)
            self.gameScene?.scaleMode = .resizeFill
            self.gameScene?.gameDelegate = self
            
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

    func startGameWith(map: HexagonTileMap?) {

        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
        
        self.gameLoadingScene = GameLoadingScene(size: view.bounds.size, layerOrdering: .nodeLayerOnTop)
        self.gameLoadingScene?.completion = {

            self.gameScene = GameScene(size: view.bounds.size)
            self.gameScene?.viewModel = GameSceneViewModel(with: map)
            self.gameScene?.scaleMode = .resizeFill
            self.gameScene?.gameDelegate = self
            
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

            zoomScale = zoomScale / recognizer.scale
            scene.zoom(to: zoomScale)
            recognizer.scale = 1
        }
    }
    
    @objc func handleLongPress(sender: UITapGestureRecognizer) {
 
        let screenPoint = sender.location(in: self.view)
        let transformedPoint = self.gameScene?.cameraNode.convert(screenPoint, from: self.gameScene!.viewHex)
        let hex = HexMapDisplay.shared.toHexPoint(screen: transformedPoint!)
        
        print("long press at: \(hex)")
    }
    
    @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
        print("double tap")
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: GameDelegate {

    func quitGame() {
        
        // delete current game from database
        let gameUseCase = GameUsecase()
        gameUseCase.deleteBackup()
        
        self.navigationController?.popViewController(animated: true)
    }

    func select(object: GameObject?) {

        print("select")
        /*let alert = UIAlertController(title: "Ship", message: "Please Select an Option", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Settle?", style: .default, handler: { (UIAlertAction)in
            print("User click Settle button => show buttons")
            //self.scene.show
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction)in
            print("User click Cancel button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })*/
    }
}
