//
//  GameCommandsModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.04.21.
//

import SwiftUI
import SmartColonyMacOSUILibrary

// https://troz.net/post/2021/swiftui_mac_menus/
class GameCommandsModel: ObservableObject {

    var viewModel: MainViewModel?

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var showDisplayResourceMarkers: Bool = false {
        didSet {
            self.changeDisplayResourceMarkers(to: self.showDisplayResourceMarkers)
        }
    }

    @Published
    var showDisplayYields: Bool = false {
        didSet {
            self.changeDisplayYields(to: self.showDisplayYields)
        }
    }

    @Published
    var showDisplayGrid: Bool = false {
        didSet {
            self.changeDisplayGrid(to: self.showDisplayGrid)
        }
    }

    // debug

    @Published
    var showDisplayHexCoordinates: Bool = false {
        didSet {
            self.changeDisplayHexCoordinates(to: self.showDisplayHexCoordinates)
        }
    }

    @Published
    var showDisplayCompleteMap: Bool = false {
        didSet {
            self.changeDisplayCompleteMap(to: self.showDisplayCompleteMap)
        }
    }

    // MARK: constructor

    init() {

        self.showDisplayGrid = gameEnvironment.displayOptions.value.showGrid
        self.showDisplayResourceMarkers = gameEnvironment.displayOptions.value.showResourceMarkers
        self.showDisplayYields = gameEnvironment.displayOptions.value.showYields

        // debug
        self.showDisplayHexCoordinates = gameEnvironment.displayOptions.value.showHexCoordinates
        self.showDisplayCompleteMap = gameEnvironment.displayOptions.value.showCompleteMap
    }

    // MARK: methods

    func centerCapital() {
        self.viewModel?.centerCapital()
    }

    func centerOnCursor() {
        self.viewModel?.centerOnCursor()
    }

    func zoomIn() {
        self.viewModel?.zoomIn()
    }

    func zoomOut() {
        self.viewModel?.zoomOut()
    }

    func zoomReset() {
        self.viewModel?.zoomReset()
    }

    // map display options

    func changeDisplayResourceMarkers(to value: Bool) {

        self.viewModel?.gameViewModel.mapOptionShowResourceMarkers = value
    }

    func changeDisplayYields(to value: Bool) {

        self.viewModel?.gameViewModel.mapOptionShowYields = value
    }

    func changeDisplayGrid(to value: Bool) {

        self.viewModel?.gameViewModel.mapOptionShowGrid = value
    }

    func changeDisplayHexCoordinates(to value: Bool) {

        self.viewModel?.gameViewModel.mapOptionShowHexCoordinates = value
    }

    func changeDisplayCompleteMap(to value: Bool) {

        self.viewModel?.gameViewModel.mapOptionShowCompleteMap = value
    }
}
