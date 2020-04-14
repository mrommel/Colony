//
//  PediaViewController.swift
//  SmartColony
//
//  Created by Michael Rommel on 14.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
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
        self.pediaScene?.pediaDelegate = self
        self.pediaScene?.scaleMode = .resizeFill
        
        view.presentScene(self.pediaScene)
        view.ignoresSiblingOrder = false
    }
}

extension PediaViewController: PediaDelegate {
    
    func exit() {
        self.navigationController?.popViewController(animated: true)
    }
}
