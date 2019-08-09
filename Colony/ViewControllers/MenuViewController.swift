//
//  MenuViewController.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import SpriteKit

class MenuViewController: UIViewController {
    
    var menuScene: MenuScene?
    
    // used for segue
    var currentLevelResource: URL? = nil
    var currentGame: Game? = nil
    var currentMap: HexagonTileMap? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
        
        self.menuScene = MenuScene(size: view.bounds.size)
        
        menuScene?.scaleMode = .resizeFill
        menuScene?.menuDelegate = self
        
        view.presentScene(self.menuScene)
        view.ignoresSiblingOrder = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.menuScene?.updateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoGame" {
            let gameViewController = segue.destination as? GameViewController
            
            if self.currentLevelResource != nil {
                gameViewController?.viewModel = GameViewModel(with: self.currentLevelResource)
            } else if self.currentGame != nil {
                gameViewController?.viewModel = GameViewModel(with: self.currentGame)
            } else if self.currentMap != nil {
                gameViewController?.viewModel = GameViewModel(with: self.currentMap)
            }
        }
        
        if segue.identifier == "gotoOptions" {
            // NOOP
        }
    }
}

extension MenuViewController: MenuDelegate {

    func start(level resource: URL?) {
        
        self.currentLevelResource = resource
        self.currentGame = nil
        self.currentMap = nil
        self.performSegue(withIdentifier: "gotoGame", sender: nil)
    }
    
    func startWith(map: HexagonTileMap?) {
        self.currentLevelResource = nil
        self.currentGame = nil
        self.currentMap = map
        self.performSegue(withIdentifier: "gotoGame", sender: nil)
    }
    
    func restart(game: Game?) {
        self.currentLevelResource = nil
        self.currentGame = game
        self.currentMap = nil
        self.performSegue(withIdentifier: "gotoGame", sender: nil)
    }
    
    func startOptions() {
        self.performSegue(withIdentifier: "gotoOptions", sender: nil)
    }
    
    func startStore() {
        self.performSegue(withIdentifier: "gotoStore", sender: nil)
    }
}
