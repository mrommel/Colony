//
//  MenuViewController.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import SpriteKit
import Rswift

class QuestsViewController: UIViewController {
    
    var questsScene: QuestsScene?
    
    // used for segue
    var currentLevelResource: URL? = nil
    var currentGame: Game? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
        
        self.questsScene = QuestsScene(size: view.bounds.size)
        
        self.questsScene?.scaleMode = .resizeFill
        self.questsScene?.questsDelegate = self
        
        view.presentScene(self.questsScene)
        view.ignoresSiblingOrder = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.questsScene?.updateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == R.segue.questsViewController.gotoGame.identifier {
            let gameViewController = segue.destination as? GameViewController
            
            if self.currentLevelResource != nil {
                gameViewController?.viewModel = GameViewModel(with: self.currentLevelResource)
            } else if self.currentGame != nil {
                gameViewController?.viewModel = GameViewModel(with: self.currentGame)
            }
        }
    }
}

extension QuestsViewController: QuestsDelegate {

    func start(level resource: URL?) {
        
        self.currentLevelResource = resource
        self.currentGame = nil
        self.performSegue(withIdentifier: R.segue.questsViewController.gotoGame.identifier, sender: nil)
    }
    
    func restart(game: Game?) {
        self.currentLevelResource = nil
        self.currentGame = game
        self.performSegue(withIdentifier: R.segue.questsViewController.gotoGame.identifier, sender: nil)
    }
    
    func quitQuests() {
        self.navigationController?.popViewController(animated: true)
    }
}
