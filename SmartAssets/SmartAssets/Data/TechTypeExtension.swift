//
//  TechTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.05.21.
//

import SmartAILibrary

extension TechType {

    public func toolTip() -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.name(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)
        toolTipText.append(NSAttributedString(string: "\n\n"))

        let eureka = NSAttributedString(
            string: self.eurekaSummary().localized(),
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(eureka)

        return toolTipText
    }

    // swiftlint:disable:next cyclomatic_complexity
    public func iconTexture() -> String {

        switch self {

        case .none: return "tech-default"

            // ancient
        case .mining: return "tech-mining"
        case .pottery: return "tech-pottery"
        case .animalHusbandry: return "tech-animalHusbandry"
        case .sailing: return "tech-sailing"
        case .astrology: return "tech-astrology"
        case .irrigation: return "tech-irrigation"
        case .writing: return "tech-writing"
        case .masonry: return "tech-masonry"
        case .archery: return "tech-archery"
        case .bronzeWorking: return "tech-bronzeWorking"
        case .wheel: return "tech-wheel"

            // classical
        case .celestialNavigation: return "tech-celestialNavigation"
        case .horsebackRiding: return "tech-horsebackRiding"
        case .currency: return "tech-currency"
        case .construction: return "tech-construction"
        case .ironWorking: return "tech-ironWorking"
        case .shipBuilding: return "tech-shipBuilding"
        case .mathematics: return "tech-mathematics"
        case .engineering: return "tech-engineering"

            // medieval
        case .militaryTactics: return "tech-militaryTactics"
        case .buttress: return "tech-buttress"
        case .apprenticeship: return "tech-apprenticeship"
        case .stirrups: return "tech-stirrups"
        case .machinery: return "tech-machinery"
        case .education: return "tech-education"
        case .militaryEngineering: return "tech-militaryEngineering"
        case .castles: return "tech-castles"

            // renaissance
        case .cartography: return "tech-cartography"
        case .massProduction: return "tech-massProduction"
        case .banking: return "tech-banking"
        case .gunpowder: return "tech-gunpowder"
        case .printing: return "tech-printing"
        case .squareRigging: return "tech-squareRigging"
        case .astronomy: return "tech-astronomy"
        case .metalCasting: return "tech-metalCasting"
        case .siegeTactics: return "tech-siegeTactics"

            // industrial
        case .industrialization: return "tech-industrialization"
        case .scientificTheory: return "tech-scientificTheory"
        case .ballistics: return "tech-ballistics"
        case .militaryScience: return "tech-militaryScience"
        case .steamPower: return "tech-steamPower"
        case .sanitation: return "tech-sanitation"
        case .economics: return "tech-economics"
        case .rifling: return "tech-rifling"

            // modern
        case .flight: return "tech-flight"
        case .replaceableParts: return "tech-replaceableParts"
        case .steel: return "tech-steel"
        case .refining: return "tech-refining"
        case .electricity: return "tech-electricity"
        case .radio: return "tech-radio"
        case .chemistry: return "tech-chemistry"
        case .combustion: return "tech-combustion"

            // atomic
        case .advancedFlight: return "tech-advancedFlight"
        case .rocketry: return "tech-rocketry"
        case .advancedBallistics: return "tech-advancedBallistics"
        case .combinedArms: return "tech-combinedArms"
        case .plastics: return "tech-plastics"
        case .computers: return "tech-computers"
        case .nuclearFission: return "tech-nuclearFission"
        case .syntheticMaterials: return "tech-syntheticMaterials"

            // information
        case .telecommunications: return "tech-telecommunications"
        case .satellites: return "tech-satellites"
        case .guidanceSystems: return "tech-guidanceSystems"
        case .lasers: return "tech-lasers"
        case .composites: return "tech-composites"
        case .stealthTechnology: return "tech-stealthTechnology"
        case .robotics: return "tech-robotics"
        case .nuclearFusion: return "tech-nuclearFusion"
        case .nanotechnology: return "tech-nanotechnology"

        case .futureTech: return "tech-futureTech"
        }
    }
}

extension TechType {

