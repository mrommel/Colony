//
//  CreateGameMenuViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import Foundation
import SmartAssets
import Cocoa
import SmartAILibrary

struct PickerData {
    let name: String
    let image: NSImage
}

protocol CreateGameMenuViewModelDelegate: class {
    
    func started()
    func canceled()
}

class CreateGameMenuViewModel: ObservableObject {
    
    @Published
    private var selectedLeaderIndex = 0
    
    @Published
    private var selectedDifficultyIndex = 0
    
    @Published
    private var selectedMapTypeIndex = 0
    
    @Published
    private var selectedMapSizeIndex = 0
    
    weak var delegate: CreateGameMenuViewModelDelegate?
    
    var leaders: [PickerData] {
        
        var array: [PickerData] = []

        for leaderType in [LeaderType.none] + LeaderType.all {
            array.append(PickerData(name: leaderType.name(), image: self.leaderImage(for: leaderType)))
        }
        
        return array
    }
    
    var handicaps: [PickerData] {
        
        var array: [PickerData] = []

        for handicapType in HandicapType.all {
            array.append(PickerData(name: handicapType.name(), image: self.handicapImage(for: handicapType)))
        }
        
        return array
    }
    
    var mapTypes: [PickerData] {
        
        var array: [PickerData] = []

        for mapType in MapType.all {
            array.append(PickerData(name: mapType.name(), image: self.mapTypeImage(for: mapType)))
        }
        
        return array
    }
    
    var mapSizes: [PickerData] {
        
        var array: [PickerData] = []

        for mapSize in MapSize.all {
            array.append(PickerData(name: mapSize.name(), image: self.mapSizeImage(for: mapSize)))
        }
        
        return array
    }
    
    // MARK: methods methods
    
    func start() {
        
        self.delegate?.started()
    }
    
    func cancel() {
        
        self.delegate?.canceled()
    }
    
    // MARK: private methods
    
    private func leaderImage(for leaderType: LeaderType, targetSize: NSSize = NSSize(width: 16, height: 16)) -> NSImage {

        let bundle = Bundle.init(for: Textures.self)
        
        return (bundle.image(forResource: leaderType.textureName())?.resize(withSize: targetSize))!
    }
    
    private func handicapImage(for handicapType: HandicapType, targetSize: NSSize = NSSize(width: 16, height: 16)) -> NSImage {

        let bundle = Bundle.init(for: Textures.self)
        
        return (bundle.image(forResource: handicapType.textureName())?.resize(withSize: targetSize))!
    }
    
    private func mapTypeImage(for mapType: MapType, targetSize: NSSize = NSSize(width: 16, height: 16)) -> NSImage {
        
        let bundle = Bundle.init(for: Textures.self)
        
        return (bundle.image(forResource: mapType.textureName())?.resize(withSize: targetSize))!
    }
    
    private func mapSizeImage(for mapSize: MapSize, targetSize: NSSize = NSSize(width: 16, height: 16)) -> NSImage {
        
        let bundle = Bundle.init(for: Textures.self)
        
        return (bundle.image(forResource: mapSize.textureName())?.resize(withSize: targetSize))!
    }
}
