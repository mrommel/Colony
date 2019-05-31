//
//  MenuViewController.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

struct MenuItem {
    let title: String
    let segue: String?
}

class MenuViewController: UITableViewController {
    
    let menuItems: [MenuItem] = [
        MenuItem(title: "Game", segue: "gotoGame"),
        MenuItem(title: "Options", segue: "gotoOptions")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Colony"
    }
}

// MARK: UITableViewDataSource

extension MenuViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
}

// MARK: UITableViewDelegate

extension MenuViewController {
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = "\(menuItem.title)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        
        if let segue = menuItem.segue {
            self.performSegue(withIdentifier: segue, sender: self)
        }
    }
}
