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
import SmartMacOSUILibrary

protocol CreateGameMenuViewModelDelegate: AnyObject {
    
    func started(with leaderType: LeaderType, on handicapType: HandicapType, with mapType: MapType, and mapSize: MapSize)
    func canceled()
}

class CreateGameMenuViewModel: ObservableObject {
    
    @Published
    var selectedLeaderIndex: Int = 1 // 0
    
    @Published
    var selectedDifficultyIndex: Int = 0
    
    @Published
    var selectedMapTypeIndex: Int = 3 // 0
    
    @Published
    var selectedMapSizeIndex: Int = 0
    
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
        
        let allLeaders = [LeaderType.none] + LeaderType.all
        let leaderType = allLeaders[self.selectedLeaderIndex]
        
        let handicap = HandicapType.all[self.selectedDifficultyIndex]
        
        let mapType = MapType.all[self.selectedMapTypeIndex]
        let mapSize = MapSize.all[self.selectedMapSizeIndex]
        
        print("--- start game with: \(leaderType.name()) on \(handicap) with a map: \(mapType) (\(mapSize))")
        
        self.delegate?.started(with: leaderType, on: handicap, with: mapType, and: mapSize)
    }
    
    func cancel() {
        
        self.delegate?.canceled()
    }
    
    // MARK: private methods
    
    private func leaderImage(for leaderType: LeaderType, targetSize: NSSize = NSSize(width: 16, height: 16)) -> NSImage {

        let bundle = Bundle.init(for: Textures.self)
        
        return (bundle.image(forResource: leaderType.iconTexture())?.resize(withSize: targetSize)) ?? NSImage(named: "sun.max.fill")!
    }
    
    private func handicapImage(for handicapType: HandicapType, targetSize: NSSize = NSSize(width: 16, height: 16)) -> NSImage {

        let bundle = Bundle.init(for: Textures.self)
        
        return (bundle.image(forResource: handicapType.textureName())?.resize(withSize: targetSize)) ?? NSImage(named: "sun.max.fill")!
    }
    
    private func mapTypeImage(for mapType: MapType, targetSize: NSSize = NSSize(width: 16, height: 16)) -> NSImage {
        
        let bundle = Bundle.init(for: Textures.self)
        
        return (bundle.image(forResource: mapType.textureName())?.resize(withSize: targetSize)) ?? NSImage(named: "sun.max.fill")!
    }
    
    private func mapSizeImage(for mapSize: MapSize, targetSize: NSSize = NSSize(width: 16, height: 16)) -> NSImage {
        
        let bundle = Bundle.init(for: Textures.self)
        
        return (bundle.image(forResource: mapSize.textureName())?.resize(withSize: targetSize)) ?? NSImage(named: "sun.max.fill")!
    }
}