    // swiftlint:disable:next cyclomatic_complexity
    public func indexPath() -> IndexPath {

        switch self {

        case .none:                 return IndexPath(item: -1, section: -1)

            // <!-- ancient: 1st -->
        case .pottery:              return IndexPath(item: 3, section: 0)
        case .animalHusbandry:      return IndexPath(item: 4, section: 0)
        case .mining:               return IndexPath(item: 6, section: 0)
            // <!-- ancient: 2nd -->
        case .sailing:              return IndexPath(item: 0, section: 1)
        case .astrology:            return IndexPath(item: 1, section: 1)
        case .irrigation:           return IndexPath(item: 2, section: 1)
        case .writing:              return IndexPath(item: 3, section: 1)
        case .archery:              return IndexPath(item: 4, section: 1)
            // <!-- ancient: 3rd -->
        case .masonry:              return IndexPath(item: 5, section: 2)
        case .bronzeWorking:        return IndexPath(item: 6, section: 2)
        case .wheel:                return IndexPath(item: 7, section: 2)

            // <!-- classical: 1st -->
        case .celestialNavigation:  return IndexPath(item: 1, section: 3)
        case .currency:             return IndexPath(item: 3, section: 3)
        case .horsebackRiding:      return IndexPath(item: 4, section: 3)
        case .ironWorking:          return IndexPath(item: 6, section: 3)
            // <!-- classical: 2nd -->
        case .shipBuilding:         return IndexPath(item: 0, section: 4)
        case .mathematics:          return IndexPath(item: 2, section: 4)
        case .construction:         return IndexPath(item: 5, section: 4)
        case .engineering:          return IndexPath(item: 7, section: 4)

            // <!-- medieval: 1st -->
        case .militaryTactics:      return IndexPath(item: 1, section: 5)
        case .apprenticeship:       return IndexPath(item: 3, section: 5)
        case .machinery:            return IndexPath(item: 7, section: 5)
            // <!-- medieval: 2nd-->
        case .education:            return IndexPath(item: 2, section: 6)
        case .stirrups:             return IndexPath(item: 4, section: 6)
        case .militaryEngineering:  return IndexPath(item: 5, section: 6)
        case .castles:              return IndexPath(item: 6, section: 6)

            // <!-- renaissance: 1st -->
        case .cartography:          return IndexPath(item: 0, section: 7)
        case .massProduction:       return IndexPath(item: 1, section: 7)
        case .banking:              return IndexPath(item: 3, section: 7)
        case .gunpowder:            return IndexPath(item: 4, section: 7)
        case .printing:             return IndexPath(item: 7, section: 7)
            // <!-- renaissance: 2nd -->
        case .squareRigging:        return IndexPath(item: 0, section: 8)
        case .astronomy:            return IndexPath(item: 2, section: 8)
        case .metalCasting:         return IndexPath(item: 4, section: 8)
        case .siegeTactics:         return IndexPath(item: 6, section: 8)

        case .buttress:             return IndexPath(item: -1, section: -1)
        case .industrialization:    return IndexPath(item: -1, section: -1)
        case .scientificTheory:     return IndexPath(item: -1, section: -1)
        case .ballistics:           return IndexPath(item: -1, section: -1)
        case .militaryScience:      return IndexPath(item: -1, section: -1)
        case .steamPower:           return IndexPath(item: -1, section: -1)
        case .sanitation:           return IndexPath(item: -1, section: -1)
        case .economics:            return IndexPath(item: -1, section: -1)
        case .rifling:              return IndexPath(item: -1, section: -1)
        case .flight:               return IndexPath(item: -1, section: -1)
        case .replaceableParts:     return IndexPath(item: -1, section: -1)
        case .steel:                return IndexPath(item: -1, section: -1)
        case .refining:             return IndexPath(item: -1, section: -1)
        case .electricity:          return IndexPath(item: -1, section: -1)
        case .radio:                return IndexPath(item: -1, section: -1)
        case .chemistry:            return IndexPath(item: -1, section: -1)
        case .combustion:           return IndexPath(item: -1, section: -1)
        case .advancedFlight:       return IndexPath(item: -1, section: -1)
        case .rocketry:             return IndexPath(item: -1, section: -1)
        case .advancedBallistics:   return IndexPath(item: -1, section: -1)
        case .combinedArms:         return IndexPath(item: -1, section: -1)
        case .plastics:             return IndexPath(item: -1, section: -1)
        case .computers:            return IndexPath(item: -1, section: -1)
        case .nuclearFission:       return IndexPath(item: -1, section: -1)
        case .syntheticMaterials:   return IndexPath(item: -1, section: -1)
        case .telecommunications:   return IndexPath(item: -1, section: -1)
        case .satellites:           return IndexPath(item: -1, section: -1)
        case .guidanceSystems:      return IndexPath(item: -1, section: -1)
        case .lasers:               return IndexPath(item: -1, section: -1)
        case .composites:           return IndexPath(item: -1, section: -1)
        case .stealthTechnology:    return IndexPath(item: -1, section: -1)
        case .robotics:             return IndexPath(item: -1, section: -1)
        case .nuclearFusion:        return IndexPath(item: -1, section: -1)
        case .nanotechnology:       return IndexPath(item: -1, section: -1)
        case .futureTech:           return IndexPath(item: -1, section: -1)
        }
    }
}
