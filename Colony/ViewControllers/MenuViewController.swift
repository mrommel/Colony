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
    var currentLevelName: String? = nil
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // add level here
        if segue.identifier == "gotoGame" {
            let gameViewController = segue.destination as? GameViewController
            
            if self.currentLevelName == nil {
                gameViewController?.viewModel = GameViewModel()
            } else {
                gameViewController?.viewModel = GameViewModel(with: self.currentLevelName)
            }
        }
    }
}

extension MenuViewController: MenuDelegate {

    func start(level levelName: String) {
        self.currentLevelName = levelName
        self.performSegue(withIdentifier: "gotoGame", sender: nil)
    }
    
    func startGeneration() {
        self.currentLevelName = nil
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
