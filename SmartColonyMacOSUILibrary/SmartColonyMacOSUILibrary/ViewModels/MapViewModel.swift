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
    var waterLayerViewModel: WaterLayerViewModel?
    var resourceLayerViewModel: ResourceLayerViewModel?
    var improvementLayerViewModel: ImprovementLayerViewModel?
    var cityLayerViewModel: CityLayerViewModel?
    var unitLayerViewModel: UnitLayerViewModel?
    var resourceMarkerLayerViewModel: ResourceMarkerLayerViewModel?
    var yieldsLayerViewModel: YieldsLayerViewModel?
    
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
        self.waterLayerViewModel = WaterLayerViewModel()
        self.resourceLayerViewModel = ResourceLayerViewModel()
        self.improvementLayerViewModel = ImprovementLayerViewModel()
        self.cityLayerViewModel = CityLayerViewModel()
        self.unitLayerViewModel = UnitLayerViewModel()
        self.resourceMarkerLayerViewModel = ResourceMarkerLayerViewModel()
        self.yieldsLayerViewModel = YieldsLayerViewModel()
        
        // debug
        self.hexCoordLayerViewModel = HexCoordLayerViewModel()
    }
    
    func gameUpdated() {
        
        let game: GameModel? = self.gameEnvironment.game.value
        let showCompleteMap: Bool = self.gameEnvironment.displayOptions.value.showCompleteMap
        
        print("redraw map with showCompleteMap: \(showCompleteMap)")

        self.terrainLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        self.riverLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        self.borderLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        self.roadLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        self.cursorLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        self.featureLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        self.waterLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        self.resourceLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        self.improvementLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        self.cityLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        self.unitLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        self.resourceMarkerLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        self.yieldsLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        
        // debug
        self.hexCoordLayerViewModel?.update(from: game, showCompleteMap: showCompleteMap)
        
        // overview
        // self.mapOverviewViewModel?.update()
        
        //self.gameEnvironment.game?.userInterface = self
        
        guard let contentSize = game?.contentSize(), let mapSize = game?.mapSize() else {
            fatalError("cant get sizes")
        }
        
        self.size = CGSize(width: (contentSize.width + 10) * self.factor, height: contentSize.height * self.factor)
        
        // init shift
        let p0 = HexPoint(x: 0, y: 0)
        let p1 = HexPoint(x: 0, y: mapSize.height() - 1)
        let p2 = HexPoint(x: mapSize.width() - 1, y: mapSize.height() - 1)
        let dx = HexPoint.toScreen(hex: p0).x - HexPoint.toScreen(hex: p1).x
        let dy = HexPoint.toScreen(hex: p0).y - HexPoint.toScreen(hex: p2).y
        
        self.shift = CGPoint(x: dx, y: dy) * self.factor
    }
    
    public func doTurn() {
        
        print("MapViewModel::turn")
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
