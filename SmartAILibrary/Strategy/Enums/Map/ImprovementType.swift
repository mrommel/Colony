//
//  ImprovementType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable type_body_length
public enum ImprovementType: Int, Codable, Hashable {

    case none

    case barbarianCamp
    case goodyHut
    case ruins

    case farm
    case mine
    case quarry
    case camp
    case pasture
    case plantation

    case fishingBoats
    /*case lumberMill*/
    case oilWell

    case fort // Occupying unit receives +4 Defense Strength, and automatically gains 2 turns of fortification.
    case citadelle

    public static var all: [ImprovementType] {

        return [
            .farm,
            .mine,
            .quarry,
            .camp,
            .pasture,
            .plantation,
            .fishingBoats,
            .oilWell,
            .fort,
            .citadelle
        ]
    }

    // https://civilization.fandom.com/wiki/Tile_improvement_(Civ6)
    func yields(for player: AbstractPlayer?, on resource: ResourceType) -> Yields {

        guard let techs = player?.techs else {
            fatalError("cant get techs")
        }

        guard let civics = player?.civics else {
            fatalError("cant get civics")
        }

        guard let religion = player?.religion else {
            fatalError("cant get religion")
        }

        switch self {

        case .none: return Yields(food: 0, production: 0, gold: 0, science: 0)

        case .barbarianCamp: return Yields(food: 0, production: 0, gold: 0, science: 0)
        case .goodyHut: return Yields(food: 0, production: 0, gold: 0, science: 0)
        case .ruins: return Yields(food: 0, production: 0, gold: 0, science: 0)

        case .farm:
            // https://civilization.fandom.com/wiki/Farm_(Civ6)
            let yield = Yields(food: 1, production: 0, gold: 0, science: 0, housing: 0.5)

            // +1 additional Food with two adjacent Farms (requires Feudalism)
            if civics.has(civic: .feudalism) {
                yield.food += 1
            }

            // +1 additional Food for each adjacent Farm (requires Replaceable Parts)
            if techs.has(tech: .replaceableParts) {
                yield.food += 1
            }

            return yield

        case .mine:
            // https://civilization.fandom.com/wiki/Mine_(Civ6)
            let yield =  Yields(food: 0, production: 1, gold: 0, science: 0, appeal: -1.0)

            // +1 additional Production Production (requires Apprenticeship)
            if techs.has(tech: .apprenticeship) {
                yield.production += 1
            }

            // +1 additional Production Production (requires Industrialization)
            if techs.has(tech: .industrialization) {
                yield.production += 1
            }

            // +1 Production Production +1 Faith Faith with God of Craftsmen Pantheon when built on Strategic Resources
            if religion.pantheon() == .godOfCraftsmen && resource.usage() == .strategic {
                yield.production += 1
                yield.faith += 1
            }

            // +2 Faith Faith with Religious Idols Pantheon when built on Bonus or Luxury Resources
            if religion.pantheon() == .religiousIdols && (resource.usage() == .bonus || resource.usage() == .luxury) {
                yield.faith += 2
            }

            // Provides adjacency bonus for Industrial Zones (+1 Production Production, ½ in GS-Only.png).

            // +1 additional Production Production (requires Smart Materials)
            /*if techs.has(tech: .smartMaterials) {
                yield.production += 2
            }*/

            return yield

        case .quarry:
            let yield = Yields(food: 0, production: 1, gold: 0, science: 0, appeal: -1.0)

            // +2 Gold Gold (Banking)
            if techs.has(tech: .banking) {
                yield.gold += 2
            }

            // +1 Production Production (Rocketry)
            if techs.has(tech: .rocketry) {
                yield.production += 1
            }

            // +1 Production Production (Gunpowder)
            if techs.has(tech: .gunpowder) {
                yield.production += 1
            }

            // +1 Production Production (Predictive Systems)
            /*if techs.has(tech: .pred) {
                yield.production += 1
            }*/

            return yield
        case .camp:
            let yield = Yields(food: 0, production: 0, gold: 1, science: 0)

            // +1 Food Food and +1 Production Production (requires Mercantilism)
            if civics.has(civic: .mercantilism) {
                yield.food += 1
                yield.production += 1
            }

            // +2 additional Gold Gold (requires Synthetic Materials)
            if techs.has(tech: .syntheticMaterials) {
                yield.gold += 2
            }

            // +1 Food Food and +1 Production Production with Goddess of the Hunt Pantheon
            if religion.pantheon() == .goddessOfTheHunt {
                yield.food += 1
                yield.production += 1
            }

            return yield

        case .pasture:
            // https://civilization.fandom.com/wiki/Pasture_(Civ6)
            let yield = Yields(food: 0, production: 1, gold: 0, science: 0, housing: 0.5)

            // +1 Food Food (requires Stirrups)
            if techs.has(tech: .stirrups) {
                yield.food += 1
            }

            // +1 additional Production Production and +1 additional Food Food (requires Robotics)
            if techs.has(tech: .robotics) {
                yield.production += 1
                yield.food += 1
            }

            // +1 Production Production from every adjacent Outback Station (requires Steam Power)

            // +1 Culture Culture with God of the Open Sky Pantheon
            if religion.pantheon() == .godOfTheOpenSky {
                yield.culture += 1
            }

            // +1 Production Production and +1 Faith Faith with God of Craftsmen Pantheon when built on Horses Horses
            if religion.pantheon() == .godOfCraftsmen && resource == .horses {
                yield.production += 1
            }

            // +1 additional Production Production (requires Replaceable Parts)
            if techs.has(tech: .replaceableParts) {
                yield.production += 1
            }

            return yield

        case .plantation:
            // https://civilization.fandom.com/wiki/Plantation_(Civ6)
            let yield = Yields(food: 0, production: 0, gold: 2, science: 0, housing: 0.5)

            if civics.has(civic: .feudalism) {
                yield.food += 1
            }

            // +1 Food Food (Scientific Theory)
            if techs.has(tech: .scientificTheory) {
                yield.food += 1
            }

            // +2 Gold Gold (Globalization)
            if civics.has(civic: .globalization) {
                yield.gold += 2
            }

            // 'goddess of festivals' pantheon
            if religion.pantheon() == .goddessOfFestivals {
                yield.culture += 1
            }

            return yield

        case .fishingBoats:
            // https://civilization.fandom.com/wiki/Fishing_Boats_(Civ6)
            let yield = Yields(food: 1, production: 0, gold: 0, science: 0, housing: 0.5)

            if techs.has(tech: .cartography) {
                yield.gold += 2
            }

            if civics.has(civic: .colonialism) {
                yield.production += 1
            }

            if techs.has(tech: .plastics) {
                yield.food += 1
            }

            // 'god of the sea' pantheon
            if religion.pantheon() == .godOfTheSea {
                yield.production += 1
            }

            return yield
        case .oilWell:
            // https://civilization.fandom.com/wiki/Oil_Well_(Civ6)
            let yield =  Yields(food: 0, production: 2, gold: 0, appeal: -1)

            // +1 Production Production and +1 Faith Faith with God of Craftsmen Pantheon
            if religion.pantheon() == .godOfCraftsmen {
                yield.production += 1
                yield.faith += 1
            }

            // +1 Production Production (requires Predictive Systems)
            /*if techs.has(tech: .predictiveSystems) {
                yield.production += 1
            }*/

            return yield

        case .fort: return Yields(food: 0, production: 0, gold: 0)
        case .citadelle: return Yields(food: 0, production: 0, gold: 0)
        }
    }

