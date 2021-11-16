//
//  Textures.swift
//  SmartAssets
//
//  Created by Michael Rommel on 28.11.20.
//

import SmartAILibrary

// swiftlint:disable:next type_body_length
public class Textures {

    private static let allTextureSuffixes: [String] = [
        "-n", "-n-ne", "-n-ne-nw", "-n-ne-s", "-n-ne-s-nw", "-n-ne-s-sw", "-n-ne-s-sw-nw",
        "-n-ne-se", "-n-ne-se-nw", "-n-ne-se-s", "-n-ne-se-s-nw", "-n-ne-se-s-sw",
        "-n-ne-se-s-sw-nw", "-n-ne-se-sw", "-n-ne-se-sw-nw", "-n-ne-sw", "-n-ne-sw-nw",
        "-n-nw", "-n-s", "-n-s-nw", "-n-s-sw", "-n-s-sw-nw", "-n-se", "-n-se-nw",
        "-n-se-s", "-n-se-s-nw", "-n-se-s-sw", "-n-se-s-sw-nw", "-n-se-sw", "-n-se-sw-nw",
        "-n-sw", "-n-sw-nw", "-ne", "-ne-nw", "-ne-s", "-ne-s-nw", "-ne-s-sw",
        "-ne-s-sw-nw", "-ne-se", "-ne-se-nw", "-ne-se-s", "-ne-se-s-nw", "-ne-se-s-sw",
        "-ne-se-s-sw-nw", "-ne-se-sw", "-ne-se-sw-nw", "-ne-sw", "-ne-sw-nw", "-nw", "-s",
        "-s-nw", "-s-sw", "-s-sw-nw", "-se", "-se-nw", "-se-s", "-se-s-nw", "-se-s-sw",
        "-se-s-sw-nw", "-se-sw", "-se-sw-nw", "-sw", "-sw-nw"
    ]

    let game: GameModel?

    public let allTerrainTextureNames: [String]
    public let allFeatureTextureNames: [String]
    public let allSnowFeatureTextureNames: [String]
    public let allIceFeatureTextureNames: [String]
    public let allCoastTextureNames: [String]
    public let allRiverTextureNames: [String]
    public let allResourceTextureNames: [String]
    public let allResourceMarkerTextureNames: [String]
    public let allBorderTextureNames: [String]
    public let allYieldsTextureNames: [String]
    public let allBoardTextureNames: [String]
    public let allImprovementTextureNames: [String]
    public let allRoadTextureNames: [String]
    public let allPathTextureNames: [String]
    public let allPathOutTextureNames: [String]
    public let overviewTextureNames: [String]

    public let buttonTextureNames: [String]
    public let globeTextureNames: [String]
    public let cultureProgressTextureNames: [String]
    public let scienceProgressTextureNames: [String]
    public let attackerHealthTextureNames: [String]
    public let defenderHealthTextureNames: [String]
    public let headerTextureNames: [String]
    public let cityProgressTextureNames: [String]
    public let cityTextureNames: [String]

    public let commandTextureNames: [String]
    public let commandButtonTextureNames: [String]
    public let cityCommandButtonTextureNames: [String]
    public let policyCardTextureNames: [String]
    public let governmentStateBackgroundTextureNames: [String]
    public let governmentTextureNames: [String]
    public let governmentAmbientTextureNames: [String]
    public let yieldTextureNames: [String]
    public let yieldBackgroundTextureNames: [String]
    public let techTextureNames: [String]
    public let civicTextureNames: [String]
    public let buildTypeTextureNames: [String]
    public let buildingTypeTextureNames: [String]
    public let wonderTypeTextureNames: [String]
    public let districtTypeTextureNames: [String]
    public let leaderTypeTextureNames: [String]
    public let civilizationTypeTextureNames: [String]
    public let pantheonTypeTextureNames: [String]
    public let religionTypeTextureNames: [String]
    public let beliefTypeTextureNames: [String]
    public let promotionTextureNames: [String]
    public let promotionStateBackgroundTextureNames: [String]
    public let governorPortraitTextureNames: [String]
    public let victoryTypesTextureNames: [String]

