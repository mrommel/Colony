//
//  UnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum CivilianAttackPriorityType {

    case none
    case high
    case highEarlyGameOnly
    case low
}

public enum UnitType: Int, Codable {

    // default

    case none

    // civilians ------------------------------

    case settler
    case builder
    case trader

    // recon ------------------------------

    // recon - ancient
    case scout

    // recon - medieval
    case skirmisher

    // melee ------------------------------

    // melee - ancient
    case warrior

    // melee - classical
    case swordman

    // melee - medieval
    case manAtArms

    // ranged ------------------------------

    // ranged - ancient
    case slinger
    case archer

    // ranged - medieval
    case crossbowman

    // anti-cavalry ------------------------------

    // anti-cavalry - ancient
    case spearman

    // anti-cavalry - medieval
    case pikeman

    // light cavalry ------------------------------

    // light cavalry - classical
    case horseman

    // light cavalry - medieval
    // Courser

    // heavy cavalry ------------------------------

    // heavy cavalry - ancient
    case heavyChariot

    // heavy cavalry - medieval
    case knight

    // siege ------------------------------

    // siege - classical
    case catapult

    // siege - medieval
    case trebuchet

    // naval melee ------------------------------

    // naval melee - ancient
    case galley

    // naval ranged ------------------------------

    // naval ranged - classical
    case quadrireme

    // support ------------------------------

    // support - ancient
    case batteringRam

    // support - classical
    case siegeTower

    // support - medieval
    // Military Engineer

    // support - industrial
    case medic

    // great people ------------------------------
    case artist
    case admiral
    case engineer
    case general
    case merchant
    case musician
    case prophet
    case scientist
    case writer

    // player overrides
    // barbarians

    case barbarianWarrior
    case barbarianArcher

    public static var all: [UnitType] {

        return [

            // civil units
            .settler, .builder, .trader,

            // ancient
            .scout, .warrior, .slinger, .archer, .spearman, .heavyChariot, .galley, .batteringRam,

            // classical
            .swordman, .horseman, .catapult, .quadrireme, .siegeTower,

            // medieval
            .skirmisher, .manAtArms, .crossbowman, .pikeman, .knight, .trebuchet,

            // industrial
            .medic,

            // great people
            .artist, .engineer, .merchant, .scientist, .admiral, .general, .prophet, .musician, .writer
        ]
    }

    public static var greatPersons: [UnitType] {

        return [.general, .artist, .admiral, .engineer, .general, .merchant, .prophet, .scientist, .musician, .writer]
    }

    public func name() -> String {

        return self.data().name
    }

    public func effects() -> [String] {

        return self.data().effects
    }

    public func era() -> EraType {

        return self.data().era
    }

    func range() -> Int {

        return self.data().range
    }

    func sight() -> Int {

        return self.data().sight
    }

    // https://panzercorps.gamepedia.com/Terrain
    func moves() -> Int {

        return self.data().moves
    }

    // melee strength
    func meleeStrength() -> Int {

        return self.data().meleeAttack
    }

    func rangedStrength() -> Int {

        if self.range() > 0 {
            return self.data().rangedAttack
        }

        return 0
    }

    public func unitClass() -> UnitClassType {

        return self.data().targetType
    }

    // returns the unittype of non standard units (such as special units of civilizations)
    func baseType() -> UnitType? {

        return self.data().baseType
    }

    func power() -> Int {

        var powerVal = 0

        // ***************
        // Main Factors - Strength & Moves
        // ***************

        // We want a Unit that has twice the strength to be roughly worth 3x as much with regards to Power
        powerVal = Int(pow(Double(self.meleeStrength()), 1.5))

        // Ranged Strength
        var rangedPower = Int(pow(Double(self.rangedStrength()), 1.45))

        // Naval ranged attacks are less useful
        if self.domain() == .sea {
            rangedPower /= 2
        }

        if rangedPower > 0 {
            powerVal = rangedPower
        }

        // We want Movement rate to be important, but not a dominating factor; a Unit with double the moves of a similarly-strengthed Unit should be ~1.5x as Powerful
        powerVal = Int(Double(powerVal) * pow(Double(self.moves()), 0.3))

        // ***************
        // ability modifiers
        // ***************

        /*for ability in self.abilities() {
            // FIXME
        }*/

        return powerVal
    }

    // https://github.com/Thalassicus/cep-bnw/blob/9196a4d3fc84c173013a900691222ee072eb5c8a/Ceg/Ceg/AI/Flavors/Custom%20AI%20Flavors/Ancient%20-%20Early.xml
    func flavours() -> [Flavor] {

        return self.data().flavours
    }

    public func domain() -> UnitDomainType {

        return self.data().domain
    }

    func movementType() -> UnitMovementType {

        return self.data().movementType
    }

    func canFound() -> Bool {

        return self.has(ability: .canFound)
    }

    func unitTasks() -> [UnitTaskType] {

        return self.data().unitTasks
    }

    func defaultTask() -> UnitTaskType {

        return self.data().defaultTask
    }

    /// cost in production
    public func productionCost() -> Int {

        return self.data().productionCost
    }

