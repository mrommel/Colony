//
//  GameViewModel+Preloading.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.01.22.
//

import SmartAssets
import SmartAILibrary

extension GameViewModel {

    // swiftlint:disable cyclomatic_complexity function_body_length
    public func loadAssets() {

        let allTextureSuffixes: [String] = [
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

        // load assets into image cache
        print("-- pre-load images --")
        let bundle = Bundle.init(for: Textures.self)

        let allTerrainTextureNames = [
            "terrain_desert", "terrain_plains_hills3", "terrain_grass_hills3", "terrain_desert_hills",
            "terrain_tundra", "terrain_desert_hills2", "terrain_tundra2", "terrain_shore",
            "terrain_desert_hills3", "terrain_ocean", "terrain_tundra3", "terrain_snow",
            "terrain_plains", "terrain_snow_hills", "terrain_grass", "terrain_snow_hills2",
            "terrain_tundra_hills", "terrain_plains_hills", "terrain_plains_hills2",
            "terrain_grass_hills", "terrain_snow_hills3", "terrain_grass_hills2"
        ]
        print("- load \(allTerrainTextureNames.count) terrain textures")
        for textureName in allTerrainTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allCoastTextureNames = allTextureSuffixes.map({ "beach\($0)" })
        print("- load \(allCoastTextureNames.count) coast textures")
        for textureName in allCoastTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allRiverTextureNames = [
            "river-mouth-e", "river-n-se", "river-mouth-se", "river-ne", "river-n-ne-se",
            "river-mouth-ne", "river-n", "river-mouth-sw", "river-se", "river-n-ne", "river-mouth-nw",
            "river-ne-se", "river-mouth-w"
        ]
        print("- load \(allRiverTextureNames.count) river textures")
        for textureName in allRiverTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allFeatureTextureNames = [
            "feature-atoll", "feature-lake", "feature-ice5", "feature-ice6",
            "feature-delicateArch", "feature-floodplains", "feature-marsh1",
            "feature-reef", "feature-forest1", "feature-forest2", "feature-marsh2",
            "feature-uluru", "feature-mountEverest", "feature-rainforest1", "feature-rainforest2",
            "feature-rainforest3", "feature-rainforest4", "feature-rainforest5", "feature-rainforest6",
            "feature-rainforest7", "feature-rainforest8", "feature-rainforest9",
            "feature-none", "feature-galapagos", "feature-mountKilimanjaro", "feature-yosemite",
            "feature-greatBarrierReef", "feature-oasis", "feature-pine1",
            "feature-ice1", "feature-ice2", "feature-ice3", "feature-pantanal",
            "feature-mountains1", "feature-mountains2", "feature-mountains3",
            "feature-ice4", "feature-pine1", "feature-pine2", "feature-volcano", "feature-fallout",
            "feature-fuji", "feature-barringCrater", "feature-mesa", "feature-gibraltar",
            "feature-geyser", "feature-potosi", "feature-fountainOfYouth", "feature-lakeVictoria",
            "feature-cliffsOfDover",
            "feature-mountains-range1-1", "feature-mountains-range1-2", "feature-mountains-range1-3",
            "feature-mountains-range2-1", "feature-mountains-range2-2", "feature-mountains-range2-3",
            "feature-mountains-range3-1", "feature-mountains-range3-2", "feature-mountains-range3-3",
            "feature-mountains-range3-4", "feature-mountains-range4-1", "feature-mountains-range4-2",
            "feature-mountains-range4-3", "feature-mountains-range4-4",
            "feature-mountains-n-ne", "feature-mountains-n-nw", "feature-mountains-n",
            "feature-mountains-ne", "feature-mountains-nw", "feature-mountains-n-ne-nw"
        ]
        print("- load \(allFeatureTextureNames.count) feature textures")
        for textureName in allFeatureTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allIceFeatureTextureNames =
            allTextureSuffixes.map({ "feature_ice\($0)" }) +
            allTextureSuffixes.map({ "feature_ice-to-water\($0)" })
        print("- load \(allIceFeatureTextureNames.count) ice textures")
        for textureName in allIceFeatureTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allSnowFeatureTextureNames =
            allTextureSuffixes.map({ "snow\($0)" }) +
            allTextureSuffixes.map({ "snow-to-water\($0)" })
        print("- load \(allSnowFeatureTextureNames.count) snow textures")
        for textureName in allSnowFeatureTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allResourceTextureNames = ResourceType.all.map { $0.textureName() }
        print("- load \(allResourceTextureNames.count) resource and marker textures")
        for textureName in allResourceTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allResourceMarkerTextureNames = ResourceType.all.map { $0.textureMarkerName() }
        for textureName in allResourceMarkerTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allBorderTextureNames =
            allTextureSuffixes.map({ "border-main\($0)" }) +
            allTextureSuffixes.map({ "border-accent\($0)" }) +
            ["border-main-all", "border-accent-all"]
        print("- load \(allBorderTextureNames.count) border textures")
        for textureName in allBorderTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allYieldsTextureNames = [
            // food
            "yield-food-1", "yield-food-2", "yield-food-3", "yield-food-4", "yield-food-5",
            "yield-food-6", "yield-food-7",
            // production
            "yield-production-1", "yield-production-2", "yield-production-3",
            "yield-production-4", "yield-production-5",
            // gold
            "yield-gold-1", "yield-gold-2", "yield-gold-3", "yield-gold-4", "yield-gold-5",
            "yield-gold-6", "yield-gold-7", "yield-gold-8", "yield-gold-9", "yield-gold-10"
        ]
        print("- load \(allYieldsTextureNames.count) yield textures")
        for textureName in allYieldsTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allBoardTextureNames = [
            "board-s-sw", "board-se-s-sw", "board-se-s", "board-se", "board-sw"
        ]
        print("- load \(allBoardTextureNames.count) board textures")
        for textureName in allBoardTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allImprovementTextureNames = (
            ImprovementType.all + [.barbarianCamp, .goodyHut]
        ).flatMap { $0.textureNames() }
        print("- load \(allImprovementTextureNames.count) improvement textures")
        for textureName in allImprovementTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allRoadTextureNames = allTextureSuffixes.map({ "road\($0)" })
        print("- load \(allRoadTextureNames.count) road textures")
        for textureName in allRoadTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allPathTextureNames = [
            "path-n-sw", "path-se-nw", "path-n-nw", "path-se-sw", "path-n-se", "path-ne-s", "path-start-s",
            "path-n-ne", "path-sw-nw", "path-ne-se", "path-start-n", "path-start-sw", "path-se-s",
            "path-start-nw", "path-n-s", "path-start-se", "path-s-nw", "path-ne-sw", "path-start-ne",
            "path-s-sw", "path-ne-nw"
        ]

        print("- load \(allPathTextureNames.count) path textures")
        for textureName in allPathTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allPathOutTextureNames = allPathTextureNames.map { $0 + "-out" }
        print("- load \(allPathOutTextureNames.count) path out textures")
        for textureName in allPathOutTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        let overviewTextureNames = [
            "overview-mountains", "overview-mountains-passive", "overview-hills", "overview-hills-passive",
            "overview-forest", "overview-forest-passive", "overview-city", "overview-city-passive"
        ]
        print("- load \(overviewTextureNames.count) overview textures")
        for textureName in overviewTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
        }

        var unitTextures: Int = 0
        for unitType in UnitType.all {

            if let idleTextures = unitType.idleAtlas?.textures {
                for (index, texture) in idleTextures.enumerated() {
                    ImageCache.shared.add(
                        image: texture,
                        for: "\(unitType.name().lowercased())-idle-\(index)"
                    )

                    unitTextures += 1
                }
            } else {
                print("cant get idle textures of \(unitType.name())")
            }

            ImageCache.shared.add(
                image: bundle.image(forResource: unitType.spriteName),
                for: unitType.spriteName
            )
            ImageCache.shared.add(
                image: bundle.image(forResource: unitType.portraitTexture()),
                for: unitType.portraitTexture()
            )
            ImageCache.shared.add(
                image: bundle.image(forResource: unitType.typeTexture()),
                for: unitType.typeTexture()
            )
            ImageCache.shared.add(
                image: bundle.image(forResource: unitType.typeTemplateTexture()),
                for: unitType.typeTemplateTexture()
            )
        }
        print("- load \(unitTextures) unit textures")

        // populate cache with ui textures
        let textureNames: [String] = [
            "water", "focus-attack1", "focus-attack2", "focus-attack3",
            "focus1", "focus2", "focus3", "focus4", "focus5", "focus6",
            "unit-type-background", "cursor", "top-bar", "grid9-dialog",
            "techInfo-active", "techInfo-disabled", "techInfo-researched", "techInfo-researching",
            "civicInfo-active", "civicInfo-disabled", "civicInfo-researched", "civicInfo-researching",
            "notification-bagde", "notification-bottom", "notification-top", "grid9-button-active",
            "grid9-button-clicked", "grid9-button-disabled", "grid9-row",
            "banner", "science-progress", "culture-progress",
            "header-bar-button", "grid9-progress", "leader-bagde",
            "header-bar-left", "header-bar-right", "city-banner", "grid9-button-district-active",
            "grid9-button-district", "grid9-button-highlighted", "questionmark", "tile-purchase-active",
            "tile-purchase-disabled", "tile-citizen-normal", "tile-citizen-selected", "tile-citizen-forced",
            "tile-districtAvailable", "tile-wonderAvailable", "tile-notAvailable",
            "city-canvas", "pantheon-background", "turns", "unit-banner", "combat-view",
            "unit-strength-background", "unit-strength-frame", "unit-strength-bar", "loyalty",
            "map-overview-canvas", "map-lens", "map-lens-active", "map-marker", "map-options",
            "unit-canvas", "menu", "menu-background", "speed-standard", "city-states",
            "jump-to", "hint",
            "suzerain-cultural", "suzerain-inactive", "suzerain-industrial", "suzerain-militaristic",
            "suzerain-religious", "suzerain-scientific", "suzerain-trade"
        ]
        print("- load \(textureNames.count) misc textures")
        for textureName in textureNames {
            if !ImageCache.shared.exists(key: textureName) {
                // load from SmartAsset package
                ImageCache.shared.add(
                    image: bundle.image(forResource: textureName),
                    for: textureName
                )
            }
        }

        let buttonTextureNames = NotificationType.all.map { $0.iconTexture() }
        print("- load \(buttonTextureNames.count) button textures")
        for textureName in buttonTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let globeTextureNames = Array(0...90).map { "globe\($0)" }
        print("- load \(globeTextureNames.count) globe textures")
        for textureName in globeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let cultureProgressTextureNames = Array(0...100).map { "culture_progress_\($0)" }
        print("- load \(cultureProgressTextureNames.count) culture progress textures")
        for textureName in cultureProgressTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let scienceProgressTextureNames = Array(0...100).map { "science_progress_\($0)" }
        print("- load \(scienceProgressTextureNames.count) science progress textures")
        for textureName in scienceProgressTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let attackerHealthTextureNames = Array(0...25).map { "attacker_health\($0)" }
        print("- load \(attackerHealthTextureNames.count) attacker health textures")
        for textureName in attackerHealthTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let defenderHealthTextureNames = Array(0...25).map { "defender_health\($0)" }
        print("- load \(defenderHealthTextureNames.count) defender health textures")
        for textureName in defenderHealthTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let headerTextureNames: [String] = HeaderButtonType.allCases
            .flatMap { [$0.iconTexture(for: false), $0.iconTexture(for: true)] }
            + ["header-alert"]
        print("- load \(headerTextureNames.count) header textures")
        for textureName in headerTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let cityProgressTextureNames = Array(0...20).map { "linear-progress-\($0 * 5)" }
        print("- load \(cityProgressTextureNames.count) city progress textures")
        for textureName in cityProgressTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let cityTextureNames = [
            "city-ancient-small-noWalls", "city-ancient-medium-noWalls", "city-ancient-large-noWalls",
            "city-ancient-small-ancientWalls", "city-ancient-medium-ancientWalls", "city-ancient-large-ancientWalls",
            "city-medieval-small-noWalls", "city-medieval-medium-noWalls", "city-medieval-large-noWalls",
            "city-medieval-small-ancientWalls", "city-medieval-medium-ancientWalls", "city-medieval-large-ancientWalls",
            "city-medieval-small-medievalWalls", "city-medieval-medium-medievalWalls", "city-medieval-large-medievalWalls"
            // add more assets here
        ]
        print("- load \(cityTextureNames.count) city textures")
        for textureName in cityTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let commandTextureNames = CommandType.all.map { $0.iconTexture() }
        print("- load \(commandTextureNames.count) command type textures")
        for textureName in commandTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let commandButtonTextureNames = CommandType.all.map { $0.buttonTexture() } + ["command-button-list"]
        print("- load \(commandButtonTextureNames.count) command button textures")
        for textureName in commandButtonTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let cityCommandButtonTextureNames = CityCommandType.all.map { $0.buttonTexture() }
        print("- load \(cityCommandButtonTextureNames.count) city command textures")
        for textureName in cityCommandButtonTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let policyCardTextureNames = [
            "policyCard-slot", "policyCard-military", "policyCard-economic", "policyCard-diplomatic",
            "policyCard-wildcard", "policyCard-darkAge"
        ]
        print("- load \(policyCardTextureNames.count) policy card textures")
        for textureName in policyCardTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let governmentStateBackgroundTextureNames = GovernmentState.all.map { $0.backgroundTexture() }
        print("- load \(governmentStateBackgroundTextureNames.count) government state background textures")
        for textureName in governmentStateBackgroundTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let governmentTextureNames = GovernmentType.all.map { $0.iconTexture() }
        print("- load \(governmentTextureNames.count) government textures")
        for textureName in governmentTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let governmentAmbientTextureNames = GovernmentType.all.map { $0.ambientTexture() }
        print("- load \(governmentAmbientTextureNames.count) ambient textures")
        for textureName in governmentAmbientTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let yieldTextureNames = YieldType.all.map { $0.iconTexture() }
        print("- load \(yieldTextureNames.count) yield textures")
        for textureName in yieldTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let yieldBackgroundTextureNames = YieldType.all.map { $0.backgroundTexture() }
        print("- load \(yieldBackgroundTextureNames.count) yield background textures")
        for textureName in yieldBackgroundTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let techTextureNames = ([TechType.none] + TechType.all).map { $0.iconTexture() }
        print("- load \(techTextureNames.count) tech type textures")
        for textureName in techTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let civicTextureNames = ([CivicType.none] + CivicType.all).map { $0.iconTexture() }
        print("- load \(civicTextureNames.count) civic type textures")
        for textureName in civicTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let buildTypeTextureNames = BuildType.all.map { $0.iconTexture() }
        print("- load \(buildTypeTextureNames.count) build type textures")
        for textureName in buildTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let buildingTypeTextureNames = BuildingType.all.map { $0.iconTexture() }
        print("- load \(buildingTypeTextureNames.count) building type textures")
        for textureName in buildingTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let wonderTypeTextureNames = WonderType.all.map { $0.iconTexture() }
        print("- load \(wonderTypeTextureNames.count) wonder type textures")
        for textureName in wonderTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let wonderTextureNames = WonderType.all.map { $0.textureName() }
        print("- load \(wonderTextureNames.count) wonder textures")
        for textureName in wonderTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let wonderBuildingTextureNames = WonderType.all.map { $0.buildingTextureName() }
        print("- load \(wonderBuildingTextureNames.count) wonder building textures")
        for textureName in wonderBuildingTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let districtTypeTextureNames = DistrictType.all.map { $0.iconTexture() }
        print("- load \(districtTypeTextureNames.count) district type textures")
        for textureName in districtTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let districtTextureNames = DistrictType.all.map { $0.textureName() }
        print("- load \(districtTextureNames.count) district textures")
        for textureName in districtTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let districtBuildingTextureNames = DistrictType.all.map { $0.buildingTextureName() }
        print("- load \(districtBuildingTextureNames.count) district building textures")
        for textureName in districtBuildingTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let leaderTypeTextureNames = LeaderType.all.map { $0.iconTexture() }  + ["leader-random"]
        print("- load \(leaderTypeTextureNames.count) leader type textures")
        for textureName in leaderTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let civilizationTypeTextureNames = CivilizationType.all.map { $0.iconTexture() }
        print("- load \(civilizationTypeTextureNames.count) civilization type textures")
        for textureName in civilizationTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let pantheonTypeTextureNames = PantheonType.all.map { $0.iconTexture() }
        print("- load \(pantheonTypeTextureNames.count) pantheon type textures")
        for textureName in pantheonTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let religionTypeTextureNames = ReligionType.all.map { $0.iconTexture() }
        print("- load \(religionTypeTextureNames.count) religion type textures")
        for textureName in religionTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let beliefTypeTextureNames = BeliefMainType.all.map { $0.iconTexture() }
        print("- load \(beliefTypeTextureNames.count) belief type textures")
        for textureName in beliefTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let promotionTextureNames = UnitPromotionType.all.map { $0.iconTexture() }
        print("- load \(promotionTextureNames.count) promotion type textures")
        for textureName in promotionTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let promotionStateBackgroundTextureNames = PromotionState.all.map { $0.iconTexture() }
        print("- load \(promotionStateBackgroundTextureNames.count) promotion state textures")
        for textureName in promotionStateBackgroundTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let governorPortraitTextureNames = GovernorType.all.map { $0.portraitTexture() }
        print("- load \(governorPortraitTextureNames.count) governor portrait textures")
        for textureName in governorPortraitTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let victoryTypesTextureNames = VictoryType.all.map { $0.iconTexture() } +
            ["victoryType-overall", "victoryType-score"]
        print("- load \(victoryTypesTextureNames.count) victory textures")
        for textureName in victoryTypesTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let dedicationTypeTextureNames = DedicationType.all.map { $0.iconTexture() }
        print("- load \(dedicationTypeTextureNames.count) dedication textures")
        for textureName in dedicationTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let momentTypeTextureNames: [String] = (
            MomentType.all.map { $0.iconTexture() } +
            FeatureType.naturalWonders.map { MomentType.discoveryOfANaturalWonder(naturalWonder: $0).iconTexture() } +
            GovernmentType.all.map { MomentType.firstTier1Government(governmentType: $0).iconTexture() } +
            EraType.all.map { MomentType.firstCivicOfNewEra(eraType: $0).iconTexture() } +
            EraType.all.map { MomentType.firstTechnologyOfNewEra(eraType: $0).iconTexture() }
        ).uniqued()
        print("- load \(momentTypeTextureNames.count) moment textures")
        for textureName in momentTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let handicapTypeTextureNames = HandicapType.all.map { $0.iconTexture() }
        print("- load \(handicapTypeTextureNames.count) handicap textures")
        for textureName in handicapTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let cityStateTypeTextureNames = CityStateType.all.map { $0.iconTexture() }
        print("- load \(cityStateTypeTextureNames.count) city state textures")
        for textureName in cityStateTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let cityStateEnvoysTextureNames = CityStateType.all.map { $0.envoysTexture() }
        print("- load \(cityStateEnvoysTextureNames.count) city state envoys textures")
        for textureName in cityStateEnvoysTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let intelReportTypeTextureNames = IntelReportType.all.map { $0.iconTexture() }
        print("- load \(intelReportTypeTextureNames.count) intel report type textures")
        for textureName in intelReportTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        print("-- all textures loaded --")

        self.bottomLeftBarViewModel.preloadAssets()
        self.bottomLeftBarViewModel.showSpinningGlobe()
    }
}
