//
//  DialogResultType.swift
//  SmartColony
//
//  Created by Michael Rommel on 14.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

enum DialogResultType: String, Codable {

    case none
    case okay = "OKAY"
    case cancel = "CANCEL"

    // handicaps
    case handicapSettler = "HANDICAP_SETTLER"
    case handicapChieftain = "HANDICAP_CHIEFTAIN"
    case handicapWarlord = "HANDICAP_WARLORD"
    case handicapPrince = "HANDICAP_PRINCE"
    case handicapKing = "HANDICAP_KING"
    case handicapEmperor = "HANDICAP_EMPEROR"
    case handicapImmortal = "HANDICAP_IMMORTAL"
    case handicapDeity = "HANDICAP_DEITY"

    // leaders
    case leaderAlexander = "LEADER_ALEXANDER"
    case leaderAugustus = "LEADER_AUGUSTUS"
    case leaderElizabeth = "LEADER_ELIZABETH"
    case leaderMontezuma = "LEADER_MONTEZUMA"
    case leaderNapoloen = "LEADER_NAPOLEAN"
    case leaderPeterTheGreat = "LEADER_PETERTHEGREAT"
    case leaderBarbarossa = "LEADER_BARBAROSSA"

    // map types
    case mapTypeEarth = "EARTH"
    case mapTypePangaea = "PANGAEA"
    case mapTypeContinents = "CONTINENTS"
    case mapTypeArchipelago = "ARCHIPELAGO"
    case mapTypeInlandsea = "INLANDSEA"
    case mapTypeCustom = "TYPECUSTOM"

    // map sizes
    case mapSizeHuge = "HUGE"
    case mapSizeLarge = "LARGE"
    case mapSizeStandard = "STANDARD"
    case mapSizeSmall = "SMALL"
    case mapSizeTiny = "TINY"

    // map ages
    case mapAgeYoung = "AGE_YOUNG"
    case mapAgeNormal = "AGE_NORMAL"
    case mapAgeOld = "AGE_OLD"

    // map rainfall
    case mapRainfallWet = "RAINFALL_WET"
    case mapRainfallNormal = "RAINFALL_NORMAL"
    case mapRainfallDry = "RAINFALL_DRY"

    // map climate
    case mapClimateHot = "CLIMATE_HOT"
    case mapClimateTemperate = "CLIMATE_TEMPERATE"
    case mapClimateCold = "CLIMATE_COLD"

    // map climate
    case mapSeaLevelLow = "SEALEVEL_LOW"
    case mapSeaLevelNormal = "SEALEVEL_NORMAL"
    case mapSeaLevelHigh = "SEALEVEL_HIGH"

    // commands
    case commandFound = "COMMAND_FOUND"
    case commandBuildFarm = "COMMAND_BUILD_FARM"
    case commandBuildMine = "COMMAND_BUILD_MINE"
    case commandBuildRoute = "COMMAND_BUILD_ROUTE"
    case commandPillage = "COMMAND_PILLAGE"
    case commandFortify = "COMMAND_FORTIFY"
    case commandHold = "COMMAND_HOLD"
    case commandGarrison = "COMMAND_GARRISON"

    // techs - ancient
    case mining = "MINING"
    case pottery = "POTTERY"
    case animalHusbandry = "ANIMALHUSBANDRY"
    case sailing = "SAILING"
    case astrology = "ASTROLOGY"
    case irrigation = "IRRIGATION"
    case writing = "WRITING"
    case masonry = "MASONRY"
    case archery = "ARCHERY"
    case bronzeWorking = "BRONZEWORKING"
    case wheel = "WHEEL"

    // techs - classic
    case celestialNavigation = "CELESTIALNAVIGATION"
    case currency = "CURRENCY"
    case horsebackRiding = "HORSEBACKRIDING"
    case ironWorking = "IRONWORKING"
    case shipBuilding = "SHIPBUILDING"
    case mathematics = "MATHEMATICS"
    case construction = "CONSTRUCTION"
    case engineering = "ENGINEERING"

