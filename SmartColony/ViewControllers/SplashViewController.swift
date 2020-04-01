//
//  SplashViewController.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import UIKit
import Rswift

class SplashViewController: UIViewController {
    
    @IBOutlet var colonyTextImageView: UIImageView!
    @IBOutlet var glowImageView: UIImageView!
    
    var inUnitTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    override func viewDidLoad() {
        
        self.colonyTextImageView.isHidden = false
        self.glowImageView.isHidden = false
        
        if !self.inUnitTests {
            CoreDataManager.shared.setup(completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.performSegue(withIdentifier: R.segue.splashViewController.gotoMenu.identifier, sender: nil)
                }
            })
        }
    }
}
