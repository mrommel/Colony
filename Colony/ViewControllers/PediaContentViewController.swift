//
//  PediaContentViewController.swift
//  Colony
//
//  Created by Michael Rommel on 02.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import SpriteKit

class PediaContentViewController: UIViewController {
    
    var pediaContentScene: PediaContentScene?
    var viewModel: PediaContentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
        
        self.pediaContentScene = PediaContentScene(size: view.frame.size)
        self.pediaContentScene?.viewModel = PediaContentSceneViewModel(with: viewModel)
        self.pediaContentScene?.pediaContentDelegate = self
        self.pediaContentScene?.scaleMode = .resizeFill
        
        view.presentScene(self.pediaContentScene)
        view.ignoresSiblingOrder = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.pediaContentScene?.updateLayout()
    }
}

extension PediaContentViewController: PediaContentDelegate {
    
    func quitPediaContent() {
        self.navigationController?.popViewController(animated: true)
    }
}
