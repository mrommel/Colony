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
    
    var scene: MenuScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
        
        self.scene = MenuScene(size: view.bounds.size)
        
        scene?.scaleMode = .resizeFill
        scene?.menuDelegate = self
        
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension MenuViewController: MenuDelegate {

    func startGame() {
        self.performSegue(withIdentifier: "gotoGame", sender: nil)
    }
    
    func startOptions() {
        
    }
    
    func startCredits() {
        
    }
}
