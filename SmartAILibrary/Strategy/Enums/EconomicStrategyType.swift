//
//  EconomicStrategyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum EconomicReconState: Int, Codable {

    case none
    case enough
    case neutral
    case needed
}

enum EconomicStrategyType: Int, Codable {

    case needRecon
    case enoughRecon
    case needReconSea
    case enoughReconSea
    case earlyExpansion
    case enoughExpansion

    case losingMoney
    case tooManyUnits

    case expandToOtherContinents
    case foundCity

    static var all: [EconomicStrategyType] {
        return [
                .needRecon, .enoughRecon,
                .needReconSea, .enoughReconSea,
                .earlyExpansion, .enoughExpansion,

                .losingMoney, .tooManyUnits,
                .expandToOtherContinents, .foundCity
        ]
    }

    func weightThreshold() -> Int {

        switch self {
        case .needRecon: return 0
        case .enoughRecon: return 0
        case .needReconSea: return 0
        case .enoughReconSea: return 0
        case .earlyExpansion: return 3
        case .enoughExpansion: return 2
        case .losingMoney: return 2
        case .tooManyUnits: return 0
        case .expandToOtherContinents: return 50
        case .foundCity: return 10
        }
    }

    func flavorThresholdModifiers() -> [Flavor] {

        return []
    }

    func flavorThresholdModifier(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavorThresholdModifiers().first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return 0
    }

    func flavorModifiers() -> [Flavor] {

        switch self {

        case .needRecon: return [
                Flavor(type: .recon, value: 100)
            ]
        case .enoughRecon: return [
                Flavor(type: .recon, value: -25)
            ]
        case .needReconSea: return [
                Flavor(type: .navalRecon, value: 30)
            ]
        case .enoughReconSea: return [
                Flavor(type: .navalRecon, value: -20)
            ]
        case .earlyExpansion: return [
                Flavor(type: .mobile, value: -2),
                Flavor(type: .navalGrowth, value: -5),
                Flavor(type: .expansion, value: 30),
                Flavor(type: .production, value: -4),
                Flavor(type: .gold, value: -4),
                Flavor(type: .science, value: -4),
                Flavor(type: .culture, value: -4)
            ]
        case .enoughExpansion: return [
                Flavor(type: .expansion, value: -30)
            ]
        case .losingMoney: return [
                Flavor(type: .gold, value: 20),
                Flavor(type: .offense, value: -10),
                Flavor(type: .defense, value: -10)
            ]
        case .tooManyUnits: return [
                Flavor(type: .offense, value: -30),
                Flavor(type: .defense, value: -30),
                Flavor(type: .gold, value: 15),
                Flavor(type: .growth, value: 5),
                Flavor(type: .science, value: 15),
                Flavor(type: .culture, value: 10),
                Flavor(type: .happiness, value: 10),
                Flavor(type: .wonder, value: 5)
            ]
        case .expandToOtherContinents: return [
                Flavor(type: .naval, value: 50),
                Flavor(type: .navalTileImprovement, value: 10),
                Flavor(type: .navalGrowth, value: 5),
                //Flavor(type: .waterConnection, value: 5), FIXME
                Flavor(type: .expansion, value: 10),
                Flavor(type: .recon, value: -20)
            ]
        case .foundCity: return [
                // NOOP
            ]
        }
    }

    func required() -> TechType? {

        switch self {

        case .needRecon: return nil
        case .enoughRecon: return nil
        case .needReconSea: return nil
        case .enoughReconSea: return nil
        case .earlyExpansion: return nil
        case .enoughExpansion: return nil

        case .losingMoney: return nil
        case .tooManyUnits: return nil

        case .expandToOtherContinents: return nil
        case .foundCity: return nil
        }
    }

