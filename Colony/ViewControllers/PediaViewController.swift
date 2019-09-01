//
//  PediaViewController.swift
//  Colony
//
//  Created by Michael Rommel on 01.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import SpriteKit

class PediaViewController: UIViewController {
    
    var pediaScene: PediaScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
    
        self.pediaScene = PediaScene(size: view.frame.size)
        //self.pediaScene?.viewModel = StoreSceneViewModel(boosterStock: user.boosterStock, coins: user.coins)
        self.pediaScene?.pediaDelegate = self
        self.pediaScene?.scaleMode = .resizeFill
        
        view.presentScene(self.pediaScene)
        view.ignoresSiblingOrder = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.pediaScene?.updateLayout()
    }
}

extension PediaViewController: PediaDelegate {
    
    func quitPedia() {
        self.navigationController?.popViewController(animated: true)
    }
}