    func costPerTurn() -> Int {

        switch self {

        case .none: return 0

        case .barbarianCamp: return 0
        case .goodyHut: return 0
        case .ruins: return 0

        case .farm: return 1
        case .mine: return 1
        case .quarry: return 1
        case .camp: return 1
        case .pasture: return 1
        case .plantation: return 1
        case .fishingBoats: return 1
        case .oilWell: return 1

        case .fort: return 1
        case .citadelle: return 1
        }
    }

    func isPossible(on tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        // can't set an improvement to unowned tile or can we?
        guard tile.owner() != nil else {
            return false
        }

        switch self {

        case .none: return false // invalid everywhere

        case .barbarianCamp: return self.isBarbarianCampPossible(on: tile)
        case .goodyHut: return self.isGoodyHutPossible(on: tile)
        case .ruins: return false

        case .farm: return self.isFarmPossible(on: tile)
        case .mine: return self.isMinePossible(on: tile)
        case .quarry: return self.isQuarryPossible(on: tile)
        case .camp: return self.isCampPossible(on: tile)
        case .pasture: return self.isPasturePossible(on: tile)
        case .plantation: return self.isPlantationPossible(on: tile)
        case .fishingBoats: return self.isFishingBoatsPossible(on: tile)
        case .oilWell: return self.isOilWellPossible(on: tile)

        case .fort: return true // FIXME
        case .citadelle: return false // FIXME
        }
    }