    func obsolete() -> TechType? {

        switch self {

        case .needRecon: return nil
        case .enoughRecon: return nil
        case .needReconSea: return nil
        case .enoughReconSea: return nil
        case .earlyExpansion: return nil
        case .enoughExpansion: return nil

        case .losingMoney: return nil
        case .tooManyUnits: return nil

        case .expandToOtherContinents: return nil
        case .foundCity: return nil
        }
    }

    func notBeforeTurnElapsed() -> Int {

        switch self {

        case .needRecon: return 5
        case .enoughRecon: return 5
        case .needReconSea: return 5
        case .enoughReconSea: return 5
        case .earlyExpansion: return 0
        case .enoughExpansion: return 0

        case .losingMoney: return 20
        case .tooManyUnits: return 20

        case .expandToOtherContinents: return 50
        case .foundCity: return 0
        }
    }

    func checkEachTurns() -> Int {

        switch self {

        case .needRecon: return 1
        case .enoughRecon: return 1
        case .needReconSea: return 1
        case .enoughReconSea: return 1
        case .earlyExpansion: return 5
        case .enoughExpansion: return 1

        case .losingMoney: return 5
        case .tooManyUnits: return 1

        case .expandToOtherContinents: return 10
        case .foundCity: return 1
        }
    }

    func minimumAdoptionTurns() -> Int {

        switch self {

        case .needRecon: return 1
        case .enoughRecon: return 1
        case .needReconSea: return 1
        case .enoughReconSea: return 1
        case .earlyExpansion: return 10
        case .enoughExpansion: return 1

        case .losingMoney: return 5
        case .tooManyUnits: return 1

        case .expandToOtherContinents: return 25
        case .foundCity: return 1
        }
    }

    private func weightThresholdModifier(for player: AbstractPlayer) -> Int {

        var value = 0

        for flavor in FlavorType.all {

            value += player.valueOfPersonalityFlavor(of: flavor) * self.flavorThresholdModifier(for: flavor)
        }

        return value
    }

    func shouldBeActive(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        switch self {

        case .needRecon: return self.shouldBeActiveNeedRecon(for: player, in: gameModel)
        case .enoughRecon: return self.shouldBeActiveEnoughRecon(for: player, in: gameModel)
        case .needReconSea: return self.shouldBeActiveNeedReconSea(for: player, in: gameModel)
        case .enoughReconSea: return self.shouldBeActiveEnoughReconSea(for: player, in: gameModel)
        case .earlyExpansion: return self.shouldBeActiveEarlyExpansion(for: player, in: gameModel)
        case .enoughExpansion: return false // FIXME

        case .losingMoney: return false // FIXME
        case .tooManyUnits: return false // FIXME

        case .expandToOtherContinents: return false // FIXME
        case .foundCity: return self.shouldBeActiveFoundCity(for: player, in: gameModel)
        }
    }

    private func shouldBeActiveNeedRecon(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let militaryStrategyAdoption = player?.militaryAI?.militaryStrategyAdoption else {
            fatalError("Cant get military strategry")
        }

        // Never desperate for explorers if we are at war
        if militaryStrategyAdoption.adopted(militaryStrategy: .atWar) {
            return false
        }

        return player?.economicAI?.reconState() == .needed
    }

    private func shouldBeActiveEnoughRecon(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        return player?.economicAI?.reconState() == .enough
    }

    private func shouldBeActiveNeedReconSea(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let militaryStrategyAdoption = player?.militaryAI?.militaryStrategyAdoption else {
            fatalError("Cant get military strategry")
        }

        // Never desperate for explorers if we are at war
        if militaryStrategyAdoption.adopted(militaryStrategy: .losingWars) {
            return false
        }

        return player?.economicAI?.navalReconState() == .needed
    }

    private func shouldBeActiveEnoughReconSea(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        return player?.economicAI?.navalReconState() == .enough
    }

