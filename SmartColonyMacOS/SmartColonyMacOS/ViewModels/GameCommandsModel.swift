//
//  GameCommandsModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.04.21.
//

import SwiftUI
import SmartMacOSUILibrary

// https://troz.net/post/2021/swiftui_mac_menus/
class GameCommandsModel: ObservableObject {

    var viewModel: MainViewModel? = nil
    
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
    var showDisplayWater: Bool = false {
        didSet {
            self.changeDisplayWater(to: self.showDisplayWater)
        }
    }
    
    // debug
    
    @Published
    var showDisplayHexCoordinates: Bool = false {
        didSet {
            self.changeDisplayHexCoordinates(to: self.showDisplayHexCoordinates)
        }
    }
    
    // MARK: constructor
    
    init() {

        self.showDisplayResourceMarkers = gameEnvironment.displayOptions.value.showResourceMarkers
        self.showDisplayYields = gameEnvironment.displayOptions.value.showYields
        self.showDisplayWater = gameEnvironment.displayOptions.value.showWater
        
        // debug
        self.showDisplayHexCoordinates = gameEnvironment.displayOptions.value.showHexCoordinates
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
    
    func changeDisplayWater(to value: Bool) {
        
        self.viewModel?.gameViewModel.mapOptionShowWater = value
    }
    
    func changeDisplayHexCoordinates(to value: Bool) {
        
        self.viewModel?.gameViewModel.mapOptionShowHexCoordinates = value
    }
}
