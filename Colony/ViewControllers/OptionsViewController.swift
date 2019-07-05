//
//  OptionsViewController.swift
//  Colony
//
//  Created by Michael Rommel on 05.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import SpriteKit

class OptionsViewController: UIViewController {
    
    var optionsScene: OptionsScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else {
            fatalError("View not loaded")
        }
        
        /*guard let viewModel = self.viewModel else {
            fatalError("ViewModel not initilized")
        }*/
        
        self.optionsScene = OptionsScene(size: view.frame.size)
        self.optionsScene?.optionsDelegate = self
        self.optionsScene?.scaleMode = .resizeFill
        
        view.presentScene(self.optionsScene)
        view.ignoresSiblingOrder = true
    }
}

extension OptionsViewController: OptionsDelegate {
    
    func quitOptions() {
        self.navigationController?.popViewController(animated: true)
    }
}