    func defenseModifier() -> Int {

        switch self {

        case .none, .barbarianCamp, .goodyHut, .ruins, .farm, .mine, .quarry, .camp, .pasture, .plantation, .fishingBoats, .oilWell:
            return 0
        case .fort:
            return 4
        case .citadelle:
            return 6
        }

        // return 0
    }

    func canBePillaged() -> Bool {

        switch self {

        case .none: return false
        case .barbarianCamp: return false
        case .goodyHut: return false
        case .ruins: return false

        case .farm: return true
        case .mine: return true
        case .quarry: return true
        case .camp: return true
        case .pasture: return true
        case .plantation: return true
        case .fishingBoats: return true
        case .oilWell: return true

        case .fort: return true
        case .citadelle: return true
        }
    }

    func nearbyEnemyDamage() -> Int {

        if self == .fort {
            return 2
        }

        if self == .citadelle {
            return 3
        }

        return 0
    }

    // MARK: private methods

    private func isBarbarianCampPossible(on tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        return tile.terrain().isLand()
    }

    public func isGoodyHutPossible(on tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var possible = true

        if tile.terrain() != .grass && tile.terrain() != .plains && tile.terrain() != .desert && tile.terrain() != .tundra {
            possible = false
        }

        if tile.feature() != .none && tile.feature() != .forest && tile.feature() != .rainforest {
            possible = false
        }

        return possible
    }

    // Farms can be built on non-desert and non-tundra flat lands, which are the most available tiles in Civilization VI.
    // https://civilization.fandom.com/wiki/Farm_(Civ6)
    private func isFarmPossible(on tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }

        //  Initially, it can be constructed only on flatland Grassland, Plains, ...
        if (tile.terrain() == .grass || tile.terrain() == .plains) && !tile.hasHills() {
            return true
        }

        // or Floodplains tiles
        if tile.terrain() == .desert && !tile.hasHills() && tile.has(feature: .floodplains) {
            return true
        }

        // but researching Civil Engineering enables Farms to be built on Grassland Hills and Plains Hills.
        if (tile.terrain() == .grass || tile.terrain() == .plains) && tile.hasHills() && owner.has(civic: .civilEngineering) {
            return true
        }

