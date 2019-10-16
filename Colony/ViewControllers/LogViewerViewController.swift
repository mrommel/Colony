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
    
    func doReset() {
        
        Log.ai.reset()
    }
}

class LogViewerViewController: UIViewController {
    
    @IBOutlet var logTextView: UITextView!
    
    var viewModel: LogViewerViewModel?
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "AI Log"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTapped))
        
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
    
    @objc func resetTapped(sender: UIBarButtonItem) {

        self.viewModel?.doReset()
        self.viewModel = LogViewerViewModel(logContent: "")
    }
}
