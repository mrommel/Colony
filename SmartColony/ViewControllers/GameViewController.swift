//
//  GameViewController.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var gameScene: GameScene?
    
    override func viewDidLoad() {
        
        self.gameScene = GameScene()
    }
}
