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

        let eureka = NSAttributedString(
            string: "\n\n" + self.eurekaSummary().localized(),
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
        case .militaryTactics: return "tech-default"
        case .buttress: return "tech-default"
        case .apprenticeship: return "tech-default"
        case .stirrups: return "tech-default"
        case .machinery: return "tech-default"
        case .education: return "tech-default"
        case .militaryEngineering: return "tech-default"
        case .castles: return "tech-default"

            // renaissance
        case .cartography: return "tech-default"
        case .massProduction: return "tech-default"
        case .banking: return "tech-default"
        case .gunpowder: return "tech-default"
        case .printing: return "tech-default"
        case .squareRigging: return "tech-default"
        case .astronomy: return "tech-default"
        case .metalCasting: return "tech-default"
        case .siegeTactics: return "tech-default"

            // industrial
        case .industrialization: return "tech-default"
        case .scientificTheory: return "tech-default"
        case .ballistics: return "tech-default"
        case .militaryScience: return "tech-default"
        case .steamPower: return "tech-default"
        case .sanitation: return "tech-default"
        case .economics: return "tech-default"
        case .rifling: return "tech-default"

            // modern
        case .flight: return "tech-default"
        case .replaceableParts: return "tech-default"
        case .steel: return "tech-default"
        case .refining: return "tech-default"
        case .electricity: return "tech-default"
        case .radio: return "tech-default"
        case .chemistry: return "tech-default"
        case .combustrion: return "tech-default"

            // atomic
        case .advancedFlight: return "tech-default"
        case .rocketry: return "tech-default"
        case .advancedBallistics: return "tech-default"
        case .combinedArms: return "tech-default"
        case .plastics: return "tech-default"
        case .computers: return "tech-default"
        case .nuclearFission: return "tech-default"
        case .syntheticMaterials: return "tech-default"

            // information
        case .telecommunications: return "tech-default"
        case .satellites: return "tech-default"
        case .guidanceSystems: return "tech-default"
        case .lasers: return "tech-default"
        case .composites: return "tech-default"
        case .stealthTechnology: return "tech-default"
        case .robotics: return "tech-default"
        case .nuclearFusion: return "tech-default"
        case .nanotechnology: return "tech-default"

        case .futureTech: return "tech-default"
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
        case .combustrion:          return IndexPath(item: -1, section: -1)
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