    // techs - medvieval
    case militaryTactics = "MILITARYTACTICS"
    case apprenticeship = "APPRENTICESHIP"
    case machinery = "MACHINERY"
    case education = "EDUCATION"
    case stirrups = "STIRRUPS"
    case militaryEngineering = "MILITARYENGINEERING"
    case castles = "CASTLES"

    // techs - renaissance
    case cartography = "CARTOGRAPHY"
    case massProduction = "MASSPRODUCTION"
    case banking = "BANKING"
    case gunPowder = "GUNPOWDER"
    case printing = "PRINTING"
    case squareRigging = "SQUARERIGGING"
    case astronomy = "ASTRONOMY"
    case metalCasting = "METALCASTING"
    case siegeTactics = "SIEGETACTICS"

    // civics - ancient
    case codeOfLaws = "CODEOFLAWS"
    case craftsmanship = "CRAFTSMANSHIP"
    case foreignTrade = "FOREIGNTRADE"
    case stateWorkforce = "STATEWORKFORCE"
    case earlyEmpire = "EARLYEMPIRE"
    case mysticism = "MYSTICISM"
    case militaryTradition = "MILITARYTRADITION"

    // civics - classical
    case gamesAndRecreation = "GAMESANDRECREATION"
    case politicalPhilosophy = "POLITICALPHILOSOPHY"
    case dramaAndPoetry = "DRAMAANDPOETRY"
    case militaryTraining = "MILITARYTRAINING"
    case defensiveTactics = "DEFENSIVETACTICS"
    case recordedHistory = "RECORDEDHISTORY"
    case theology = "THEOLOGY"

    // civics - medieval
    case navalTradition = "NAVALTRADITION"
    case feudalism = "FEUDALISM"
    case civilService = "CIVILSERVICE"
    case mercenaries = "MERCENARIES"
    case medievalFaires = "MEDIEVALFAIRES"
    case guilds = "GUILDS"
    case divineRight = "DIVINERIGHT"

    // civics - renaissance
    case exploration = "EXPLORATION"
    case humanism = "HUMANISM"
    case diplomaticService = "DIPLOMATICSERVICE"
    case reformedChurch = "REFORMEDCHURCH"
    case mercantilism = "MERCANTILISM"
    case enlightenment = "ENLIGHTENMENT"

    // promotions - recon
    case ranger = "RANGER"
    case alpine = "ALPINE"
    case sentry = "SENTRY"
    case guerrilla = "GUERRILLA"
    case spyglass = "SPYGLASS"
    case ambush = "AMBUSH"
    case camouflage = "CAMOUFLAGE"

    // promotions - melee
    case battleCry = "BATTLECRY"
    case tortoise = "TORTOISE"
    case commando = "COMMANDE"
    case amphibious = "AMPHIBIOUS"
    case zweihander = "ZWEIHANDER"
    case urbanWarfare = "URBANWARFARE"
    case eliteGuard = "ELTIEGUARD"

    // diplomatic responses
    case responseChoice0 = "DIPLO_CHOICE_0"
    case responseChoice1 = "DIPLO_CHOICE_1"
    case responseChoice2 = "DIPLO_CHOICE_2"

    // government dialog
    // case myGovernment = "MYGOVERNMENT"
    case changePolicies = "CHANGEPOLICIES"
    case changeGovernment = "CHANGEGOVERNMENT"

    // game menu options
    case gameQuickSave = "GAME_QUICKSAVE"
    case gameSave = "GAME_SAVE"
    case gameLoad = "GAME_LOAD"
    case gameRetire = "GAME_RETIRE"
    case gameRestart = "GAME_RESTART"
    case gameExit = "GAME_EXIT"

    // MARK: methods

    func toMapType() -> MapType {

        if self == .mapTypeEarth {
            return .earth
        } else if self == .mapTypePangaea {
            return .pangaea
        } else if self == .mapTypeInlandsea {
            return .inlandsea
        } else if self == .mapTypeContinents {
            return .continents
        } else if self == .mapTypeArchipelago {
            return .archipelago
        } else if self == .mapTypeCustom {
            return .custom
        }

        fatalError("niy")
    }

