//
//  AppDelegate.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 21.03.21.
//

import Cocoa
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        //NSApplication.shared.mainMenu = AppMenu()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        
        return true
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        
        // todo check if we should really quit
        
        // If we got here, it is time to quit.
        return .terminateNow
    }
}
