//
//  MenuViewController.swift
//  Colony
//
//  Created by Michael Rommel on 30.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import SpriteKit
import Rswift

class MenuViewController: UIViewController {
    
    var menuScene: MenuScene?
    
    var currentMap: HexagonTileMap? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
        
        self.menuScene = MenuScene(size: view.frame.size)
        self.menuScene?.menuDelegate = self
        self.menuScene?.scaleMode = .resizeFill
        
        view.presentScene(self.menuScene)
        view.ignoresSiblingOrder = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == R.segue.menuViewController.gotoGame.identifier {
            let gameViewController = segue.destination as? GameViewController
            
            if self.currentMap != nil {
                gameViewController?.viewModel = GameViewModel(with: self.currentMap)
            }
        }
            
        if segue.identifier == R.segue.menuViewController.gotoOptions.identifier {
            // NOOP
        }
        
        if segue.identifier == R.segue.menuViewController.gotoQuests.identifier {
            // NOOP
        }
        
        if segue.identifier == R.segue.menuViewController.gotoStore.identifier {
            // NOOP
        }
        
        if segue.identifier == R.segue.menuViewController.gotoPedia.identifier {
            // NOOP
        }
    }
}

extension MenuViewController: MenuDelegate {
    
    func startWith(map: HexagonTileMap?) {
        self.currentMap = map
        self.performSegue(withIdentifier: R.segue.menuViewController.gotoGame.identifier, sender: nil)
    }
    
    func startTutorials() {
        //self.performSegue(withIdentifier: "gotoTutorials", sender: nil)
        self.menuScene?.show(message: "not implemented")
    }
    
    func startQuests() {
        self.performSegue(withIdentifier: R.segue.menuViewController.gotoQuests.identifier, sender: nil)
    }
    
    func startOptions() {
        self.performSegue(withIdentifier: R.segue.menuViewController.gotoOptions.identifier, sender: nil)
    }
    
    func startStore() {
        self.performSegue(withIdentifier: R.segue.menuViewController.gotoStore.identifier, sender: nil)
    }
    
    func startPedia() {
        self.performSegue(withIdentifier: R.segue.menuViewController.gotoPedia.identifier, sender: nil)
    }
}