    func toMapSize() -> MapSize {

        if self == .mapSizeHuge {
            return .huge
        } else if self == .mapSizeLarge {
            return .large
        } else if self == .mapSizeStandard {
            return .standard
        } else if self == .mapSizeSmall {
            return .small
        } else if self == .mapSizeTiny {
            return .tiny
        }

        fatalError("niy")
    }

    func toHandicapType() -> HandicapType {

        if self == .handicapSettler {
            return .settler
        } else if self == .handicapChieftain {
            return .chieftain
        } else if self == .handicapWarlord {
            return .warlord
        } else if self == .handicapPrince {
            return .prince
        } else if self == .handicapKing {
            return .king
        } else if self == .handicapEmperor {
            return .emperor
        } else if self == .handicapImmortal {
            return .immortal
        } else if self == .handicapDeity {
            return .deity
        }

        fatalError("niy")
    }

    func toLeaderType() -> LeaderType {

        if self == .leaderAugustus {
            return .augustus
        } else if self == .leaderAlexander {
            return .alexander
        } else if self == .leaderElizabeth {
            return .elizabeth
        } else if self == .leaderMontezuma {
            return .montezuma
        } else if self == .leaderNapoloen {
            return .napoleon
        } else if self == .leaderPeterTheGreat {
            return .peterTheGreat
        } else if self == .leaderBarbarossa {
            return .barbarossa
        }

        fatalError("niy")
    }

    func toMapOptionAge() -> MapOptionAge {

        if self == .mapAgeOld {
            return .old
        } else if self == .mapAgeNormal {
            return .normal
        } else if self == .mapAgeYoung {
            return .young
        }

        fatalError("niy")
    }

    func toMapOptionClimate() -> MapOptionClimate {

        if self == .mapClimateHot {
            return .hot
        } else if self == .mapClimateTemperate {
            return .temperate
        } else if self == .mapClimateCold {
            return .cold
        }

        fatalError("niy")
    }

    func toMapOptionRainfall() -> MapOptionRainfall {

        if self == .mapRainfallDry {
            return .dry
        } else if self == .mapRainfallNormal {
            return .normal
        } else if self == .mapRainfallWet {
            return .wet
        }

        fatalError("niy")
    }

    func toMapOptionSeaLevel() -> MapOptionSeaLevel {

        if self == .mapSeaLevelLow {
            return .low
        } else if self == .mapSeaLevelNormal {
            return .normal
        } else if self == .mapSeaLevelHigh {
            return .high
        }

        fatalError("niy")
    }

    func toTech() -> TechType {

        // ancient
        if self == .writing {
            return .writing
        } else if self == .irrigation {
            return .irrigation
        } else if self == .animalHusbandry {
            return .animalHusbandry
        } else if self == .pottery {
            return .pottery
        } else if self == .mining {
            return .mining
        } else if self == .sailing {
            return .sailing
        } else if self == .astrology {
            return .astrology
        } else if self == .masonry {
            return .masonry
        } else if self == .archery {
            return .archery
        } else if self == .bronzeWorking {
            return .bronzeWorking
        } else if self == .wheel {
            return .wheel
        }

        // classical
        if self == .celestialNavigation {
            return .celestialNavigation
        } else if self == .currency {
            return .currency
        } else if self == .horsebackRiding {
            return .horsebackRiding
        } else if self == .ironWorking {
            return .ironWorking
        } else if self == .shipBuilding {
            return .shipBuilding
        } else if self == .mathematics {
            return .mathematics
        } else if self == .construction {
            return .construction
        } else if self == .engineering {
            return .engineering
        }

        // medieval
        if self == .militaryTactics {
            return .militaryTactics
        } else if self == .apprenticeship {
            return .apprenticeship
        } else if self == .machinery {
            return .machinery
        } else if self == .education {
            return .education
        } else if self == .stirrups {
            return .stirrups
        } else if self == .militaryEngineering {
            return .militaryEngineering
        } else if self == .castles {
            return .castles
        }

        // renaissance
        if self == .cartography {
            return .cartography
        } else if self == .massProduction {
            return .massProduction
        } else if self == .banking {
            return .banking
        } else if self == .gunPowder {
            return .gunpowder
        } else if self == .printing {
            return .printing
        } else if self == .squareRigging {
            return .squareRigging
        } else if self == .astronomy {
            return .astronomy
        } else if self == .metalCasting {
            return .metalCasting
        } else if self == .siegeTactics {
            return .siegeTactics
        }

        fatalError("niy")
    }