    public init(game: GameModel?) {

        self.game = game
        self.allTerrainTextureNames = [
            "terrain_desert", "terrain_plains_hills3", "terrain_grass_hills3", "terrain_desert_hills",
            "terrain_tundra", "terrain_desert_hills2", "terrain_tundra2", "terrain_shore",
            "terrain_desert_hills3", "terrain_ocean", "terrain_tundra3", "terrain_snow",
            "terrain_plains", "terrain_snow_hills", "terrain_grass", "terrain_snow_hills2",
            "terrain_tundra_hills", "terrain_plains_hills", "terrain_plains_hills2",
            "terrain_grass_hills", "terrain_snow_hills3", "terrain_grass_hills2"
        ]

        self.allFeatureTextureNames = [
            "feature_atoll", "feature_lake", "feature_mountains_ne_sw", "feature_ice5",
            "feature_rainforest1", "feature_delicateArch", "feature_mountains_nw", "feature_ice6",
            "feature_rainforest2", "feature_floodplains", "feature_mountains_se", "feature_marsh1",
            "feature_mountains_se_nw", "feature_reef", "feature_forest1", "feature_marsh2",
            "feature_mountains_sw", "feature_uluru", "feature_forest2", "feature_mountEverest",
            "feature_none", "feature_galapagos", "feature_mountKilimanjaro", "feature_yosemite",
            "feature_greatBarrierReef", "feature_mountains1", "feature_oasis1", "feature_ice1",
            "feature_mountains2", "feature_oasis2", "feature_ice2", "feature_mountains3",
            "feature_pantanal", "feature_ice3", "feature_pine1", "feature_mountains_ne",
            "feature_ice4", "feature_pine1", "feature_pine2", "feature_volcano", "feature_fallout",
            "feature_fuji", "feature_barringCrater", "feature_mesa", "feature_gibraltar",
            "feature_geyser", "feature_potosi", "feature_fountainOfYouth", "feature_lakeVictoria"
        ]

        self.allSnowFeatureTextureNames = Textures.allTextureSuffixes.map({ "snow\($0)" }) +
            Textures.allTextureSuffixes.map({ "snow-to-water\($0)" })

        self.allIceFeatureTextureNames = Textures.allTextureSuffixes.map({ "feature_ice\($0)" }) +
            Textures.allTextureSuffixes.map({ "feature_ice-to-water\($0)" })

        self.allCoastTextureNames = Textures.allTextureSuffixes.map({ "beach\($0)" })

        self.allRiverTextureNames = [
            "river-mouth-e", "river-n-se", "river-mouth-se", "river-ne", "river-n-ne-se",
            "river-mouth-ne", "river-n", "river-mouth-sw", "river-se", "river-n-ne", "river-mouth-nw",
            "river-ne-se", "river-mouth-w"
        ]

        self.allResourceTextureNames = ResourceType.all.map { $0.textureName() }

        self.allResourceMarkerTextureNames = ResourceType.all.map { $0.textureMarkerName() }

        self.allBorderTextureNames =
            Textures.allTextureSuffixes.map({ "border-main\($0)" }) +
            Textures.allTextureSuffixes.map({ "border-accent\($0)" }) +
            ["border-main-all", "border-accent-all"]

        self.allYieldsTextureNames = [
            // 0
            "yield-0-0-1", "yield-0-0-2", "yield-0-0-3",
            "yield-0-1-0", "yield-0-1-1", "yield-0-1-2", "yield-0-1-3",
            "yield-0-2-0",
            // 1
            "yield-1-0-0", "yield-1-0-1", "yield-1-0-2", "yield-1-0-3",
            "yield-1-1-0", "yield-1-1-1", "yield-1-1-2", "yield-1-1-3",
            "yield-1-2-0", "yield-1-2-1", "yield-1-2-2", "yield-1-2-3",
            "yield-1-3-0", "yield-1-3-1", "yield-1-3-2", "yield-1-3-3",
            "yield-1-4-0",
            "yield-1-5-0",
            // 2
            "yield-2-0-0", "yield-2-0-1", "yield-2-0-2", "yield-2-0-3",
            "yield-2-1-0", "yield-2-1-1", "yield-2-1-2", "yield-2-1-3",
            "yield-2-2-0", "yield-2-2-1", "yield-2-2-2", "yield-2-2-3",
            "yield-2-3-0",
            "yield-2-4-0",
            // 3
            "yield-3-0-0", "yield-3-0-1", "yield-3-0-2", "yield-3-0-3",
            "yield-3-1-0", "yield-3-1-1", "yield-3-1-2", "yield-3-1-3",
            "yield-3-2-0", "yield-3-2-1", "yield-3-2-2", "yield-3-2-3",
            // 4
            "yield-4-0-0",
            "yield-4-1-0", "yield-4-1-1", "yield-4-1-2", "yield-4-1-3",
            "yield-4-2-0", "yield-4-2-1", "yield-4-2-2", "yield-4-2-3", "yield-4-2-4",
            // 5
            "yield-5-0-0", "yield-5-0-1", "yield-5-0-2", "yield-5-0-3",
            "yield-5-1-0", "yield-5-1-1", "yield-5-1-2",
            "yield-5-2-0",
            "yield-5-3-0",
            // 6
            "yield-6-0-0", "yield-6-0-1",
            "yield-6-1-0", "yield-6-1-1",
            // 7
            "yield-7-0-0"
        ]

        self.allBoardTextureNames = ["board-s-sw", "board-se-s-sw", "board-se-s", "board-se", "board-sw"]

        self.allImprovementTextureNames = (ImprovementType.all + [.barbarianCamp, .goodyHut]).flatMap { $0.textureNames() }
        self.allRoadTextureNames = Textures.allTextureSuffixes.map({ "road\($0)" })

        self.allPathTextureNames = [
            "path-n-sw", "path-se-nw", "path-n-nw", "path-se-sw", "path-n-se", "path-ne-s", "path-start-s",
            "path-n-ne", "path-sw-nw", "path-ne-se", "path-start-n", "path-start-sw", "path-se-s",
            "path-start-nw", "path-n-s", "path-start-se", "path-s-nw", "path-ne-sw", "path-start-ne",
            "path-s-sw", "path-ne-nw"
        ]
        self.allPathOutTextureNames = self.allPathTextureNames.map { $0 + "-out" }
        self.overviewTextureNames = [
            "overview-mountains", "overview-mountains-passive", "overview-hills", "overview-hills-passive",
            "overview-forest", "overview-forest-passive", "overview-city", "overview-city-passive"
        ]

        self.buttonTextureNames = NotificationType.all.map { $0.iconTexture() }
        self.globeTextureNames = Array(0...90).map { "globe\($0)" }
        self.cultureProgressTextureNames = Array(0...100).map { "culture_progress_\($0)" }
        self.scienceProgressTextureNames = Array(0...100).map { "science_progress_\($0)" }
        self.attackerHealthTextureNames = Array(0...25).map { "attacker_health\($0)" }
        self.defenderHealthTextureNames = Array(0...25).map { "defender_health\($0)" }
        self.headerTextureNames = [
            "header-button-science-active", "header-button-science-disabled",
            "header-button-culture-active", "header-button-culture-disabled",
            "header-button-government-active", "header-button-government-disabled",
            "header-button-religion-active", "header-button-religion-disabled",
            "header-button-greatPeople-active", "header-button-greatPeople-disabled",
            "header-button-log-active", "header-button-log-disabled",
            "header-button-tradeRoutes-active", "header-button-tradeRoutes-disabled",
            "header-button-governors-active", "header-button-governors-disabled",
            "header-button-ranking-active", "header-button-ranking-disabled",
            "header-alert"
        ]
        self.cityProgressTextureNames = Array(0...20).map { "linear-progress-\($0 * 5)" }
        self.cityTextureNames = [
            "city-ancient-small-noWalls", "city-ancient-medium-noWalls", "city-ancient-large-noWalls",
            "city-ancient-small-ancientWalls", "city-ancient-medium-ancientWalls", "city-ancient-large-ancientWalls",
            "city-medieval-small-noWalls", "city-medieval-medium-noWalls", "city-medieval-large-noWalls",
            "city-medieval-small-ancientWalls", "city-medieval-medium-ancientWalls", "city-medieval-large-ancientWalls",
            "city-medieval-small-medievalWalls", "city-medieval-medium-medievalWalls", "city-medieval-large-medievalWalls"
            // add more assets here
        ]

        self.commandTextureNames = CommandType.all.map { $0.iconTexture() }
        self.commandButtonTextureNames = CommandType.all.map { $0.buttonTexture() } + ["command-button-list"]
        self.cityCommandButtonTextureNames = CityCommandType.all.map { $0.buttonTexture() }
        self.policyCardTextureNames = [
            "policyCard-slot", "policyCard-military", "policyCard-economic", "policyCard-diplomatic",
            "policyCard-wildcard"
        ]
        self.governmentStateBackgroundTextureNames = GovernmentState.all.map { $0.backgroundTexture() }
        self.governmentTextureNames = GovernmentType.all.map { $0.iconTexture() }
        self.governmentAmbientTextureNames = GovernmentType.all.map { $0.ambientTexture() }
        self.yieldTextureNames = YieldType.all.map { $0.iconTexture() }
        self.yieldBackgroundTextureNames = YieldType.all.map { $0.backgroundTexture() }
        self.techTextureNames = TechType.all.map { $0.iconTexture() }
        self.civicTextureNames = CivicType.all.map { $0.iconTexture() }
        self.buildTypeTextureNames = BuildType.all.map { $0.iconTexture() }
        self.buildingTypeTextureNames = BuildingType.all.map { $0.iconTexture() }
        self.wonderTypeTextureNames = WonderType.all.map { $0.iconTexture() }
        self.districtTypeTextureNames = DistrictType.all.map { $0.iconTexture() }
        self.leaderTypeTextureNames = LeaderType.all.map { $0.iconTexture() }  + ["leader-random"]
        self.civilizationTypeTextureNames = CivilizationType.all.map { $0.iconTexture() }
        self.pantheonTypeTextureNames = PantheonType.all.map { $0.iconTexture() }
        self.religionTypeTextureNames = ReligionType.all.map { $0.iconTexture() }
        self.beliefTypeTextureNames = BeliefMainType.all.map { $0.iconTexture() }
        self.promotionTextureNames = UnitPromotionType.all.map { $0.iconTexture() }
        self.promotionStateBackgroundTextureNames = PromotionState.all.map { $0.iconTexture() }
        self.governorPortraitTextureNames = GovernorType.all.map { $0.portraitTexture() }

        self.victoryTypesTextureNames = [
            "victoryType-science", "victoryType-religion", "victoryType-domination",
            "victoryType-diplomatic", "victoryType-culture", "victoryType-score",
            "victoryType-overall"
        ]
    }

