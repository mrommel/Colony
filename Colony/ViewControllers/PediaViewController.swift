//
//  PediaViewController.swift
//  Colony
//
//  Created by Michael Rommel on 01.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import SpriteKit
import Rswift

class PediaViewController: UIViewController {
    
    var pediaScene: PediaScene?
    
    // delegate content
    var currentTerrain: Terrain? = nil
    var currentFeature: Feature? = nil
    var currentUnitType: UnitType? = nil
    
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
        view.ignoresSiblingOrder = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.pediaScene?.updateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == R.segue.pediaViewController.showContent.identifier {
            let pediaContentViewController = segue.destination as? PediaContentViewController
            
            if let terrain = self.currentTerrain {
                pediaContentViewController?.viewModel = PediaContentViewModel(with: terrain)
            } else if let feature = self.currentFeature {
                pediaContentViewController?.viewModel = PediaContentViewModel(with: feature)
            } else if let unitType = self.currentUnitType {
                pediaContentViewController?.viewModel = PediaContentViewModel(with: unitType)
            }
        }
    }
}

extension PediaViewController: PediaDelegate {
    
    func quitPedia() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func show(terrain: Terrain) {
        
        self.currentTerrain = terrain
        self.currentFeature = nil
        self.currentUnitType = nil
        self.performSegue(withIdentifier: R.segue.pediaViewController.showContent.identifier, sender: nil)
    }
    
    func show(feature: Feature) {
        
        self.currentTerrain = nil
        self.currentFeature = feature
        self.currentUnitType = nil
        self.performSegue(withIdentifier: R.segue.pediaViewController.showContent.identifier, sender: nil)
    }
    
    func show(unitType: UnitType) {
        
        self.currentTerrain = nil
        self.currentFeature = nil
        self.currentUnitType = unitType
        self.performSegue(withIdentifier: R.segue.pediaViewController.showContent.identifier, sender: nil)
    }
}
