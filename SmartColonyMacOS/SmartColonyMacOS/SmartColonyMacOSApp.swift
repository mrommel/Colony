//
//  SmartColonyMacOSApp.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 21.03.21.
//

import SwiftUI

@main
struct SmartColonyMacOSApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup<GameView> {
            GameView()
        }
    }
}
