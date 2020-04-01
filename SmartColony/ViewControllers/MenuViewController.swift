//
//  MenuViewController.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import UIKit
import SmartAILibrary
import SpriteKit

class MenuViewController: UIViewController {
    
    var menuScene: MenuScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
        
        self.menuScene = MenuScene(size: view.frame.size)
        self.menuScene?.menuDelegate = self
        self.menuScene?.scaleMode = .resizeFill
        
        view.presentScene(self.menuScene)
        view.ignoresSiblingOrder = false
    }
}

extension MenuViewController: MenuDelegate {
    
    func startTutorials() {
        
    }
    
    func startQuests() {
        
    }
    
    func startWith(map: MapModel?) {
        
    }
    
    func startOptions() {
        
    }
    
    func startStore() {
        
    }
    
    func startPedia() {
        
    }
}