    // "Early Expansion" Player Strategy: An early Strategy simply designed to get player up to 3 Cities quickly.
    private func shouldBeActiveEarlyExpansion(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let economicAI = player.economicAI else {
            fatalError("cant get economicAI")
        }

        let flavorExpansion = player.valueOfStrategyAndPersonalityFlavor(of: .expansion)
        let flavorGrowth = player.valueOfStrategyAndPersonalityFlavor(of: .growth)
        let maxCultureCities = 6 // AI_GS_CULTURE_MAX_CITIES

        var desiredCities = (3 * flavorExpansion) / max(flavorGrowth, 1)
        let difficulty = 0 // FIXME max(0,GC.getGame().getHandicapInfo().GetID() - 3)
        desiredCities += difficulty

        if player.grandStrategyAI?.activeStrategy == .culture {
            desiredCities = min(desiredCities, maxCultureCities)
        }

        desiredCities = max(desiredCities, maxCultureCities)

        // scale this based on world size
        let standardMapSize: MapSize = .standard
        desiredCities = desiredCities * gameModel.mapSize().numberOfTiles() / standardMapSize.numberOfTiles()

        // See how many unowned Tiles there are on this player's landmass
        if let capital = gameModel.capital(of: player) {

            // Make sure city specialization has gotten one chance to specialize the capital before we adopt this
            if gameModel.currentTurn > 25 { // AI_CITY_SPECIALIZATION_EARLIEST_TURN

                if let capitalArea = gameModel.area(of: capital.location) {

                    // Is this area still the best to settle?
                    let (_, bestArea, _) = player.bestSettleAreasWith(minimumSettleFertility: economicAI.minimumSettleFertility(), in: gameModel)

                    if bestArea == capitalArea {

                        let tilesInCapitalArea = gameModel.tiles(in: capitalArea)
                        let numOwnedTiles = tilesInCapitalArea.filter({ $0?.hasOwner() ?? false }).count
                        let numUnownedTiles = tilesInCapitalArea.filter({ !($0?.hasOwner() ?? true) }).count
                        let numTiles = max(1, numOwnedTiles + numUnownedTiles)
                        let ownageRatio = numOwnedTiles * 100 / numTiles
                        let numCities = gameModel.cities(of: player).count

                        let numSettlersOnMap = gameModel.units(of: player).count(where: { $0!.task() == .settle })

                        if ownageRatio < 75 /* AI_STRATEGY_AREA_IS_FULL_PERCENT */

                            && (numCities + numSettlersOnMap) < desiredCities
                            && numUnownedTiles >= 25 /* AI_STRATEGY_EARLY_EXPANSION_NUM_UNOWNED_TILES_REQUIRED */ {

                            return true
                        }
                    }
                }
            }
        }

        return false
    }

