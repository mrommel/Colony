//
//  CityLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class CityLayer: SKNode {

    // MARK: intern classes

    private class CityLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool

        let health: Int
        let maxHealth: Int
        let strength: Int
        let population: Int
        let growthInTurns: Int
        let maxGrowthInTurns: Int
        let isCapital: Bool
        let name: String
        let governor: GovernorType?

        let production: Double
        let productionCost: Int
        let unitType: UnitType?
        let buildingType: BuildingType?
        let wonderType: WonderType?
        let districtType: DistrictType?
        let projectType: ProjectType?

        init(point: HexPoint, visible: Bool, discovered: Bool, health: Int, maxHealth: Int, strength: Int,
             population: Int, growthInTurns: Int, maxGrowthInTurns: Int, isCapital: Bool, name: String, governor: GovernorType?,
             production: Double, productionCost: Int, unitType: UnitType?, buildingType: BuildingType?, wonderType: WonderType?,
             districtType: DistrictType?, projectType: ProjectType?) {

            self.visible = visible
            self.discovered = discovered

            self.health = health
            self.maxHealth = maxHealth
            self.strength = strength
            self.population = population
            self.growthInTurns = growthInTurns
            self.maxGrowthInTurns = maxGrowthInTurns
            self.isCapital = isCapital
            self.name = name
            self.governor = governor

            self.production = production
            self.productionCost = productionCost
            self.unitType = unitType
            self.buildingType = buildingType
            self.wonderType = wonderType
            self.districtType = districtType
            self.projectType = projectType

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)

            hasher.combine(self.visible)
            hasher.combine(self.discovered)

            hasher.combine(self.health)
            hasher.combine(self.maxHealth)
            hasher.combine(self.strength)
            hasher.combine(self.population)
            hasher.combine(self.growthInTurns)
            hasher.combine(self.maxGrowthInTurns)
            hasher.combine(self.isCapital)
            hasher.combine(self.name)
            hasher.combine(self.governor)

            hasher.combine(self.production)
            hasher.combine(self.productionCost)
            hasher.combine(self.unitType)
            hasher.combine(self.buildingType)
            hasher.combine(self.wonderType)
            hasher.combine(self.districtType)
            hasher.combine(self.projectType)
        }
    }

    private class CityLayerHasher: BaseLayerHasher<CityLayerTile> {

    }

    // MARK: variables

    private var hasher: CityLayerHasher?

    static let kTextureWidth: Int = 48
    static let kTextureSize: CGSize = CGSize(width: kTextureWidth, height: kTextureWidth)

    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?

    var cityObjects: [CityObject]

    var showCompleteMap: Bool = false

    init(player: AbstractPlayer?) {

        self.player = player
        self.cityObjects = []

        super.init()
        self.zPosition = Globals.ZLevels.feature
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func populate(with gameModel: GameModel?) {

        self.gameModel = gameModel

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        self.textureUtils = TextureUtils(with: gameModel)
        self.hasher = CityLayerHasher(with: gameModel)

        for player in gameModel.players {

            for city in gameModel.cities(of: player) {

                self.show(city: city)
            }
        }
    }

    func show(city: AbstractCity?) {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        guard let tile = gameModel.tile(at: city.location) else {
            fatalError("cant get tile")
        }

        if tile.isVisible(to: player) {
            let cityObject = CityObject(city: city, in: self.gameModel)

            // add to canvas
            cityObject.addTo(node: self)

            cityObject.showCityBanner()

            // keep reference
            cityObjects.append(cityObject)

        } else if tile.isDiscovered(by: player) {
            let cityObject = CityObject(city: city, in: self.gameModel)

            // add to canvas
            cityObject.addTo(node: self)

            // keep reference
            cityObjects.append(cityObject)
        }
    }

    func update(city: AbstractCity?) {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        guard let city = city else {
            fatalError("no city provided")
        }

        guard let tile = gameModel.tile(at: city.location) else {
            fatalError("cant get tile")
        }

        let isDiscovered = tile.isDiscovered(by: player)
        let isVisible = tile.isVisible(to: player)

        if let cityObject = self.cityObjects.first(where: { city.location == $0.city?.location }) {
            if isVisible {

                let currentHashValue = self.hash(for: city, on: tile)
                if !self.hasher!.has(hash: currentHashValue, at: city.location) {
                    cityObject.updateCityBanner()

                    // FIXME update city size / buildings
                    self.hasher?.update(hash: currentHashValue, at: city.location)
                }
            }
        } else {
            if isDiscovered {
                self.show(city: city)
            }
        }
    }

    func remove(city: AbstractCity?) {

        guard let city = city else {
            fatalError("no city provided")
        }

        if let cityObject = self.cityObjects.first(where: { city.location == $0.city?.location }) {
            cityObject.hideCityBanner()
        }

        self.cityObjects.removeAll(where: { city.location == $0.city?.location })
    }

    func rangeAttackUnit(at location: HexPoint, by city: AbstractCity?) {

        guard let city = city else {
            fatalError("no city provided")
        }

        if let cityObject = self.cityObjects.first(where: { city.location == $0.city?.location }) {
            cityObject.attack(towards: location)
        }
    }

    private func hash(for city: AbstractCity?, on tile: AbstractTile?) -> CityLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        let health: Int = city.healthPoints()
        let maxHealth: Int = city.maxHealthPoints()
        let strength: Int = city.combatStrength(against: nil, in: self.gameModel)
        let population: Int = city.population()
        let growthInTurns: Int = city.growthInTurns()
        let maxGrowthInTurns: Int = city.maxGrowthInTurns()
        let isCapital: Bool = city.isCapital()
        let name: String = city.name.localized()
        let governor: GovernorType? = city.governorType()

        var production: Double = 0
        var productionCost: Int = 0
        var unitType: UnitType?
        var buildingType: BuildingType?
        var wonderType: WonderType?
        var districtType: DistrictType?
        var projectType: ProjectType?

        if let currentBuildableItem = city.currentBuildableItem() {
            switch currentBuildableItem.type {

            case .unit:
                unitType = currentBuildableItem.unitType
                production = currentBuildableItem.production
                productionCost = currentBuildableItem.unitType?.productionCost() ?? 0

            case .building:
                buildingType = currentBuildableItem.buildingType
                production = currentBuildableItem.production
                productionCost = currentBuildableItem.buildingType?.productionCost() ?? 0

            case .wonder:
                wonderType = currentBuildableItem.wonderType
                production = currentBuildableItem.production
                productionCost = currentBuildableItem.wonderType?.productionCost() ?? 0

            case .district:
                districtType = currentBuildableItem.districtType
                production = currentBuildableItem.production
                productionCost = currentBuildableItem.districtType?.productionCost() ?? 0

            case .project:
                projectType = currentBuildableItem.projectType
                production = currentBuildableItem.production
                productionCost = currentBuildableItem.projectType?.productionCost() ?? 0
            }
        }

        return CityLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            health: health, maxHealth: maxHealth, strength: strength, population: population,
            growthInTurns: growthInTurns, maxGrowthInTurns: maxGrowthInTurns, isCapital: isCapital,
            name: name, governor: governor, production: production, productionCost: productionCost,
            unitType: unitType, buildingType: buildingType, wonderType: wonderType, districtType: districtType,
            projectType: projectType
        )
    }
}
