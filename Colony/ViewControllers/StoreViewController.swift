//
//  StoreViewController.swift
//  Colony
//
//  Created by Michael Rommel on 30.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import SpriteKit

class StoreViewController: UIViewController {
    
    var storeScene: StoreScene?
    //var settingsUsecase: SettingsUsecase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
        
        let userUsecase = UserUsecase()
        guard let user = userUsecase.currentUser() else {
            fatalError("can't get current user")
        }
 
        self.storeScene = StoreScene(size: view.frame.size)
        self.storeScene?.viewModel = StoreSceneViewModel(boosterStock: user.boosterStock, coins: user.coins)
        self.storeScene?.storeDelegate = self
        self.storeScene?.scaleMode = .resizeFill
        
        view.presentScene(self.storeScene)
        view.ignoresSiblingOrder = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.storeScene?.updateLayout()
    }
}

extension StoreViewController: StoreDelegate {
    
    func quitStore() {
        
        self.navigationController?.popViewController(animated: true)
    }
}