        return false
    }

    private func isMinePossible(on tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }

        if !tile.terrain().isLand() {
            return false
        }

        if !tile.hasHills() {
            return false
        }

        if !owner.has(tech: .mining) {
            return false
        }

        return true
    }

    private func isQuarryPossible(on tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }

        if !owner.has(tech: .animalHusbandry) {
            return false
        }

        return tile.has(resource: .stone, for: owner) || tile.has(resource: .marble, for: owner) /* || tile.has(resource: .gypsum, for: owner) */
    }

    private func isCampPossible(on tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }

        if !owner.has(tech: .animalHusbandry) {
            return false
        }

        return tile.has(resource: .deer, for: owner) || tile.has(resource: .furs, for: owner) || tile.has(resource: .ivory, for: owner) // || tile.has(resource: .truffles, for: owner) 
    }

    private func isPasturePossible(on tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }

        if !owner.has(tech: .animalHusbandry) {
            return false
        }

        return tile.has(resource: .cattle, for: owner) || tile.has(resource: .sheep, for: owner) || tile.has(resource: .horses, for: owner)
    }

    private func isPlantationPossible(on tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }

        if !owner.has(tech: .irrigation) {
            return false
        }

        let validResources: [ResourceType] = [
            .bananas, .citrus, .cocoa, /*.coffee,*/ .cotton, .dyes, .silk, .sugar, .tea, /*.tobacco,*/ .wine /*.olives*/
        ]

        for validResource in validResources where tile.has(resource: validResource, for: owner) {

            return true
        }

        return false
    }

    private func isFishingBoatsPossible(on tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }

        if !owner.has(tech: .sailing) {
            return false
        }

        let validResources: [ResourceType] = [
            .fish, .whales, .pearls, .crab // amber, turtles
        ]

        for validResource in validResources where tile.has(resource: validResource, for: owner) {

            return true
        }

        return false
    }

    private func isOilWellPossible(on tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }

        if !owner.has(tech: .refining) {
            return false
        }

        return tile.has(resource: .oil, for: owner)
    }

    func required() -> TechType? {

        switch self {

        case .none, .barbarianCamp, .goodyHut, .ruins: return nil

        case .farm: return nil
        case .mine: return .mining
        case .quarry: return .mining
        case .camp: return .animalHusbandry
        case .pasture: return .animalHusbandry
        case .plantation: return .irrigation
        case .fishingBoats: return .sailing
        case .oilWell: return .refining

        case .fort: return .siegeTactics
        case .citadelle: return .siegeTactics
        }
    }

    // is this improvment special to a civilization?
    func civilization() -> CivilizationType? {

        return nil
    }

    func flavor(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavors().first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return 0
    }

    func flavors() -> [Flavor] {

        switch self {

        case .none: return []
        case .ruins: return []

        case .barbarianCamp: return []
        case .goodyHut: return []
        case .farm: return []
        case .mine: return []
        case .quarry: return []
        case .camp: return []
        case .pasture: return []
        case .plantation: return []
        case .fishingBoats: return []
        case .oilWell: return []

        case .fort: return []
        case .citadelle: return []
        }
    }

    /* func enables(resource: ResourceType) -> Bool {

        if self == .farm && (resource == .wheat || resource == .rice) {
            return true
        }

        // Copper Diamonds Gold Ore  Iron  Jade  Mercury  Salt  Niter  Coal  Aluminum  Uranium  Amber
        if self == .mine && (resource == .iron || resource == .copper ) {
            return true
        }

        // Gypsum
        if self == .quarry && (resource == .stone || resource == .marble) {
            return true
        }

        // Bananas Citrus Cocoa Coffee Cotton Dyes Silk Sugar Tea Tobacco Wine Olives
        if self == .plantation && (resource == .bananas || resource == .citrus || resource == .tea) {
            return true
        }

        // Deer Furs Ivory Truffles
        if self == .camp && (resource == .deer || resource == .furs) {
            return true
        }

        // Sheep Cattle Horses
        if self == .pasture && (resource == .sheep || resource == .cattle || resource == .horses) {
            return true
        }

        // Fish Crabs Whales Pearls Amber Turtles
        if self == .fishingBoats && (resource == .fish || resource == .whales || resource == .pearls) {
            return true
        }

        // oil
        if self == .oilWell && resource == .oil {
            return true
        }

        return false
    } */
}
