//
//  MilitaryAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class MilitaryAI {

    var player: Player?
    let militaryStrategyAdoption: MilitaryStrategyAdoption
    var flavors: Flavors

    private var baseData: MilitaryBaseData
    private var barbarianDataVal: BarbarianData
    private var landDefenseStateVal: DefenseStateType
    private var navalDefenseStateVal: DefenseStateType
    private var totalThreatWeight: Int = 0

    // MARK: internal classes

    class MilitaryBaseData {

        var numLandUnits: Int = 0
        var numRangedLandUnits: Int = 0
        var numMobileLandUnits: Int = 0
        //var numAirUnits: Int = 0
        //var numAntiAirUnits: Int = 0
        var numMeleeLandUnits: Int = 0
        var numNavalUnits: Int = 0
        //var numLandUnitsInArmies = 0
        //var numNavalUnitsInArmies = 0
        var recommendedMilitarySize: Int = 0
        var mandatoryReserveSize: Int = 0

        init() {

        }

        func reset() {

            self.numLandUnits = 0
            self.numRangedLandUnits = 0
            self.numMobileLandUnits = 0
            self.numMeleeLandUnits = 0
            self.numNavalUnits = 0
            self.recommendedMilitarySize = 0
            self.mandatoryReserveSize = 0
        }
    }

    class BarbarianData {

        var barbarianCampCount = 0
        var visibleBarbarianCount = 0

        init() {

        }

        func reset() {

            self.barbarianCampCount = 0
            self.visibleBarbarianCount = 0
        }
    }

    class MilitaryStrategyAdoptionItem {

        let militaryStrategy: MilitaryStrategyType
        var adopted: Bool
        var turnOfAdoption: Int

        init(militaryStrategy: MilitaryStrategyType, adopted: Bool, turnOfAdoption: Int) {

            self.militaryStrategy = militaryStrategy
            self.adopted = adopted
            self.turnOfAdoption = turnOfAdoption
        }
    }

    class MilitaryStrategyAdoption {

        var adoptions: [MilitaryStrategyAdoptionItem]

        init() {

            self.adoptions = []

            for militaryStrategyType in MilitaryStrategyType.all {

                adoptions.append(MilitaryStrategyAdoptionItem(militaryStrategy: militaryStrategyType, adopted: false, turnOfAdoption: -1))
            }
        }

        func adopted(militaryStrategy: MilitaryStrategyType) -> Bool {

            if let item = self.adoptions.first(where: { $0.militaryStrategy == militaryStrategy }) {

                return item.adopted
            }

            return false
        }

        func turnOfAdoption(of militaryStrategy: MilitaryStrategyType) -> Int {

            if let item = self.adoptions.first(where: { $0.militaryStrategy == militaryStrategy }) {

                return item.turnOfAdoption
            }

            fatalError("cant get turn of adoption - not set")
        }

        func adopt(militaryStrategy: MilitaryStrategyType, turnOfAdoption: Int) {

            if let item = self.adoptions.first(where: { $0.militaryStrategy == militaryStrategy }) {

                item.adopted = true
                item.turnOfAdoption = turnOfAdoption
            }
        }

        func abandon(militaryStrategy: MilitaryStrategyType) {

            if let item = self.adoptions.first(where: { $0.militaryStrategy == militaryStrategy }) {

                item.adopted = false
                item.turnOfAdoption = -1
            }
        }
    }

    // MARK: constructors

    init(player: Player?) {

        self.player = player
        self.militaryStrategyAdoption = MilitaryStrategyAdoption()
        self.flavors = Flavors()

        self.baseData = MilitaryBaseData()
        self.barbarianDataVal = BarbarianData()
        self.landDefenseStateVal = .none
        self.navalDefenseStateVal = .none
    }

    func updateMilitaryStrategies(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        for militaryStrategyType in MilitaryStrategyType.all {

            // Minor Civs can't run some Strategies
            // FIXME

            // check tech
            let requiredTech = militaryStrategyType.required()
            let isTechGiven = requiredTech == nil ? true : player.has(tech: requiredTech!)
            let obsoleteTech = militaryStrategyType.obsolete()
            let isTechObsolete = obsoleteTech == nil ? false : player.has(tech: obsoleteTech!)

            // Do we already have this EconomicStrategy adopted?
            var shouldCityStrategyStart = true
            if self.militaryStrategyAdoption.adopted(militaryStrategy: militaryStrategyType) {

                shouldCityStrategyStart = false

            } else if !isTechGiven {

                shouldCityStrategyStart = false

            } else if gameModel.turnsElapsed < militaryStrategyType.notBeforeTurnElapsed() { // Not time to check this yet?

                shouldCityStrategyStart = false
            }

            var shouldCityStrategyEnd = false
            if self.militaryStrategyAdoption.adopted(militaryStrategy: militaryStrategyType) {

                if militaryStrategyType.checkEachTurns() > 0 {

                    // Is it a turn where we want to check to see if this Strategy is maintained?
                    if gameModel.turnsElapsed - self.militaryStrategyAdoption.turnOfAdoption(of: militaryStrategyType) % militaryStrategyType.checkEachTurns() == 0 {
                        shouldCityStrategyEnd = true
                    }
                }

                if shouldCityStrategyEnd && militaryStrategyType.minimumAdoptionTurns() > 0 {

                    // Has the minimum # of turns passed for this Strategy?
                    if gameModel.turnsElapsed < self.militaryStrategyAdoption.turnOfAdoption(of: militaryStrategyType) + militaryStrategyType.minimumAdoptionTurns() {
                        shouldCityStrategyEnd = false
                    }
                }
            }

            // Check EconomicStrategy Triggers
            // Functionality and existence of specific CityStrategies is hardcoded here, but data is stored in XML so it's easier to modify
            if shouldCityStrategyStart || shouldCityStrategyEnd {

                // Has the Tech which obsoletes this Strategy? If so, Strategy should be deactivated regardless of other factors
                var strategyShouldBeActive = false

                // Strategy isn't obsolete, so test triggers as normal
                if !isTechObsolete {
                    strategyShouldBeActive = militaryStrategyType.shouldBeActive(for: self.player, in: gameModel)
                }

                // This variable keeps track of whether or not we should be doing something (i.e. Strategy is active now but should be turned off, OR Strategy is inactive and should be enabled)
                var bAdoptOrEndStrategy = false

                // Strategy should be on, and if it's not, turn it on
                if strategyShouldBeActive {
                    if shouldCityStrategyStart {

                        bAdoptOrEndStrategy = true
                    } else if shouldCityStrategyEnd {

                        bAdoptOrEndStrategy = false
                    }
                }
                // Strategy should be off, and if it's not, turn it off
                    else {
                        if shouldCityStrategyStart {

                            bAdoptOrEndStrategy = false
                        } else if shouldCityStrategyEnd {

                            bAdoptOrEndStrategy = true
                        }
                }

                if bAdoptOrEndStrategy {

                    if shouldCityStrategyStart {

                        self.militaryStrategyAdoption.adopt(militaryStrategy: militaryStrategyType, turnOfAdoption: gameModel.turnsElapsed)
                    } else if shouldCityStrategyEnd {

                        self.militaryStrategyAdoption.abandon(militaryStrategy: militaryStrategyType)
                    }
                }
            }
        }

        self.updateFlavors()

        //print("military strategy flavors")
        //print(self.flavors)
    }

    func turn(in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("no player given")
        }

        self.updateBaseData(in: gameModel)
        self.updateBarbarianData(in: gameModel)
        self.updateDefenseState(in: gameModel)
        self.updateMilitaryStrategies(in: gameModel)
        self.updateThreats(in: gameModel)

        if player.isHuman() {

            self.updateOperations(in: gameModel)
            //self.makeEmergencyPurchases()
            //self.requestImprovements()
            //self.disbandObsoleteUnits()
        }
    }

    func updateThreats(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("no diplomacyAI given")
        }

        self.totalThreatWeight = 0

        for otherPlayer in gameModel.players {

            // Is this a player we have relations with?
            if player.leader != otherPlayer.leader && player.hasMet(with: otherPlayer) {

                let threat = diplomacyAI.militaryThreat(of: otherPlayer)
                self.totalThreatWeight += threat.weight()
            }
        }
    }

    func barbarianThreatTotal() -> Int {

        return 20 // FIXME
    }

    func updateOperations(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("no diplomacyAI given")
        }

        // SEE IF THERE ARE OPERATIONS THAT NEED TO BE ABORTED

        // Are we willing to risk pressing forward vs. barbarians?
        var willingToAcceptRisk = (self.totalThreatWeight / 2) < self.barbarianThreatTotal()
        if player.leader.ability() == .convertLandBarbarians {
            willingToAcceptRisk = true
        }

        //
        // Operations vs. Barbarians
        //
        // If have aborted the eradicate barbarian strategy or if the threat level from civs is significantly higher than from barbs, we better abort all of them
        if self.adopted(militaryStrategy: .eradicateBarbarians) || self.adopted(militaryStrategy: .atWar) || !willingToAcceptRisk {

            for operation in player.operationsOf(type: .destroyBarbarianCamp) {
                operation.cancel()
            }
        }

        //
        // Operation vs. Other Civs
        //
        // Are our wars over?
        if !self.adopted(militaryStrategy: .atWar) {

            for operation in player.operationsOf(type: .basicCityAttack) {
                operation.cancel()
            }

            for operation in player.operationsOf(type: .pillageEnemy) {
                operation.cancel()
            }

            for operation in player.operationsOf(type: .rapidResponse) {
                operation.cancel()
            }

            for operation in player.operationsOf(type: .cityCloseDefense) {
                operation.cancel()
            }

            for operation in player.operationsOf(type: .navalAttack) {
                operation.cancel()
            }
        }

        // or are we at war?
        if self.adopted(militaryStrategy: .atWar) {

            for otherPlayer in gameModel.players {

                // Is this a player we have relations with?
                if player.leader != otherPlayer.leader && player.hasMet(with: otherPlayer) {

                    // If we've made peace with this player, abort all operations related to him
                    if player.isForcePeace(with: otherPlayer) {

                        for operation in player.operationsOf(type: .sneackAttack) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.cancel()
                            }
                        }

                        for operation in player.operationsOf(type: .basicAttack) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.cancel()
                            }
                        }

                        for operation in player.operationsOf(type: .showOfForce) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.cancel()
                            }
                        }
                    }

                    let warState = diplomacyAI.warState(towards: otherPlayer)
                    switch warState {

                    case .nearlyDefeated: // If nearly defeated, call off all operations in enemy territory
                        for operation in player.operationsOf(type: .basicCityAttack) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.cancel()
                            }
                        }

                        for operation in player.operationsOf(type: .pillageEnemy) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.cancel()
                            }
                        }

                        for operation in player.operationsOf(type: .navalAttack) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.cancel()
                            }
                        }
                    case .defensive: // If we are losing, make sure attacks are not running
                        for operation in player.operationsOf(type: .basicCityAttack) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.cancel()
                            }
                        }

                        for operation in player.operationsOf(type: .pillageEnemy) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.cancel()
                            }
                        }

                        for operation in player.operationsOf(type: .navalAttack) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.cancel()
                            }
                        }

                    case .offensive, .nearlyWon: // If we are dominant, shouldn't be running a defensive strategy
                        for operation in player.operationsOf(type: .rapidResponse) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.cancel()
                            }
                        }

                        for operation in player.operationsOf(type: .cityCloseDefense) {
                            if operation.enemy!.leader == otherPlayer.leader {
                                operation.cancel()
                            }
                        }

                    case .stalemate, .calm, .none:
                        // NOOP
                        break
                    }
                }
            }
            
            // Are there city defense operations for cities that no longer need defending?
            for cityRef in gameModel.cities(of: player) {
                
                if let city = cityRef {
                    
                    if city.threatValue() == 0 {
                        
                        for operation in player.operationsOf(type: .cityCloseDefense) {
                            
                            if operation.targetPosition == city.location {
                                operation.cancel()
                            }
                        }
                    }
                }
            }
            
            // Are we running a rapid response tactic and the overall threat level is very low?
            if totalThreatWeight <= 3 {
                
                for operation in player.operationsOf(type: .rapidResponse) {
                    operation.cancel()
                }
            }
        }
        
        // SEE WHAT OPERATIONS WE SHOULD ADD
        //
        // Operation vs. Barbarians
        //
        // If running the eradicate barbarian strategy, the threat is low (no higher than 1 major threat), we're not at war, /*and we have enough units*/, then launch a new operation.
        // Which one is based on whether or not we saw any barbarian camps
        if self.adopted(militaryStrategy: .eradicateBarbarians) && !self.adopted(militaryStrategy: .atWar) && !self.adopted(militaryStrategy: .empireDefenseCritical) && player.operationsOf(type: .destroyBarbarianCamp).count == 0 && willingToAcceptRisk {
            
            // We should have AI build for this
            player.addOperation(of: .destroyBarbarianCamp, towards: gameModel.barbarianPlayer(), target: nil, in: nil, in: gameModel)
        }
        
        //
        // Operation vs. Other Civs
        //
        // If at war, consider launching an operation
        if self.adopted(militaryStrategy: .atWar) {
            
            for otherPlayer in gameModel.players {

                // Is this a player we have relations with?
                if player.leader != otherPlayer.leader && player.hasMet(with: otherPlayer) {
                
                    let warState = diplomacyAI.warState(towards: otherPlayer)
                    
                    // always consider nuking them
                    // FIXME
                    
                    switch warState {
                    
                    case .none:
                        // NOOP
                        break
                        
                    case .nearlyDefeated, .defensive:
                        // NOOP
                        /*if let threatenedCity = self.mostThreatenedCity(in: gameModel) {
                            
                        }*/
                        break
                        
                    case .stalemate: // If roughly equal in number, let's try to annoy him with raids

                        let units = gameModel.units(of: player)
                        let (numRequiredSlots, _, filledSlots) = UnitFormationHelper.numberOfFillableSlots(of: units, for: .fastPillagers)
                        
                        // Not willing to build units to get this off the ground
                        if filledSlots >= numRequiredSlots /* && landReservesUsed <= self.andReservesAvailable() */ {
                            self.requestPillageEnemy(towards: otherPlayer)
                        }
                        
                    case .calm:
                        var requestAttack = false
                        let militaryStrength = diplomacyAI.militaryStrength(of: otherPlayer)
                        let targetValue = diplomacyAI.targetValue(of: otherPlayer)
                        
                        if militaryStrength <= .average && targetValue > .impossible {
                            requestAttack = true
                        }
                        
                        if requestAttack {
                            self.requestBasicAttack(towards: otherPlayer)
                        } else {
                            let units = gameModel.units(of: player)
                            let (numRequiredSlots, _, filledSlots) = UnitFormationHelper.numberOfFillableSlots(of: units, for: .fastPillagers)
                            
                            // Not willing to build units to get this off the ground
                            if filledSlots >= numRequiredSlots /* && landReservesUsed <= self.andReservesAvailable() */ {
                                self.requestPillageEnemy(towards: otherPlayer)
                            }   
                        }
                        
                    case .offensive, .nearlyWon: // If we are dominant, time to take down one of his cities
                        self.requestBasicAttack(towards: otherPlayer)
                    }
                }
            }
        }
        
        //
        // Naval operations (vs. opportunity targets)
        //
        let units = gameModel.units(of: player)
        let (numRequiredSlots, _, filledSlots) = UnitFormationHelper.numberOfFillableSlots(of: units, for: .navalSquadron)
        
        // Not willing to build units to get this off the ground
        if filledSlots >= numRequiredSlots  {
            
            // Total number of these operations can't exceed (FLAVOR_NAVAL / 2)
            let flavorNaval = player.valueOfPersonalityFlavor(of: .naval)
            let numSuperiority = player.numberOfOperationsOf(type: .navalSuperiority)
            let numBombard = player.numberOfOperationsOf(type: .navalBombard)
            
            if (numSuperiority + numBombard) <= (flavorNaval / 2) {
                
                if player.hasOperationsOf(type: .colonize) {
                    // If I have a colonization operation underway, start up naval superiority as extra escorts
                    player.addOperation(of: .navalSuperiority, towards: nil, target: nil, in: nil, in: gameModel)
                } else if self.adopted(militaryStrategy: .eradicateBarbarians) {
                    // If fighting off barbarians, start naval bombardment
                    player.addOperation(of: .navalBombard, towards: nil, target: nil, in: nil, in: gameModel)
                } else if numSuperiority > numBombard {
                    // Otherwise choose based on which operation we have more of
                    player.addOperation(of: .navalBombard, towards: nil, target: nil, in: nil, in: gameModel)
                } else {
                    player.addOperation(of: .navalSuperiority, towards: nil, target: nil, in: nil, in: gameModel)
                }
            }
        }
    }
    
    /// Send an army to take a city
    func requestBasicAttack(towards otherPlayer: AbstractPlayer?, numUnitsWillingBuild: Int = 1) {
        
        fatalError("requestBasicAttack not implemented")
    }
    
    /// Send an army to force concessions
    func requestPillageEnemy(towards otherPlayer: AbstractPlayer?) {
        
        fatalError("requestPillageEnemy not implemented")
    }

    func landDefenseState() -> DefenseStateType {

        return self.landDefenseStateVal
    }

    func navalDefenseState() -> DefenseStateType {

        return self.navalDefenseStateVal
    }

    func barbarianData() -> BarbarianData {

        return self.barbarianDataVal
    }

    func updateBaseData(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        self.baseData.reset()

        for unitRef in gameModel.units(of: player) {

            guard let unit = unitRef else {
                fatalError("cant get unit")
            }

            // Don't count exploration units
            if unit.has(task: .explore) || unit.has(task: .exploreSea) {
                continue
            }

            // Don't count civilians
            if !unit.has(task: .attack) {
                continue
            }

            switch unit.domain() {

            case .none:
                // NOOP
                break
                
            case .land:
                self.baseData.numLandUnits += 1

                if unit.has(task: .ranged) {
                    self.baseData.numRangedLandUnits += 1
                }

                if unit.moves() > 2 {
                    self.baseData.numMobileLandUnits += 1
                }

            case .sea:
                self.baseData.numNavalUnits += 1

            case .air, .immobile:
                // NOOP
                break
            }
        }

        let flavorOffense: Double = Double(player.valueOfStrategyAndPersonalityFlavor(of: .offense))
        let flavorDefense: Double = Double(player.valueOfStrategyAndPersonalityFlavor(of: .defense))

        // Scale up or down based on true threat level and a bit by flavors (multiplier should range from about 0.5 to about 1.5)
        let multiplier = (0.40 + Double(self.highestThreat(in: gameModel).rawValue) + flavorOffense + flavorDefense) / 100.0

        // first get the number of defenders that we think we need

        // Start with 3, to protect the capital
        var iNumUnitsWanted = 3.0

        // 1 Unit per City & 1 per Settler
        iNumUnitsWanted += Double(gameModel.cities(of: player).count) * 1.0
        iNumUnitsWanted += Double(gameModel.units(of: player).count(where: { $0!.has(task: .settle) })) * 1.0

        self.baseData.mandatoryReserveSize = Int(Double(iNumUnitsWanted) * multiplier)

        // add in a few for the difficulty level (all above Chieftain are boosted)
        //int iDifficulty = max(0,GC.getGame().getHandicapInfo().GetID() - 1);
        //m_iMandatoryReserveSize += (iDifficulty * 3 / 2);

        self.baseData.mandatoryReserveSize = max(1, self.baseData.mandatoryReserveSize)

        // now we add in the strike forces we think we will need
        iNumUnitsWanted = 7 // size of a basic attack

        // if we are going for conquest we want at least one more task force
        if player.grandStrategyAI?.activeStrategy == .conquest {
            iNumUnitsWanted *= 2
        }

        // add in a few more if the player is bold
        iNumUnitsWanted += Double(player.leader.trait(for: .boldness))

        // add in more if we are playing on a high difficulty
        //iNumUnitsWanted += iDifficulty * 3

        iNumUnitsWanted = iNumUnitsWanted * multiplier

        iNumUnitsWanted = max(1, iNumUnitsWanted)

        self.baseData.recommendedMilitarySize = self.baseData.mandatoryReserveSize + Int(iNumUnitsWanted)
    }

    func updateBarbarianData(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        self.barbarianDataVal.reset()

        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {

            for y in 0..<mapSize.height() {

                let pt = HexPoint(x: x, y: y)

                if let tile = gameModel.tile(at: pt) {

                    if tile.isDiscovered(by: self.player) {

                        if tile.has(improvement: .barbarianCamp) {
                            self.barbarianDataVal.barbarianCampCount += 1

                            // Count it as 5 camps if sitting inside our territory, that is annoying!
                            if tile.owner()?.leader == self.player?.leader {
                                self.barbarianDataVal.barbarianCampCount += 4
                            }
                        }
                    }

                    if tile.isVisible(to: self.player) {
                        if let unit = gameModel.unit(at: pt) {
                            if unit.isOf(unitType: .barbarianWarrior) {
                                self.barbarianDataVal.visibleBarbarianCount += 1
                            }
                        }
                    }
                }
            }
        }
    }

    func updateDefenseState(in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("no player given")
        }

        guard let economicAI = player.economicAI else {
            fatalError("no economicAI given")
        }

        // Derive data we'll need
        let iLandUnitsNotInArmies = self.baseData.numLandUnits/* - m_iNumLandUnitsInArmies*/
        let iNavalUnitsNotInArmies = self.baseData.numNavalUnits/* - m_iNumNavalUnitsInArmies*/

        if iLandUnitsNotInArmies < self.baseData.mandatoryReserveSize {
            self.landDefenseStateVal = .critical
        } else if iLandUnitsNotInArmies < self.baseData.recommendedMilitarySize {
            self.landDefenseStateVal = .needed
        } else if iLandUnitsNotInArmies < self.baseData.recommendedMilitarySize * 5 / 4 {
            self.landDefenseStateVal = .neutral
        } else {
            self.landDefenseStateVal = .enough
        }

        let iNavySize = 4 // FIXME: MilitaryAIHelpers::ComputeRecommendedNavySize(m_pPlayer)

        if economicAI.adopted(economicStrategy: .expandToOtherContinents) {

            if iNavalUnitsNotInArmies <= (iNavySize / 2) {
                self.navalDefenseStateVal = .critical
            } else if iNavalUnitsNotInArmies <= iNavySize {
                self.navalDefenseStateVal = .needed
            } else if iNavalUnitsNotInArmies <= iNavySize * 5 / 4 {
                self.navalDefenseStateVal = .neutral
            } else {
                self.navalDefenseStateVal = .enough
            }
        } else {

            if iNavalUnitsNotInArmies <= (iNavySize / 3) {
                self.navalDefenseStateVal = .critical
            } else if iNavalUnitsNotInArmies <= (iNavySize * 2 / 3) {
                self.navalDefenseStateVal = .needed
            } else if iNavalUnitsNotInArmies <= iNavySize {
                self.navalDefenseStateVal = .neutral
            } else {
                self.navalDefenseStateVal = .enough
            }
        }
    }

    // See if the threats we are facing have changed
    func highestThreat(in gameModel: GameModel?) -> MilitaryThreatType {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        var highestThreatByPlayer: MilitaryThreatType = .none

        for otherPlayer in gameModel.players {

            if otherPlayer.leader != player.leader {

                if !player.hasMet(with: otherPlayer) {
                    continue
                }

                if let threat = player.diplomacyAI?.militaryThreat(of: otherPlayer) {

                    if highestThreatByPlayer < threat {
                        highestThreatByPlayer = threat
                    }
                }
            }
        }

        return highestThreatByPlayer
    }

    func updateFlavors() {

        self.flavors.reset()

        for militaryStrategyType in MilitaryStrategyType.all {

            if self.militaryStrategyAdoption.adopted(militaryStrategy: militaryStrategyType) {

                for militaryStrategyTypeFlavor in militaryStrategyType.flavorModifiers() {

                    self.flavors += militaryStrategyTypeFlavor
                }
            }
        }

        // FIXME: inform
    }

    func adopted(militaryStrategy: MilitaryStrategyType) -> Bool {

        return self.militaryStrategyAdoption.adopted(militaryStrategy: militaryStrategy)
    }

    func numberOfPlayersAtWarWith(in gameModel: GameModel?) -> Int {

        guard let players = gameModel?.players else {
            fatalError("cant get players")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        var number = 0

        for otherPlayer in players {

            if self.player?.leader != otherPlayer.leader {

                if !player.hasMet(with: otherPlayer) {
                    continue
                }

                if let warState = player.diplomacyAI?.warState(towards: otherPlayer) {
                    if warState != .none {
                        number += 1
                    }
                }
            }
        }

        return number
    }

    func percentOfRecommendedMilitarySize() -> Int {

        if self.baseData.recommendedMilitarySize <= 0 {
            return 0
        }

        return self.baseData.numLandUnits * 100 / self.baseData.recommendedMilitarySize
    }

    func advisorMessages() -> [AdvisorMessage] {

        var messages: [AdvisorMessage] = []

        for militaryStrategyType in MilitaryStrategyType.all {

            if self.militaryStrategyAdoption.adopted(militaryStrategy: militaryStrategyType) {

                if let message = militaryStrategyType.advisorMessage() {
                    messages.append(message)
                }
            }
        }

        return messages
    }

    func mostThreatenedCity(in gameModel: GameModel?) -> AbstractCity? {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        var highestThreatValue = 0
        var highestThreatendCity: AbstractCity? = nil

        for cityRef in gameModel.cities(of: player) {

            if let city = cityRef {

                var threadValue = city.threatValue() * city.population()

                if city.isCapital() {
                    threadValue *= 125
                    threadValue /= 100
                }

                if threadValue > highestThreatValue {
                    highestThreatValue = threadValue
                    highestThreatendCity = cityRef
                }
            }
        }

        return highestThreatendCity
    }
}
