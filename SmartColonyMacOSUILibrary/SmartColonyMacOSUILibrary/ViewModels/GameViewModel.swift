//
//  GameViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.04.21.
//

import SmartAILibrary
import SmartAssets
import Cocoa
import SwiftUI

protocol GameViewModelDelegate: AnyObject {
    
    func focus(on point: HexPoint)
    
    func showChangeGovernmentDialog()
    func showChangePoliciesDialog()
    
    func closeDialog()
}

public class GameViewModel: ObservableObject {
    
    // type of shown dialog - highlander - there can only be one
    enum DialogType {
        
        case none // standard
        
        case government
        case policy
    }

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var focusPosition: HexPoint? = nil
    
    @Published
    var magnification: CGFloat = 1.0
    
    @Published
    var gameSceneViewModel: GameSceneViewModel
    
    // UI
    
    @Published
    var shownDialog: DialogType = .none
    
    // MARK: map display options
    
    @Published
    public var mapOptionShowResourceMarkers: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showResourceMarkers = self.mapOptionShowResourceMarkers
        }
    }
    
    @Published
    public var mapOptionShowYields: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showYields = self.mapOptionShowYields
        }
    }
    
    @Published
    public var mapOptionShowWater: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showWater = self.mapOptionShowWater
        }
    }
    
    // debug
    
    @Published
    public var mapOptionShowHexCoordinates: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showHexCoordinates = self.mapOptionShowHexCoordinates
        }
    }
    
    @Published
    public var mapOptionShowCompleteMap: Bool = false {
        didSet {
            self.gameEnvironment.displayOptions.value.showCompleteMap = self.mapOptionShowCompleteMap
        }
    }
    
    private let textureNames: [String] = ["water", "focus-attack1", "focus-attack2", "focus-attack3", "focus1", "focus2", "focus3", "focus4", "focus5", "focus6", "unit-type-background", "cursor"]
    
    // MARK: constructor
    
    public init(preloadAssets: Bool = false) {
        
        self.gameSceneViewModel = GameSceneViewModel()
        self.gameSceneViewModel.delegate = self
        
        self.mapOptionShowResourceMarkers = self.gameEnvironment.displayOptions.value.showResourceMarkers
        self.mapOptionShowWater = self.gameEnvironment.displayOptions.value.showWater
        self.mapOptionShowYields = self.gameEnvironment.displayOptions.value.showYields
        
        self.mapOptionShowHexCoordinates = self.gameEnvironment.displayOptions.value.showHexCoordinates
        self.mapOptionShowCompleteMap = self.gameEnvironment.displayOptions.value.showCompleteMap
        
        if preloadAssets {
            self.loadAssets()
        }
    }
    
    public func loadAssets() {
        
        // load assets into image cache
        print("-- pre-load images --")
        let bundle = Bundle.init(for: Textures.self)
        let textures: Textures = Textures(game: nil)

        print("- load \(textures.allTerrainTextureNames.count) terrain, \(textures.allRiverTextureNames.count) river and \(textures.allCoastTextureNames.count) coast textures")
        for terrainTextureName in textures.allTerrainTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: terrainTextureName), for: terrainTextureName)
        }

        for coastTextureName in textures.allCoastTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: coastTextureName), for: coastTextureName)
        }

        for riverTextureName in textures.allRiverTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: riverTextureName), for: riverTextureName)
        }

        print("- load \(textures.allFeatureTextureNames.count) feature (+ \(textures.allIceFeatureTextureNames.count) ice + \(textures.allSnowFeatureTextureNames.count) snow textures")
        for featureTextureName in textures.allFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: featureTextureName), for: featureTextureName)
        }

        for iceFeatureTextureName in textures.allIceFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: iceFeatureTextureName), for: iceFeatureTextureName)
        }
        
        for snowFeatureTextureName in textures.allSnowFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: snowFeatureTextureName), for: snowFeatureTextureName)
        }

        print("- load \(textures.allResourceTextureNames.count) resource and marker textures")
        for resourceTextureName in textures.allResourceTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: resourceTextureName), for: resourceTextureName)
        }
        for resourceMarkerTextureName in textures.allResourceMarkerTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: resourceMarkerTextureName), for: resourceMarkerTextureName)
        }
        
        print("- load \(textures.allBorderTextureNames.count) border textures")
        for borderTextureName in textures.allBorderTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: borderTextureName), for: borderTextureName)
        }
        
        print("- load \(textures.allYieldsTextureNames.count) yield textures")
        for yieldTextureName in textures.allYieldsTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: yieldTextureName), for: yieldTextureName)
        }
        
        print("- load \(textures.allBoardTextureNames.count) board textures")
        for boardTextureName in textures.allBoardTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: boardTextureName), for: boardTextureName)
        }
        
        print("- load \(textures.allImprovementTextureNames.count) improvement textures")
        for improvementTextureName in textures.allImprovementTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: improvementTextureName), for: improvementTextureName)
        }
        
        print("- load \(textures.allPathTextureNames.count) + \(textures.allPathOutTextureNames.count) path textures")
        for pathTextureName in textures.allPathTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: pathTextureName), for: pathTextureName)
        }
        for pathTextureName in textures.allPathOutTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: pathTextureName), for: pathTextureName)
        }
        
        var unitTextures: Int = 0
        for unitType in UnitType.all {
            
            if let idleTextures = unitType.idleAtlas?.textures {
                for (index, texture) in idleTextures.enumerated() {
                    ImageCache.shared.add(image: texture, for: "\(unitType.name().lowercased())-idle-\(index)")
                    
                    unitTextures += 1
                }
            } else {
                print("cant get idle textures of \(unitType.name())")
            }
            
            ImageCache.shared.add(image: bundle.image(forResource: unitType.typeTexture()), for: unitType.typeTexture())
        }
        print("- load \(unitTextures) unit textures")
        
        // populate cache with ui textures
        print("- load \(self.textureNames.count) misc textures")
        for textureName in self.textureNames {
            if !ImageCache.shared.exists(key: textureName) {
                // load from SmartAsset package
                ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
            }
        }
        
        print("- load \(textures.buttonTextureNames.count) button textures")
        for buttonTextureName in textures.buttonTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: buttonTextureName), for: buttonTextureName)
        }
        
        print("- load \(textures.commandTextureNames.count) + \(textures.commandButtonTextureNames.count) command textures")
        for commandTextureName in textures.commandTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: commandTextureName), for: commandTextureName)
        }
        
        for commandButtonTextureName in textures.commandButtonTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: commandButtonTextureName), for: commandButtonTextureName)
        }
        
        print("- load \(textures.policyCardTextureNames.count) policy card textures")
        for policyCardTextureName in textures.policyCardTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: policyCardTextureName), for: policyCardTextureName)
        }
        
        print("- load \(textures.governmentStateBackgroundTextureNames.count) government state background textures")
        for governmentStateBackgroundTextureName in textures.governmentStateBackgroundTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: governmentStateBackgroundTextureName), for: governmentStateBackgroundTextureName)
        }
        
        print("- load \(textures.governmentTextureNames.count) government and \(textures.governmentAmbientTextureNames.count) ambient textures")
        for governmentTextureName in textures.governmentTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: governmentTextureName), for: governmentTextureName)
        }
        for governmentAmbientTextureName in textures.governmentAmbientTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: governmentAmbientTextureName), for: governmentAmbientTextureName)
        }
        
        print("-- all textures loaded --")
    }
    
    public func centerCapital() {
        
        guard let game = self.gameEnvironment.game.value else {
            print("cant center on capital: game not set")
            return
        }
        
        guard let human = game.humanPlayer() else {
            print("cant center on capital: human not set")
            return
        }
        
        if let capital = game.capital(of: human) {
            self.gameEnvironment.moveCursor(to: capital.location)
            self.centerOnCursor()
            return
        }
            
        if let unitRef = game.units(of: human).first, let unit = unitRef {
            self.gameEnvironment.moveCursor(to: unit.location)
            self.centerOnCursor()
            return
        }
        
        print("cant center on capital: no capital nor units")
    }
    
    public func centerOnCursor() {
        
        let cursor = self.gameEnvironment.cursor.value
        
        /*guard let contentSize = self.gameEnvironment.game.value?.contentSize(),
              let mapSize = self.gameEnvironment.game.value?.mapSize() else {
            fatalError("cant get sizes")
        }
        
        let size = CGSize(width: (contentSize.width + 10) * 3.0, height: contentSize.height * 3.0)
        
        // init shift
        let p0 = HexPoint(x: 0, y: 0)
        let p1 = HexPoint(x: 0, y: mapSize.height() - 1)
        let p2 = HexPoint(x: mapSize.width() - 1, y: mapSize.height() - 1)
        let dx = HexPoint.toScreen(hex: p0).x - HexPoint.toScreen(hex: p1).x
        let dy = HexPoint.toScreen(hex: p0).y - HexPoint.toScreen(hex: p2).y
        
        let shift = CGPoint(x: dx, y: dy) * 3.0
        
        var screenPoint = HexPoint.toScreen(hex: cursor) * 3.0 + shift
        
        screenPoint.y = size.height - screenPoint.y - 144* /
        
        print("scroll to: \(cursor) => \(screenPoint)")
        self.contentOffset/ *.scrollTarget* / = screenPoint*/
        //self.contentOffset = HexPoint.toScreen(hex: cursor)
    }
    
    public func zoomIn() {
        
        self.magnification = self.magnification * 0.75
    }
    
    public func zoomOut() {
        
        self.magnification = self.magnification / 0.75
    }
    
    public func zoomReset() {
        
        //self.magnificationTarget = 1.0
        self.magnification = 1.0
    }
}

extension GameViewModel: GameViewModelDelegate {

    func focus(on point: HexPoint) {
        
        self.focusPosition = point
    }
    
    func showChangeGovernmentDialog() {
        
        if self.shownDialog == .government {
            // already shown
            return
        }
        
        if self.shownDialog == .none {
            self.shownDialog = .government
        } else {
            fatalError("cant show policy dialog, \(self.shownDialog) is currently shown")
        }
    }
    
    func showChangePoliciesDialog() {
        
        if self.shownDialog == .policy {
            // already shown
            return
        }
        
        if self.shownDialog == .none {
            self.shownDialog = .policy
        } else {
            fatalError("cant show policy dialog, \(self.shownDialog) is currently shown")
        }
    }
    
    func closeDialog() {
        
        self.shownDialog = .none
    }
}