    public func terrainTexture(at point: HexPoint) -> String {

        guard let game = self.game else {
            fatalError("cant get game")
        }

        guard let tile = game.tile(at: point) else {
            fatalError("cant get tile")
        }

        var textureName = ""
        if let coastTexture = self.coastTexture(at: point) {
            textureName = coastTexture
        } else {
            if tile.hasHills() {
                textureName = tile.terrain().textureNamesHills().item(from: point)
            } else {
                textureName = tile.terrain().textureNames().item(from: point)
            }
        }

        return textureName
    }

    public func coastTexture(at point: HexPoint) -> String? {

        guard let game = self.game else {
            fatalError("cant get game")
        }

        if let tile = game.tile(at: point) {
            if tile.terrain().isLand() {
                return nil
            }
        }

        var texture = "beach" // "beach-n-ne-se-s-sw-nw"
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)

            if let neighborTile = game.tile(at: neighbor) {

                if neighborTile.terrain().isLand() {
                    texture += ("-" + direction.short())
                }
            }
        }

        if texture == "beach" {
            return nil
        }

        return texture
    }

    public func snowTexture(at point: HexPoint) -> String? {

        guard let game = self.game else {
            fatalError("cant get game")
        }

        var texture = "snow" // "snow-n-ne-se-s-sw-nw"

        if let tile = game.tile(at: point) {
            if tile.terrain().isWater() {
                texture = "snow-to-water"
            }
        }

        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)

            if let neighborTile = game.tile(at: neighbor) {

                if neighborTile.terrain() == .snow {
                    texture += ("-" + direction.short())
                }
            }
        }

        if texture == "snow" || texture == "snow-to-water" {
            return nil
        }

        return texture
    }

    public func mountainTexture(at point: HexPoint) -> String? {

        guard let game = self.game else {
            fatalError("cant get game")
        }

        var texture = "mountains" // "mountains-n-ne-se-s-sw-nw"

        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)

            if let neighborTile = game.tile(at: neighbor) {

                if neighborTile.has(feature: .mountains) {
                    texture += ("-" + direction.short())
                }
            }
        }

        if texture == "mountains" {
            return nil
        }

        // limit to only some existing textures
        if texture != "mountains-n-ne" &&
            texture != "mountains-n" &&
            texture != "mountains-ne" &&
            texture != "mountains-n-nw" &&
            texture != "mountains-nw" {

            return nil
        }

        return texture
    }

    public func iceTexture(at point: HexPoint) -> String? {

        guard let game = self.game else {
            fatalError("cant get game")
        }

        var texture = "feature_ice" // "snow-n-ne-se-s-sw-nw"

        if let tile = game.tile(at: point) {
            if tile.terrain().isWater() {
                texture = "feature_ice-to-water"
            }
        }

        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)

            if let neighborTile = game.tile(at: neighbor) {

                if neighborTile.has(feature: .ice) {
                    texture += ("-" + direction.short())
                }
            }
        }

        if texture == "feature_ice" || texture == "feature_ice-to-water" {
            return nil
        }

        return texture
    }

    public func featureTexture(for tile: AbstractTile, neighborTiles: [HexDirection: AbstractTile?]) -> String? {

        let feature: FeatureType = tile.feature()

        if feature == .none {
            return nil
        }

        let textureName: String
        if tile.terrain() == .tundra && feature == .forest {
            textureName = ["feature_pine1", "feature_pine2"].item(from: tile.point)
        } else if feature == .mountains {

            let mountainsN = (neighborTiles[.north]??.feature() ?? .none) == .mountains
            let mountainsNE = (neighborTiles[.northeast]??.feature() ?? .none) == .mountains
            let mountainsSE = (neighborTiles[.southeast]??.feature() ?? .none) == .mountains
            let mountainsS = (neighborTiles[.south]??.feature() ?? .none) == .mountains
            let mountainsSW = (neighborTiles[.southwest]??.feature() ?? .none) == .mountains
            let mountainsNW = (neighborTiles[.northwest]??.feature() ?? .none) == .mountains

            if !mountainsN && mountainsNE && !mountainsSE && !mountainsS && !mountainsSW && !mountainsNW {
                textureName = "feature_mountains_ne"
            } else if !mountainsN && !mountainsNE && !mountainsSE && !mountainsS && mountainsSW && !mountainsNW {
                textureName = "feature_mountains_sw"
            } else if !mountainsN && mountainsNE && !mountainsSE && !mountainsS && mountainsSW && !mountainsNW {
                textureName = "feature_mountains_ne_sw"
            } else if !mountainsN && !mountainsNE && mountainsSE && !mountainsS && !mountainsSW && !mountainsNW {
                textureName = "feature_mountains_se"
            } else if !mountainsN && !mountainsNE && !mountainsSE && !mountainsS && !mountainsSW && mountainsNW {
                textureName = "feature_mountains_nw"
            } else if !mountainsN && !mountainsNE && mountainsSE && !mountainsS && !mountainsSW && mountainsNW {
                textureName = "feature_mountains_se_nw"
            } else {
                textureName = feature.textureNames().item(from: tile.point)
            }
        } else {
            textureName = feature.textureNames().item(from: tile.point)
        }

        return textureName
    }

    public func riverTexture(at point: HexPoint) -> String? {

        guard let game = self.game else {
            fatalError("cant get game")
        }

        guard let tile = game.tile(at: point) else {
            return nil
        }

        if !tile.isRiver() {

            // river deltas can be at ocean only
            if tile.terrain() == .shore || tile.terrain() == .ocean {

                let southwestNeightbor = point.neighbor(in: .southwest)
                if let southwestTile = game.tile(at: southwestNeightbor) {

                    // 1. river end west
                    if southwestTile.isRiverInNorth() {
                        return "river-mouth-w"
                    }

                    // 2. river end south west
                    if southwestTile.isRiverInSouthEast() {
                        return "river-mouth-sw"
                    }
                }

                let northwestNeightbor = point.neighbor(in: .northwest)
                if let northwestTile = game.tile(at: northwestNeightbor) {

                    // 3
                    if northwestTile.isRiverInNorthEast() {
                        return "river-mouth-nw"
                    }
                }

                let northNeightbor = point.neighbor(in: .north)
                if let northTile = game.tile(at: northNeightbor) {

                    // 4
                    if northTile.isRiverInSouthEast() {
                        return "river-mouth-ne"
                    }
                }

                let southeastNeightbor = point.neighbor(in: .southeast)
                if let southeastTile = game.tile(at: southeastNeightbor) {

                    // 5
                    if southeastTile.isRiverInNorth() {
                        return "river-mouth-e"
                    }
                }

                let southNeightbor = point.neighbor(in: .south)
                if let southTile = game.tile(at: southNeightbor) {

                    // 6
                    if southTile.isRiverInNorthEast() {
                        return "river-mouth-se"
                    }
                }
            }

            return nil
        }

        var texture = "river" // "river-n-ne-se-s-sw-nw"
        for flow in FlowDirection.all {

            if tile.isRiverIn(flow: flow) {
                texture += ("-" + flow.short)
            }
        }

        if texture == "river" {
            return nil
        }

        return texture
    }

    public func borderMainTexture(at point: HexPoint, in area: HexArea) -> String? {

        var textureName = "border-main"

        if !area.contains(where: { $0 == point.neighbor(in: .north) }) {
            textureName += "-n"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .northeast) }) {
            textureName += "-ne"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .southeast) }) {
            textureName += "-se"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .south) }) {
            textureName += "-s"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .southwest) }) {
            textureName += "-sw"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .northwest) }) {
            textureName += "-nw"
        }

        if textureName == "border-main" {
            return "border-main-all"
        }

        return textureName
    }

    public func borderAccentTexture(at point: HexPoint, in area: HexArea) -> String? {

        var textureName = "border-accent"

        if !area.contains(where: { $0 == point.neighbor(in: .north) }) {
            textureName += "-n"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .northeast) }) {
            textureName += "-ne"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .southeast) }) {
            textureName += "-se"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .south) }) {
            textureName += "-s"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .southwest) }) {
            textureName += "-sw"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .northwest) }) {
            textureName += "-nw"
        }

        if textureName == "border-accent" {
            return "border-accent-all"
        }

        return textureName
    }

    public func yieldTexture(for yields: Yields) -> String? {

        let food = Int(yields.food)
        let production = Int(yields.production)
        let gold = Int(yields.gold)

        if food == 0 && production == 0 && gold == 0 {
            return nil
        }

        return "yield-\(food)-\(production)-\(gold)"
    }

    public func calderaTexure(at hex: HexPoint) -> String? {

        guard let game = self.game else {
            fatalError("cant get gameModel")
        }

        let calderaIsSouth = hex.y == game.mapSize().height() - 1 //self.isCalderaSouth(at: hex)
        let calderaIsEast = hex.x == game.mapSize().width() - 1 // self.isCalderaEast(at: hex)

        if calderaIsSouth || calderaIsEast {
            if calderaIsSouth && calderaIsEast {
                return "board-se-s-sw"
            }

            if calderaIsSouth {
                return "board-s-sw"
            }

            if hex.y % 2 == 1 {
                return "board-se"
            }

            return "board-se-s"
        }

        if hex.x == 0 && hex.y % 2 == 1 {
            return "board-sw"
        }

        return nil
    }

    public func roadTexture(at point: HexPoint) -> String? {

        guard let gameModel = self.game else {
            fatalError("cant get gameModel")
        }

        if let tile = gameModel.tile(at: point) {
            if tile.route() == .none {
                return nil
            }
        }

        var texture = "road" // "road-n-ne-se-s-sw-nw"
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)

            if let neighborTile = gameModel.tile(at: neighbor) {

                if neighborTile.route() != .none {
                    texture += ("-" + direction.short())
                }
            }
        }

        if texture == "road" {
            return nil
        }

        return texture
    }
}
