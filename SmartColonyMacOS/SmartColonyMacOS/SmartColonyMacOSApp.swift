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
    
    @ObservedObject
    var viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup<MainView> {
            MainView(viewModel: viewModel)
        }
    }
}
