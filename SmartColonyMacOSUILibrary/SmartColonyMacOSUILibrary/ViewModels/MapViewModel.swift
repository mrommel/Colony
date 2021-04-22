//
//  GameViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.03.21.
//

import SmartAILibrary
import SmartAssets
import Cocoa
import SwiftUI

/*protocol MapViewModelDelegate: class {
    
    func sizeChanged(to size: CGSize)
    func shiftChanged(to shift: CGPoint)
}*/

public class MapViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    // layers
    var terrainLayerViewModel: TerrainLayerViewModel?
    var riverLayerViewModel: RiverLayerViewModel?
    var borderLayerViewModel: BorderLayerViewModel?
    var roadLayerViewModel: RoadLayerViewModel?
    var cursorLayerViewModel: CursorLayerViewModel?
    var featureLayerViewModel: FeatureLayerViewModel?
    var resourceLayerViewModel: ResourceLayerViewModel?
    var improvementLayerViewModel: ImprovementLayerViewModel?
    var cityLayerViewModel: CityLayerViewModel?
    var unitLayerViewModel: UnitLayerViewModel?
    // resourceMarker
    
    // layers - debug
    var hexCoordLayerViewModel: HexCoordLayerViewModel?
    
    @Published
    public var shift: CGPoint = .zero
    
    @Published
    public var size: CGSize = .zero
    
    private let factor: CGFloat = 3.0
    
    public init() {
        
        self.terrainLayerViewModel = TerrainLayerViewModel()
        self.riverLayerViewModel = RiverLayerViewModel()
        self.borderLayerViewModel = BorderLayerViewModel()
        self.roadLayerViewModel = RoadLayerViewModel()
        self.cursorLayerViewModel = CursorLayerViewModel()
        self.featureLayerViewModel = FeatureLayerViewModel()
        self.resourceLayerViewModel = ResourceLayerViewModel()
        self.improvementLayerViewModel = ImprovementLayerViewModel()
        self.cityLayerViewModel = CityLayerViewModel()
        self.unitLayerViewModel = UnitLayerViewModel()
        
        // debug
        self.hexCoordLayerViewModel = HexCoordLayerViewModel()
    }
    
    func gameUpdated() {

        self.terrainLayerViewModel?.update(from: self.gameEnvironment.game.value)
        self.riverLayerViewModel?.update(from: self.gameEnvironment.game.value)
        self.borderLayerViewModel?.update(from: self.gameEnvironment.game.value)
        self.roadLayerViewModel?.update(from: self.gameEnvironment.game.value)
        self.cursorLayerViewModel?.update(from: self.gameEnvironment.game.value)
        self.featureLayerViewModel?.update(from: self.gameEnvironment.game.value)
        self.resourceLayerViewModel?.update(from: self.gameEnvironment.game.value)
        self.improvementLayerViewModel?.update(from: self.gameEnvironment.game.value)
        self.cityLayerViewModel?.update(from: self.gameEnvironment.game.value)
        self.unitLayerViewModel?.update(from: self.gameEnvironment.game.value)
        
        // debug
        self.hexCoordLayerViewModel?.update(from: self.gameEnvironment.game.value)
        
        // overview
        // self.mapOverviewViewModel?.update()
        
        //self.gameEnvironment.game?.userInterface = self
        
        guard let contentSize = self.gameEnvironment.game.value?.contentSize(), let mapSize = self.gameEnvironment.game.value?.mapSize() else {
            fatalError("cant get sizes")
        }
        
        self.size = CGSize(width: (contentSize.width + 10) * self.factor, height: contentSize.height * self.factor)
        
        //self.delegate?.sizeChanged(to: self.size)
        
        // init shift
        let p0 = HexPoint(x: 0, y: 0)
        let p1 = HexPoint(x: 0, y: mapSize.height() - 1)
        let p2 = HexPoint(x: mapSize.width() - 1, y: mapSize.height() - 1)
        let dx = HexPoint.toScreen(hex: p0).x - HexPoint.toScreen(hex: p1).x
        let dy = HexPoint.toScreen(hex: p0).y - HexPoint.toScreen(hex: p2).y
        
        self.shift = CGPoint(x: dx, y: dy) * self.factor
        
        //self.delegate?.shiftChanged(to: self.shift)
    }
    
    /*public func centerOnCursor() {
        
    }*/
    
    public func doTurn() {
        
        print("turn")
        /*guard let humanPlayer = self.game?.humanPlayer() else {
            fatalError("no human player given")
        }
        
        while !humanPlayer.canFinishTurn() {

            self.game?.update()
        }

        humanPlayer.endTurn(in: self.game)*/
    }
}

extension MapViewModel: UserInterfaceDelegate {
    
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
