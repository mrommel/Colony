//
//  SmartColonyMacOSApp.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 21.03.21.
//

import SwiftUI

@main
struct SmartColonyMacOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup<ContentView> {
            ContentView()
        }
    }
}