    /// "Found City" Player Strategy: If there is a settler who isn't in an operation?  If so, find him a city site
    /// Very dependent on the fact that the player probably won't have more than 2 settlers available at a time; needs an
    ///   upgrade if that assumption is no longer true
    func shouldBeActiveFoundCity(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let economicAI = player.economicAI else {
            fatalError("cant get economicAI")
        }

        // Never run this strategy for a human player
        if player.isHuman() {
            return false
        }

        var firstLooseSettler: AbstractUnit?
        var looseSettlers = 0

        for unitRef in gameModel.units(of: player) {

            if let unit = unitRef {
                if unit.has(task: .settle) {
                    if unit.army() == nil {

                        looseSettlers += 1
                        if looseSettlers == 1 {
                            firstLooseSettler = unitRef
                        }
                    }
                }
            }
        }

        let strategyWeight = looseSettlers * 10 // Just one settler will trigger this
        let weightThresholdModifier = self.weightThresholdModifier(for: player)
        let weightThreshold = self.weightThreshold() + weightThresholdModifier

        // Don't run this strategy if have 0 cities, in that case we just want to drop down a city wherever we happen to be
        if strategyWeight >= weightThreshold && gameModel.cities(of: player).count >= 1 {

            let (numAreas, bestArea, _) = player.bestSettleAreasWith(minimumSettleFertility: economicAI.minimumSettleFertility(), in: gameModel)

            if numAreas == 0 {
                return false
            }

            guard let bestSettlePlot = player.bestSettlePlot(for: firstLooseSettler, in: gameModel, escorted: true, area: nil) else {
                return false
            }

            let area = bestSettlePlot.area

            let canEmbark = player.canEmbark()
            let isAtWarWithSomeone = player.atWarCount() > 0

            // CASE 1: Need a city on this area
            if bestArea == area {
                player.addOperation(of: .foundCity, towards: nil, target: nil, in: bestArea, muster: nil, in: gameModel)
                return true
            } else if canEmbark && self.isSafeForQuickColony(in: area, in: gameModel, for: player) {
                // CASE 2: Need a city on a safe distant area
                // Have an overseas we can get to safely
                player.addOperation(of: .colonize, towards: nil, target: nil, in: bestArea, muster: nil, in: gameModel)
                return true
            }

            // CASE 3: My embarked units can fight, I always do quick colonization overseas
            /*else if canEmbark && pPlayer->GetPlayerTraits()->IsEmbarkedNotCivilian() {
                player.addOperation(of: .notSoQuickColonize, towards: nil, target: nil, area: iArea)
                return true
            }*/
            else if (canEmbark && !isAtWarWithSomeone) {
                // CASE 3a: Need a city on a not so safe distant area
                // not at war with anyone
                player.addOperation(of: .notSoQuickColonize, towards: nil, target: nil, in: area, muster: nil, in: gameModel)
                return true

            } else if canEmbark {
                // CASE 4: Need a city on distant area
                player.addOperation(of: .colonize, towards: nil, target: nil, in: area, muster: nil, in: gameModel)
                return true
            }
        }

        return false
    }

    /// Do we have an island clear of hostile units to settle on?
    func isSafeForQuickColony(in area: HexArea?, in gameModel: GameModel?, for player: AbstractPlayer?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if let boundingBox = area?.boundingBox {

            for x in boundingBox.minX..<boundingBox.maxX {
                for y in boundingBox.minY..<boundingBox.maxY {

                    if gameModel.isEnemyVisible(at: HexPoint(x: x, y: y), for: player) {
                        return false
                    }
                }
            }
        }

        return true
    }

    func advisorMessage() -> AdvisorMessage? {

        switch self {

        case .needRecon: return AdvisorMessage(advisor: .foreign, message: "TXT_KEY_ECONOMICAISTRATEGY_NEED_RECON", importance: 2)
        case .enoughRecon: return AdvisorMessage(advisor: .economic, message: "TXT_KEY_ECONOMICAISTRATEGY_ENOUGH_RECON", importance: 2)
        case .needReconSea: return AdvisorMessage(advisor: .foreign, message: "TXT_KEY_ECONOMICAISTRATEGY_NEED_RECON_SEA", importance: 2)
        case .enoughReconSea: return AdvisorMessage(advisor: .economic, message: "TXT_KEY_ECONOMICAISTRATEGY_ENOUGH_RECON", importance: 2)
        case .earlyExpansion: return AdvisorMessage(advisor: .economic, message: "TXT_KEY_ECONOMICAISTRATEGY_EARLY_EXPANSION", importance: 2)
        case .enoughExpansion: return AdvisorMessage(advisor: .economic, message: "TXT_KEY_ECONOMICAISTRATEGY_ENOUGH_EXPANSION", importance: 2)

        case .losingMoney: return AdvisorMessage(advisor: .economic, message: "TXT_KEY_ECONOMICAISTRATEGY_LOSING_MONEY", importance: 2)
        case .tooManyUnits: return AdvisorMessage(advisor: .economic, message: "TXT_KEY_ECONOMICAISTRATEGY_TOO_MANY_UNITS", importance: 2)

        case .expandToOtherContinents: return nil
        case .foundCity: return AdvisorMessage(advisor: .economic, message: "TXT_KEY_ECONOMICAISTRATEGY_FOUND_CITY", importance: 2)
        }
    }
}
