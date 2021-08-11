//
//  HexagonGridViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

enum TileActionType {
    
    case none
    
    case purchasable
    case nonPurchasable
    case available
    case worked
    case forceWorked
    
    var textureName: String? {
        
        switch self {
        
        case .none: return nil
            
        case .purchasable: return "tile-purchase-active"
        case .nonPurchasable: return "tile-purchase-disabled"
            
        case .available: return "tile-citizen-normal"
        case .worked: return "tile-citizen-selected"
        case .forceWorked: return "tile-citizen-forced"
        }
    }
}

protocol HexagonGridViewModelDelegate: AnyObject {
    
    func purchaseTile(at point: HexPoint)
    func forceWorking(on point: HexPoint)
    func stopWorking(on point: HexPoint)
}

class HexagonGridViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var hexagonViewModels: [HexagonViewModel] = []
    
    @Published
    var showCitizenIcons: Bool = false
    
    @Published
    var focused: CGSize = .zero
    
    weak var delegate: HexagonGridViewModelDelegate? = nil
    
    private var workedCity: AbstractCity? = nil
    
    // MARK: constructor

    init(gameModel: GameModel? = nil) {
        
        if gameModel != nil {
            self.update(for: nil, with: gameModel)
        }
    }
    
    // MARK: public methods
    
    func update(for cityRef: AbstractCity?, with gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }
        
        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get player")
        }
        
        guard let city = cityRef else {
            fatalError("cant get city")
        }
        
        self.workedCity = cityRef
            
        let screenPoint = HexPoint.toScreen(hex: city.location)
        self.focused = CGSize(fromPoint: CGPoint(x: -screenPoint.x, y: screenPoint.y))
        self.showCitizenIcons = true
        
        var tmpHexagonViewModels: [HexagonViewModel] = []
        
        let mapSize = gameModel.mapSize()
        
        for y in 0..<mapSize.height() {
            for x in 0..<mapSize.width() {
                
                guard city.location.distanceTo(x: x, y: y) < 12 else {
                    continue
                }
                
                guard let tile = gameModel.tile(x: x, y: y) else {
                    continue
                }
                
                let color: NSColor = self.tileColor(of: tile, for: humanPlayer)
                let mountains: String? = self.mountainsTextureName(of: tile, for: humanPlayer)
                let hills: String? = self.hillsTextureName(of: tile, for: humanPlayer)
                let forest: String? = self.forestTextureName(of: tile, for: humanPlayer)
                let cityTexture: String? = self.cityTextureName(of: tile, for: humanPlayer)
                let tileAction: String? = self.tileActionTextureName(of: tile, with: city, for: humanPlayer, in: gameModel)

                let hexagonViewModel = HexagonViewModel(at: tile.point,
                                                        tileColor: color,
                                                        mountains: mountains,
                                                        hills: hills,
                                                        forest: forest,
                                                        city: cityTexture,
                                                        tileAction: tileAction,
                                                        showCitizenIcons: self.showCitizenIcons)
                hexagonViewModel.delegate = self
                tmpHexagonViewModels.append(hexagonViewModel)
            }
        }
        
        DispatchQueue.main.async {
            self.hexagonViewModels = tmpHexagonViewModels
            print("updated city tiles")
        }
    }
    
    func updateWorkingTiles(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }
        
        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get player")
        }
        
        guard let city = self.workedCity else {
            fatalError("cant get city")
        }
        
        guard let cityCitizens = city.cityCitizens else {
            fatalError("cant get cityCitizens")
        }
        
        for workingTileLocation in cityCitizens.workingTileLocations() {
            
            guard let tile = gameModel.tile(at: workingTileLocation) else {
                continue
            }
            
            if let model = self.hexagonViewModels.first(where: { $0.point == tile.point }) {
                
                let tileAction: String? = self.tileActionTextureName(of: tile, with: city, for: humanPlayer, in: gameModel)
                model.update(tileAction: tileAction)
            }
        }
    }
    
    // MARK: private methods
    
    private func tileColor(of tile: AbstractTile, for player: AbstractPlayer) -> NSColor {
        
        if tile.isVisible(to: player) {
            return tile.terrain().overviewColor()
        } else if tile.isDiscovered(by: player) {
            return tile.terrain().forgottenColor()
        } else {
            return Globals.Colors.overviewBackground
        }
    }
    
    private func mountainsTextureName(of tile: AbstractTile, for player: AbstractPlayer) -> String? {
        
        guard tile.feature() == .mountains else {
            return nil
        }
        
        if tile.isVisible(to: player) {
            return "overview-mountains"
        } else if tile.isDiscovered(by: player) {
            return "overview-mountains-passive"
        } else {
            return nil
        }
    }
    
    private func hillsTextureName(of tile: AbstractTile, for player: AbstractPlayer) -> String? {
        
        guard tile.hasHills() else {
            return nil
        }
        
        if tile.isVisible(to: player) {
            return "overview-hills"
        } else if tile.isDiscovered(by: player) {
            return "overview-hills-passive"
        } else {
            return nil
        }
    }
    
    private func forestTextureName(of tile: AbstractTile, for player: AbstractPlayer) -> String? {
        
        guard tile.feature() == .forest else {
            return nil
        }
        
        if tile.isVisible(to: player) {
            return "overview-forest"
        } else if tile.isDiscovered(by: player) {
            return "overview-forest-passive"
        } else {
            return nil
        }
    }
    
    private func cityTextureName(of tile: AbstractTile, for player: AbstractPlayer) -> String? {
        
        guard tile.isCity() else {
            return nil
        }
        
        if tile.isVisible(to: player) {
            return "overview-city"
        } else if tile.isDiscovered(by: player) {
            return "overview-city-passive"
        } else {
            return nil
        }
    }
    
    private func tileActionTextureName(of tile: AbstractTile, with city: AbstractCity, for player: AbstractPlayer, in gameModel: GameModel?) -> String? {
        
        return self.tileAction(of: tile, with: city, for: player, in: gameModel).textureName
    }
    
    private func tileAction(of tile: AbstractTile, with city: AbstractCity, for player: AbstractPlayer, in gameModel: GameModel?) -> TileActionType {
        
        guard let treasury = player.treasury else {
            return .none
        }
        
        let workingCity = tile.workingCity()
        
        if player.isEqual(to: workingCity?.player) {
            
            guard let citizens = workingCity?.cityCitizens else {
                return .none
            }
            
            let selected = citizens.isWorked(at: tile.point) || tile.point == workingCity?.location
            let forced = citizens.isForcedWorked(at: tile.point)

            if tile.isVisible(to: player) {

                if forced {
                    return .forceWorked
                }
                
                if selected {
                    return .worked
                }
                
                return .available
            }
        } else {
            
            var isNeighborWorkedByCity = false
            
            for neighbor in tile.point.neighbors() {

                if let neighborTile = gameModel?.tile(at: neighbor), let neighboringTileOwner = neighborTile.workingCity()?.player {
                    if player.isEqual(to: neighboringTileOwner) {
                        isNeighborWorkedByCity = true
                    }
                }
            }
            
            if isNeighborWorkedByCity && tile.isVisible(to: player) {

                let cost: Double = city.buyPlotCost(at: tile.point, in: gameModel)

                if cost <= treasury.value() {
                    return .purchasable
                } else {
                    return .nonPurchasable
                }
            }
        }

        return .none
    }
}

extension HexagonGridViewModel: HexagonViewModelDelegate {
    
    func clicked(on point: HexPoint) {
        
        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }
        
        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get player")
        }
        
        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }
        
        guard let city = self.workedCity else {
            fatalError("cant get city")
        }
        
        let tileAction = self.tileAction(of: tile, with: city, for: humanPlayer, in: gameModel)
        
        switch tileAction {
        
        case .none:
            // noop
        break
        case .purchasable:
            self.delegate?.purchaseTile(at: point)
        case .nonPurchasable:
            // noop
        break
        case .available:
            self.delegate?.forceWorking(on: point)
        case .worked:
            self.delegate?.forceWorking(on: point)
        case .forceWorked:
            self.delegate?.stopWorking(on: point)
        }
    }
}
