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

    case notAvailable
    case districtAvailable
    case wonderAvailable

    var textureName: String? {

        switch self {

        case .none: return nil

        case .purchasable: return "tile-purchase-active"
        case .nonPurchasable: return "tile-purchase-disabled"

        case .available: return "tile-citizen-normal"
        case .worked: return "tile-citizen-selected"
        case .forceWorked: return "tile-citizen-forced"

        case .notAvailable: return "tile-notAvailable"
        case .districtAvailable: return "tile-districtAvailable"
        case .wonderAvailable: return "tile-wonderAvailable"
        }
    }
}

protocol HexagonGridViewModelDelegate: AnyObject {

    func purchaseTile(at point: HexPoint)
    func forceWorking(on point: HexPoint)
    func stopWorking(on point: HexPoint)

    func selected(wonder: WonderType, on point: HexPoint)
    func selected(district: DistrictType, on point: HexPoint)
}

enum HexagonGridViewMode {

    case empty
    case citizen
    case districtLocation(type: DistrictType)
    case wonderLocation(type: WonderType)
}

extension HexagonGridViewMode: Equatable {

    public static func == (lhs: HexagonGridViewMode, rhs: HexagonGridViewMode) -> Bool {

        switch (lhs, rhs) {

        case (.empty, .empty):
            return true

        case (.citizen, .citizen):
            return true

        case (.districtLocation(let lhsDistrict), .districtLocation(let rhsDistrict)):
            return lhsDistrict == rhsDistrict

        case (.wonderLocation(let lhsWonder), .wonderLocation(let rhsWonder)):
            return lhsWonder == rhsWonder

        default:
            return false
        }
    }
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

    weak var delegate: HexagonGridViewModelDelegate?

    private var workedCity: AbstractCity?
    var mode: HexagonGridViewMode {
        didSet {
            if let city = self.workedCity {
                guard let gameModel = self.gameEnvironment.game.value else {
                    fatalError("cant get game")
                }

                self.update(for: city, with: gameModel)
            }
        }
    }

    // MARK: constructor

    init(mode: HexagonGridViewMode, gameModel: GameModel? = nil) {

        self.mode = mode

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
        self.showCitizenIcons = self.mode == .citizen

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
                var tileAction: String?
                var cost: Int?

                switch self.mode {

                case .empty:
                    // NOOP
                    break
                case .citizen:
                    tileAction = self.tileActionTextureName(of: tile, with: city, for: humanPlayer, in: gameModel)
                    cost = city.buyPlotCost(at: HexPoint(x: x, y: y), in: gameModel)
                case .districtLocation(type: let districtType):
                    if city.canBuild(district: districtType, at: tile.point, in: gameModel) {
                        tileAction = TileActionType.districtAvailable.textureName
                    }
                case .wonderLocation(type: let wonderType):
                    if city.canBuild(wonder: wonderType, at: tile.point, in: gameModel) {
                        tileAction = TileActionType.wonderAvailable.textureName
                    }
                }

                let hexagonViewModel = HexagonViewModel(
                    at: tile.point,
                    tileColor: color,
                    mountains: mountains,
                    hills: hills,
                    forest: forest,
                    city: cityTexture,
                    tileAction: tileAction,
                    cost: cost,
                    showCitizenIcons: self.showCitizenIcons
                )
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

                switch self.mode {

                case .empty:
                    // NOOP
                    break
                case .citizen:
                    let tileAction: String? = self.tileActionTextureName(of: tile, with: city, for: humanPlayer, in: gameModel)
                    model.update(tileAction: tileAction)
                case .districtLocation(type: _):
                    /*if city.canBuild(district: districtType, at: tile.point, in: gameModel) {
                        tileAction = TileActionType.districtAvailable.textureName
                    }*/
                    // NOOP
                    break
                case .wonderLocation(type: _):
                    /*if city.canBuild(wonder: wonderType, at: tile.point, in: gameModel) {
                        tileAction = TileActionType.wonderAvailable.textureName
                    }*/
                    // NOOP
                    break
                }
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

                guard let cost = city.buyPlotCost(at: tile.point, in: gameModel) else {
                    return .none
                }

                if Double(cost) <= treasury.value() {
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

        switch self.mode {

        case .empty:
            print("clicked on tile: \(point) empty")

        case .citizen:

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

            default:
                // noop
                break
            }

        case .wonderLocation(let wonderType):
            print("clicked on tile: \(point) for wonder: \(wonderType)")
            self.delegate?.selected(wonder: wonderType, on: point)

        case .districtLocation(let districtType):
            print("clicked on tile: \(point) for district: \(districtType)")
            self.delegate?.selected(district: districtType, on: point)
        }
    }
}
