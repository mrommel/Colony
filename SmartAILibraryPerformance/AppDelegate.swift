//
//  AppDelegate.swift
//  SmartAILibraryPerformance
//
//  Created by Michael Rommel on 23.08.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Cocoa

// @main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print("did finish launching")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        print("will terminate")
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