    /// cost in gold
    func purchaseCost() -> Int {

        return self.data().purchaseCost
    }

    /// cost in faith
    func faithCost() -> Int {

        return self.data().faithCost
    }

    /// maintenance cost in gold
    func maintenanceCost() -> Int {

        return self.data().maintenanceCost
    }

    public func requiredTech() -> TechType? {

        return self.data().requiredTech
    }

    public func obsoleteTech() -> TechType? {

        return self.data().obsoleteTech
    }

    public func requiredCivic() -> CivicType? {

        return self.data().requiredCivic
    }

    public func requiredResource() -> ResourceType? {

        return self.data().requiredResource
    }

    public func upgradesFrom() -> [UnitType] {

        return self.data().upgradesFrom
    }

    // is unit type special to any civ? nil if not
    public func civilization() -> CivilizationType? {

        return self.data().civilization
    }

    private func data() -> UnitTypeData {

        switch self {

        case .none: return UnitTypeData()

        case .barbarianWarrior: return BarbarianWarriorUnitType()
        case .barbarianArcher: return BarbarianArcherUnitType()

            // civilian
        case .settler: return SettlerUnitType()
        case .builder: return BuilderUnitType()
        case .trader: return TraderUnitType()

            // ancient
        case .scout: return ScoutUnitType()
        case .warrior: return WarriorUnitType()
        case .slinger: return SlingerUnitType()
        case .archer: return ArcherUnitType()
        case .spearman: return SpearmanUnitType()
        case .heavyChariot: return HeavyChariotUnitType()
        case .galley: return GalleyUnitType()
        case .batteringRam: return BatteringRamUnitType()

            // classical
        case .swordman: return SwordmanUnitType()
        case .horseman: return HorsemanUnitType()
        case .catapult: return CatapultUnitType()
        case .quadrireme: return QuadriremeUnitType()
        case .siegeTower: return SiegeTowerUnitType()

            // medieval
        case .skirmisher: return SkirmisherUnitType()
        case .manAtArms: return ManAtArmsUnitType()
        case .crossbowman: return CrossbowmanUnitType()
        case .pikeman: return PikemanUnitType()
        case .knight: return KnightUnitType()
        case .trebuchet: return TrebuchetUnitType()

            // industrial
        case .medic: return MedicUnitType()

            // great people
        case .admiral: return AdmiralUnitType()
        case .artist: return ArtistUnitType()
        case .engineer: return EngineerUnitType()
        case .general: return GeneralUnitType()
        case .merchant: return MerchantUnitType()
        case .musician: return MusicianUnitType()
        case .prophet: return ProphetUnitType()
        case .scientist: return ScientistUnitType()
        case .writer: return WriterUnitType()
        }
    }

    func abilities() -> [UnitAbilityType] {

        return self.data().abilities
    }

    public func unitType(for civilization: CivilizationType) -> UnitType? {

        if self.civilization() == civilization {
            return self
        }

        if civilization == .barbarian {
            return nil
        }

        return self.baseType()
    }

    func civilianAttackPriority() -> CivilianAttackPriorityType {

        if self == .settler {
            return .highEarlyGameOnly
        }

        if self == .builder {
            return .low
        }

        return .none
    }

    func canBuild(build: BuildType) -> Bool {

        switch build {

        case .none: return false

        case .repair: return self.has(ability: .canImprove)

        case .ancientRoad: return self.has(ability: .canBuildRoads)
        case .classicalRoad: return self.has(ability: .canBuildRoads)
        case .removeRoad: return self.has(ability: .canImprove)

        case .farm: return self.has(ability: .canImprove)
        case .mine: return self.has(ability: .canImprove)
        case .quarry: return self.has(ability: .canImprove)
        case .plantation: return self.has(ability: .canImprove)
        case .camp: return self.has(ability: .canImprove)
        case .pasture: return self.has(ability: .canImprove)
        case .fishingBoats: return self.has(ability: .canImprove)

        case .removeForest: return self.has(ability: .canImprove)
        case .removeRainforest: return self.has(ability: .canImprove)
        case .removeMarsh: return self.has(ability: .canImprove)
        }
    }

    func has(ability: UnitAbilityType) -> Bool {

        return self.abilities().contains(ability)
    }

    func workRate() -> Int {

        // in civ6 builders are building improvements immediately
        if self == .builder {
            return 1000 // used to be 100
        }

        return 0
    }

    public func buildCharges() -> Int {

        if self == .builder {
            return 3
        }

        return 0
    }

    func captureType() -> UnitType? {

        if self == .builder || self == .settler {
            return .builder
        }

        return nil
    }

    func canPillage() -> Bool {

        if self == .builder || self == .settler {
            return false
        }

        return true
    }

    func healingAdjacentUnits() -> Int {

        if self.has(ability: .canHeal) {
            return 20
        }

        return 0
    }

    func canFoundReligion() -> Bool {

        if self == .prophet {
            return true
        }

        return false
    }

    func isGreatPerson() -> Bool {

        if UnitType.greatPersons.contains(self) {

            return true
        }

        return false
    }

    func canMoveInRivalTerritory() -> Bool {

        return self.has(ability: .canMoveInRivalTerritory)
    }
}
