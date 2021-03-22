//
//  AppDelegate.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 21.03.21.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
