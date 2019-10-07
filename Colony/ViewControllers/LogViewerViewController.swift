//
//  LogViewerViewController.swift
//  Colony
//
//  Created by Michael Rommel on 30.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

class LogViewerViewModel {
    
    let logContent: String!
    
    init(logContent: String) {
        
        self.logContent = logContent
    }
}

class LogViewerViewController: UIViewController {
    
    @IBOutlet var logTextView: UITextView!
    
    var viewModel: LogViewerViewModel?
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "AI Log"
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        self.logTextView.text = viewModel.logContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
