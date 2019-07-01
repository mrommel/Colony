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
    var currentLevelResource: URL? = nil
    
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
        // add level here
        if segue.identifier == "gotoGame" {
            let gameViewController = segue.destination as? GameViewController
            
            if self.currentLevelResource == nil {
                gameViewController?.viewModel = GameViewModel()
            } else {
                gameViewController?.viewModel = GameViewModel(with: self.currentLevelResource)
            }
        }
    }
}

extension MenuViewController: MenuDelegate {

    func start(level resource: URL?) {
        self.currentLevelResource = resource
        self.performSegue(withIdentifier: "gotoGame", sender: nil)
    }
    
    func startGeneration() {
        self.currentLevelResource = nil
        self.performSegue(withIdentifier: "gotoGame", sender: nil)
    }
    
    /*func startOptions() {
        
        if let defeatDialog = UI.defeatDialog() {
            
            defeatDialog.addOkayAction(handler: {
                print("okay")
                defeatDialog.close()
            })
            
            scene?.addChild(defeatDialog)
        }
    }*/
}
