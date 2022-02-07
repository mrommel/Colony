//
//  SmartColonyMacOSApp.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 21.03.21.
//

import SwiftUI
import SmartMacOSUILibrary
import Combine
import SmartAILibrary

@main
struct SmartColonyMacOSApp: App {

    // swiftlint:disable weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    @ObservedObject
    var viewModel: MainViewModel

    @ObservedObject
    var commandModel: GameCommandsModel

    init() {

        let mainViewModel = MainViewModel()
        self.viewModel = mainViewModel

        self.commandModel = GameCommandsModel()
        self.commandModel.viewModel = mainViewModel // = GameCommandsModel(viewModel: mainViewModel)
    }

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: self.viewModel)
        }
        .commands {
            GameCommands(
                commandModel: self.commandModel,
                mapMenuDisabled: self.$viewModel.mapMenuDisabled,
                toggleDisplayResourceMarkers: self.$commandModel.showDisplayResourceMarkers,
                toggleDisplayYields: self.$commandModel.showDisplayYields,
                toggleDisplayWater: self.$commandModel.showDisplayWater,
                toggleDisplayHexCoordinates: self.$commandModel.showDisplayHexCoordinates,
                toggleDisplayCompleteMap: self.$commandModel.showDisplayCompleteMap
            )
        }
    }
}