    func toCivic() -> CivicType {

        // Ancient
        if self == .stateWorkforce {
            return .stateWorkforce
        } else if self == .craftsmanship {
            return .craftsmanship
        } else if self == .codeOfLaws {
            return .codeOfLaws
        } else if self == .earlyEmpire {
            return .earlyEmpire
        } else if self == .foreignTrade {
            return .foreignTrade
        } else if self == .mysticism {
            return .mysticism
        } else if self == .militaryTradition {
            return .militaryTraining
        }

        // classical
        if self == .gamesAndRecreation {
            return .gamesAndRecreation
        } else if self == .politicalPhilosophy {
            return .politicalPhilosophy
        } else if self == .dramaAndPoetry {
            return .dramaAndPoetry
        } else if self == .militaryTraining {
            return .militaryTraining
        } else if self == .defensiveTactics {
            return .defensiveTactics
        } else if self == .recordedHistory {
            return .recordedHistory
        } else if self == .theology {
            return .theology
        }

        // medieval
        if self == .navalTradition {
            return .navalTradition
        } else if self == .feudalism {
            return .feudalism
        } else if self == .civilService {
            return .civilService
        } else if self == .mercenaries {
            return .mercenaries
        } else if self == .medievalFaires {
            return .medievalFaires
        } else if self == .guilds {
            return .guilds
        } else if self == .divineRight {
            return .divineRight
        }

        // renaissance
        if self == .exploration {
            return .exploration
        } else if self == .humanism {
            return .humanism
        } else if self == .diplomaticService {
            return .diplomaticService
        } else if self == .reformedChurch {
            return .reformedChurch
        } else if self == .mercantilism {
            return .mercantilism
        } else if self == .enlightenment {
            return .enlightenment
        }

        fatalError("niy")
    }

    func toPromotionType() -> UnitPromotionType? {

        // recon
        if self == .ranger {
            return .ranger
        } else if self == .alpine {
            return .alpine
        } else if self == .sentry {
            return .sentry
        } else if self == .guerrilla {
            return .guerrilla
        } else if self == .spyglass {
            return .spyglass
        } else if self == .ambush {
            return .ambush
        } else if self == .camouflage {
            return .camouflage
        }

        // melee
        if self == .battleCry {
            return .battleCry
        } else if self == .tortoise {
            return .tortoise
        } else if self == .commando {
            return .commando
        } else if self == .amphibious {
            return .amphibious
        } else if self == .zweihander {
            return .zweihander
        } else if self == .urbanWarfare {
            return .urbanWarfare
        } else if self == .eliteGuard {
            return .eliteGuard
        }

        fatalError("niy")
    }
}

extension DialogResultType {

    init?(promotionType: UnitPromotionType) {

        switch promotionType {
        case .embarkation:
            return nil
        case .healthBoostRecon:
            return nil
        case .healthBoostMelee:
            return nil

            // recon
        case .ranger:
            self = .ranger
        case .alpine:
            self = .alpine
        case .sentry:
            self = .sentry
        case .guerrilla:
            self = .guerrilla
        case .spyglass:
            self = .spyglass
        case .ambush:
            self = .ambush
        case .camouflage:
            self = .camouflage

            // melee
        case .battleCry:
            self = .battleCry
        case .tortoise:
            self = .tortoise
        case .commando:
            self = .commando
        case .amphibious:
            self = .amphibious
        case .zweihander:
            self = .zweihander
        case .urbanWarfare:
            self = .urbanWarfare
        case .eliteGuard:
            self = .eliteGuard

        }
    }
}
