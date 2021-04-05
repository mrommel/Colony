//
//  GameViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.03.21.
//

import SmartAILibrary
import SmartAssets
import Cocoa

protocol GameViewModelDelegate: class {
    
    func sizeChanged(to size: CGSize)
    func shiftChanged(to shift: CGPoint)
}

public class GameViewModel {
    
    var terrainLayerViewModel: TerrainLayerViewModel?
    var riverLayerViewModel: RiverLayerViewModel?
    // border
    // cursor?
    var featureLayerViewModel: FeatureLayerViewModel?
    var resourceLayerViewModel: ResourceLayerViewModel?
    
    // debug
    var hexCoordLayerViewModel: HexCoordLayerViewModel?
    
    public var shift: CGPoint = .zero
    public var size: CGSize = .zero
    let factor: CGFloat = 3.0
    
    weak var delegate: GameViewModelDelegate?
    
    public var game: GameModel? {
        didSet {
            self.terrainLayerViewModel = TerrainLayerViewModel(game: self.game)
            self.terrainLayerViewModel?.update()
            
            self.riverLayerViewModel = RiverLayerViewModel(game: self.game)
            self.riverLayerViewModel?.update()
            
            // border
            // cursor?
            
            self.featureLayerViewModel = FeatureLayerViewModel(game: self.game)
            self.featureLayerViewModel?.update()
            
            self.resourceLayerViewModel = ResourceLayerViewModel(game: self.game)
            self.resourceLayerViewModel?.update()
            
            self.hexCoordLayerViewModel = HexCoordLayerViewModel(game: self.game)
            self.hexCoordLayerViewModel?.update()
            
            self.game?.userInterface = self
            
            guard let contentSize = self.game?.contentSize(), let mapSize = self.game?.mapSize() else {
                fatalError("cant get sizes")
            }
            
            self.size = CGSize(width: (contentSize.width + 10) * self.factor, height: contentSize.height * self.factor)
            
            self.delegate?.sizeChanged(to: self.size)
            
            // init shift
            let p0 = HexPoint(x: 0, y: 0)
            let p1 = HexPoint(x: 0, y: mapSize.height() - 1)
            let p2 = HexPoint(x: mapSize.width() - 1, y: mapSize.height() - 1)
            let dx = HexPoint.toScreen(hex: p0).x - HexPoint.toScreen(hex: p1).x
            let dy = HexPoint.toScreen(hex: p0).y - HexPoint.toScreen(hex: p2).y
            
            self.shift = CGPoint(x: dx, y: dy) * self.factor
            
            self.delegate?.shiftChanged(to: self.shift)
        }
    }
    
    public init() {
        
        self.terrainLayerViewModel = nil
        self.riverLayerViewModel = nil
        // border
        // cursor?
        self.featureLayerViewModel = nil
        self.resourceLayerViewModel = nil
        
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

        print("- load \(textures.allFeatureTextureNames.count) feature (+ \(textures.allIceFeatureTextureNames.count) ice) textures")
        for featureTextureName in textures.allFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: featureTextureName), for: featureTextureName)
        }

        for iceFeatureTextureName in textures.allIceFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: iceFeatureTextureName), for: iceFeatureTextureName)
        }

        print("- load \(textures.allResourceTextureNames.count) resource textures")
        for resourceTextureName in textures.allResourceTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: resourceTextureName), for: resourceTextureName)
        }
        
        print("- load \(textures.allBorderTextureNames.count) border textures")
        for borderTextureName in textures.allBorderTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: borderTextureName), for: borderTextureName)
        }

        print("-- all textures loaded --")
        
        // populate cache if needed
        if !ImageCache.shared.exists(key: "cursor") {
            ImageCache.shared.add(image: NSImage(named: "cursor"), for: "cursor")
        }
    }
    
    public func doTurn() {
        
        print("turn")
        guard let humanPlayer = self.game?.humanPlayer() else {
            fatalError("no human player given")
        }
        
        while !humanPlayer.canFinishTurn() {

            self.game?.update()
        }

        humanPlayer.endTurn(in: self.game)
    }
}

extension GameViewModel: UserInterfaceDelegate {
    
    public func showPopup(popupType: PopupType, with data: PopupData?) {
        
    }
    
    public func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData?) {
        
    }
    
    public func showLeaderMessage(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, deal: DiplomaticDeal?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType) {
        
    }
    
    public func isShown(screen: ScreenType) -> Bool {
        return false
    }
    
    public func add(notification: NotificationItem) {
        
    }
    
    public func remove(notification: NotificationItem) {
        
    }
    
    public func select(unit: AbstractUnit?) {
        
    }
    
    public func unselect() {
        
    }
    
    public func show(unit: AbstractUnit?) {
        
    }
    
    public func hide(unit: AbstractUnit?) {
        
    }
    
    public func refresh(unit: AbstractUnit?) {
        
    }
    
    public func move(unit: AbstractUnit?, on points: [HexPoint]) {
        
    }
    
    public func animate(unit: AbstractUnit?, animation: UnitAnimationType) {
        
    }
    
    public func select(tech: TechType) {
        
    }
    
    public func select(civic: CivicType) {
        
    }
    
    public func askToDisband(unit: AbstractUnit?, completion: @escaping (Bool) -> ()) {
        
    }
    
    public func askForCity(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping (AbstractCity?) -> ()) {
        
    }
    
    public func show(city: AbstractCity?) {
        
    }
    
    public func update(city: AbstractCity?) {
        
    }
    
    public func refresh(tile: AbstractTile?) {
        
    }
    
    public func showTooltip(at point: HexPoint, text: String, delay: Double) {
        
    }
    
    public func focus(on location: HexPoint) {
        
    }
}
