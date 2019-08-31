//
//  MenuViewController.swift
//  Colony
//
//  Created by Michael Rommel on 30.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
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
        view.ignoresSiblingOrder = true
    }
}

extension MenuViewController: MenuDelegate {
    
    func startTutorials() {
        //self.performSegue(withIdentifier: "gotoTutorials", sender: nil)
        self.menuScene?.show(message: "not implemented")
    }
    
    func startQuests() {
        self.performSegue(withIdentifier: "gotoQuests", sender: nil)
    }
    
    func startOptions() {
        self.performSegue(withIdentifier: "gotoOptions", sender: nil)
    }
    
    func startStore() {
        self.performSegue(withIdentifier: "gotoStore", sender: nil)
    }
}
