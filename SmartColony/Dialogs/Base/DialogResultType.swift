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
    
    // civics - ancient
    case codeOfLaws = "CODEOFLAWS"
    case craftsmanship = "CRAFTSMANSHIP"
    case foreignTrade = "FOREIGNTRADE"
    case stateWorkforce = "STATEWORKFORCE"
    case earlyEmpire = "EARLYEMPIRE"
    case mysticism = "MYSTICISM"
    case militaryTradition = "MILITARYTRADITION"
    
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

        fatalError("niy")
    }
    
    func toCivic() -> CivicType {
        
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
        
        fatalError("niy")
    }
}
