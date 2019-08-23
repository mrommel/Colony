//
//  SplashViewController.swift
//  Colony
//
//  Created by Michael Rommel on 23.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet var colonyTextImageView: UIImageView!
    
    override func viewDidLoad() {
        
        self.colonyTextImageView.isHidden = false
        
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
            CoreDataManager.shared.setup(completion: {
                self.performSegue(withIdentifier: "gotoMenu", sender: nil)
            })
        }
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
        }*/
    }
}
