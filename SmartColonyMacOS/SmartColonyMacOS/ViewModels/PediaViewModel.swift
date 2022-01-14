//
//  PediaViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 06.08.21.
//

import SmartAssets
import Cocoa
import SmartAILibrary
import SmartMacOSUILibrary

enum PediaCategory {

    case terrains
    case features
    case resources

    // leaders
    // civilizations

    case units
    case buildings
    case districts
    case wonders
    case improvements

    case techs
    case civics

    // governments
    // policies

    // religions
    // pantheons

    static var all: [PediaCategory] = [
        .terrains, .features, .resources,
        .units, .buildings, .districts, .wonders, .improvements,
        .techs, .civics
    ]

    func title() -> String {

        switch self {

        case .terrains:
            return "Terrains"
        case .features:
            return "Features"
        case .resources:
            return "Resources"

        case .units:
            return "Units"
        case .buildings:
            return "Buildings"
        case .districts:
            return "Districts"
        case .wonders:
            return "Wonders"
        case .improvements:
            return "Improvements"

        case .techs:
            return "Techs"
        case .civics:
            return "Civics"
        }
    }
}

class PediaCategoryViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()
    let category: PediaCategory

    init(category: PediaCategory) {

        self.category = category
    }

    func title() -> String {

        return self.category.title()
    }
}

extension PediaCategoryViewModel: Hashable {

    static func == (lhs: PediaCategoryViewModel, rhs: PediaCategoryViewModel) -> Bool {

        return lhs.category == rhs.category
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.category)
    }
}

class PediaDetailViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    @Published
    var title: String

    @Published
    var summary: String

    @Published
    var detail: String

    private let imageName: String

    init(terrain: TerrainType) {

        self.title = terrain.name()
        let summaryText = "Base terrain of the \(terrain.domain()) domain."
        self.summary = summaryText

        let detailText = "Yields: \(terrain.yields().food) [Food] Food, \(terrain.yields().production) " +
            "[Production] Production and \(terrain.yields().gold) Gold"
        self.detail = detailText
        self.imageName = terrain.textureNames().first ?? "no_image" // add default
    }

    init(feature: FeatureType) {

        self.title = feature.name()
        self.summary = "Terrain feature that can be found on ???"
        self.detail = "Yields: \(feature.yields().food) Food, \(feature.yields().production) " +
            "Production and \(feature.yields().gold) Gold"
        self.imageName = feature.textureNames().first ?? "no_image" // add default
    }

    init(resource: ResourceType) {

        self.title = resource.name()
        self.summary = "Resource that can be found on ???"
        self.detail = "Yields: \(resource.yields().food) Food, \(resource.yields().production) " +
            "Production and \(resource.yields().gold) Gold"
        self.imageName = resource.textureName()
    }

    init(unit: UnitType) {

        self.title = unit.name()
        self.summary = "Unit of class \(unit.unitClass().name())"
        var detailText = "Effects: \n"
        unit.effects().forEach { detailText += ("* " + $0 + "\n") }
        self.detail = detailText
        self.imageName = unit.portraitTexture()
    }

    init(building: BuildingType) {

        self.title = building.name()

        var requiredText = ""
        if let requiredTech = building.requiredTech() {
            requiredText = requiredTech.name()
        }
        if let requiredCivic = building.requiredCivic() {
            requiredText = requiredCivic.name()
        }
        self.summary = "Building that can be built with \(building.productionCost()) [Production] production. " +
            "It requires \(requiredText) to be researched."
        var detailText = "Effects: \n"
        building.effects().forEach { detailText += ("* " + $0 + "\n") }
        self.detail = detailText
        self.imageName = building.iconTexture()
    }

    init(district: DistrictType) {

        self.title = district.name()

        var requiredText = ""
        if let requiredTech = district.requiredTech() {
            requiredText = requiredTech.name()
        }
        if let requiredCivic = district.requiredCivic() {
            requiredText = requiredCivic.name()
        }
        self.summary = "District that can be built with \(district.productionCost()) [Production] production. " +
            "It requires \(requiredText) to be researched."

        var detailText = "Effects: \n"
        district.effects().forEach { detailText += ("* " + $0 + "\n") }
        self.detail = detailText
        self.imageName = district.iconTexture()
    }

    init(wonder: WonderType) {

        self.title = wonder.name()

        var requiredText = ""
        if let requiredTech = wonder.requiredTech() {
            requiredText = requiredTech.name()
        }
        if let requiredCivic = wonder.requiredCivic() {
            requiredText = requiredCivic.name()
        }
        self.summary = "Wonder that can be built with \(wonder.productionCost()) [Production] production. " +
            "It requires \(requiredText) to be researched."

        var detailText = "Effects: \n"
        wonder.effects().forEach { detailText += ("* " + $0 + "\n") }
        self.detail = detailText
        self.imageName = wonder.iconTexture()
    }

    init(improvement: ImprovementType) {

        self.title = improvement.name()

        var requiredText = ""
        if let requiredTech = improvement.requiredTech() {
            requiredText = requiredTech.name()
        }
        self.summary = "Improvement that can be built when \(requiredText) is researched."

        var detailText = "Effects: \n"
        improvement.effects().forEach { detailText += ("* " + $0 + "\n") }
        self.detail = detailText

        self.imageName = improvement.textureNames()[0]
    }

    init(tech: TechType) {

        self.title = tech.name()

        let requires: [String] = tech.required().map { $0.name() }
        let requiredText = ListFormatter.localizedString(byJoining: requires)
        self.summary = "\(tech.era().title()) tech that needs \(tech.cost()) science. " +
            "It requires \(requiredText) to be researched."

        var detailText = "Enables: "
        var enables: [String] = []
        enables += tech.achievements().buildTypes.map { $0.name() }
        enables += tech.achievements().buildingTypes.map { $0.name() }
        enables += tech.achievements().districtTypes.map { $0.name() }
        enables += tech.achievements().unitTypes.map { $0.name() }
        enables += tech.achievements().wonderTypes.map { $0.name() }
        detailText += ListFormatter.localizedString(byJoining: enables)
        detailText += "\n"
        detailText += "Is boosted by: " + tech.eurekaSummary()
        self.detail = detailText
        self.imageName = tech.iconTexture()
    }

    init(civic: CivicType) {

        self.title = civic.name()

        let requires: [String] = civic.required().map { $0.name() }
        let requiredText = ListFormatter.localizedString(byJoining: requires)
        self.summary = "\(civic.era().title()) civic that needs \(civic.cost()) culture. " +
            "It requires \(requiredText) to be researched."

        var detailText = "Enables: "
        var enables: [String] = []
        enables += civic.achievements().buildTypes.map { $0.name() }
        enables += civic.achievements().buildingTypes.map { $0.name() }
        enables += civic.achievements().districtTypes.map { $0.name() }
        enables += civic.achievements().governments.map { $0.name() }
        enables += civic.achievements().policyCards.map { $0.name() }
        enables += civic.achievements().unitTypes.map { $0.name() }
        enables += civic.achievements().wonderTypes.map { $0.name() }
        detailText += ListFormatter.localizedString(byJoining: enables)
        detailText += "\n"
        detailText += "Is boosted by: " + civic.inspirationSummary()
        self.detail = detailText

        self.imageName = civic.iconTexture()
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.imageName)
    }
}

extension PediaDetailViewModel: Hashable {

    static func == (lhs: PediaDetailViewModel, rhs: PediaDetailViewModel) -> Bool {

        return lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.title)
    }
}

protocol PediaViewModelDelegate: AnyObject {

    func canceled()
}

class PediaViewModel: ObservableObject {

    weak var delegate: PediaViewModelDelegate?

    @Published
    var pediaCategoryViewModels: [PediaCategoryViewModel] = []

    @Published
    var selectedPediaCategory: PediaCategory = .terrains {
        didSet {
            self.updateDetailModels()
        }
    }

    @Published
    var pediaDetailViewModels: [PediaDetailViewModel] = []

    init() {

    }

    func prepare() {

        for pediaCategory in PediaCategory.all {
            self.pediaCategoryViewModels.append(PediaCategoryViewModel(category: pediaCategory))
        }

        let bundle = Bundle.init(for: Textures.self)

        let allTerrainTextureNames = [
            "terrain_desert", "terrain_plains_hills3", "terrain_grass_hills3", "terrain_desert_hills",
            "terrain_tundra", "terrain_desert_hills2", "terrain_tundra2", "terrain_shore",
            "terrain_desert_hills3", "terrain_ocean", "terrain_tundra3", "terrain_snow",
            "terrain_plains", "terrain_snow_hills", "terrain_grass", "terrain_snow_hills2",
            "terrain_tundra_hills", "terrain_plains_hills", "terrain_plains_hills2",
            "terrain_grass_hills", "terrain_snow_hills3", "terrain_grass_hills2"
        ]
        print("- load \(allTerrainTextureNames.count) terrains")
        for textureName in allTerrainTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allFeatureTextureNames = [
            "feature-atoll", "feature-lake", "feature-mountains-ne-sw", "feature-ice5",
            "feature-rainforest1", "feature-delicateArch", "feature-mountains-nw", "feature-ice6",
            "feature-rainforest2", "feature-floodplains", "feature-mountains-se", "feature-marsh1",
            "feature-mountains-se-nw", "feature-reef", "feature-forest1", "feature-marsh2",
            "feature-mountains-sw", "feature-uluru", "feature-forest2", "feature-mountEverest",
            "feature-none", "feature-galapagos", "feature-mountKilimanjaro", "feature-yosemite",
            "feature-greatBarrierReef", "feature-mountains1", "feature-oasis1", "feature-ice1",
            "feature-mountains2", "feature-oasis2", "feature-ice2", "feature-mountains3",
            "feature-pantanal", "feature-ice3", "feature-pine1", "feature-mountains-ne",
            "feature-ice4", "feature-pine1", "feature-pine2", "feature-volcano", "feature-fallout",
            "feature-fuji", "feature-barringCrater", "feature-mesa", "feature-gibraltar",
            "feature-geyser", "feature-potosi", "feature-fountainOfYouth", "feature-lakeVictoria",
            "feature-cliffsOfDover"
        ]
        print("- load \(allFeatureTextureNames.count) features")
        for textureName in allFeatureTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allResourceTextureNames = ResourceType.all.map { $0.textureName() }
        print("- load \(allResourceTextureNames.count) resources")
        for textureName in allResourceTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let unitPortraitTextures = UnitType.all.map { $0.portraitTexture() }
        print("- load \(unitPortraitTextures.count) units")
        for textureName in unitPortraitTextures {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let buildingTypeTextureNames = BuildingType.all.map { $0.iconTexture() }
        print("- load \(buildingTypeTextureNames.count) buildings")
        for textureName in buildingTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let districtTypeTextureNames = DistrictType.all.map { $0.iconTexture() }
        print("- load \(districtTypeTextureNames.count) districts")
        for textureName in districtTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let wonderTypeTextureNames = WonderType.all.map { $0.iconTexture() }
        print("- load \(wonderTypeTextureNames.count) wonders")
        for textureName in wonderTypeTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let allImprovementTextureNames = (
            ImprovementType.all + [.barbarianCamp, .goodyHut]
        ).flatMap { $0.textureNames() }
        print("- load \(allImprovementTextureNames.count) improvements")
        for textureName in allImprovementTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let techTextureNames = TechType.all.map { $0.iconTexture() }
        print("- load \(techTextureNames.count) techs")
        for textureName in techTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let civicTextureNames = CivicType.all.map { $0.iconTexture() }
        print("- load \(civicTextureNames.count) civics")
        for textureName in civicTextureNames {
            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        self.updateDetailModels()
    }

    private func updateDetailModels() {

        self.pediaDetailViewModels = []

        switch self.selectedPediaCategory {

        case .terrains:
            for terrainType in TerrainType.all {
                self.pediaDetailViewModels.append(PediaDetailViewModel(terrain: terrainType))
            }
        case .features:
            for featureType in FeatureType.all {
                self.pediaDetailViewModels.append(PediaDetailViewModel(feature: featureType))
            }
        case .resources:
            for resourceType in ResourceType.all {
                self.pediaDetailViewModels.append(PediaDetailViewModel(resource: resourceType))
            }
        case .units:
            for unitType in UnitType.all {
                self.pediaDetailViewModels.append(PediaDetailViewModel(unit: unitType))
            }
        case .buildings:
            for buildingType in BuildingType.all {
                self.pediaDetailViewModels.append(PediaDetailViewModel(building: buildingType))
            }
        case .districts:
            for districtType in DistrictType.all {
                self.pediaDetailViewModels.append(PediaDetailViewModel(district: districtType))
            }
        case .wonders:
            for wonderType in WonderType.all {
                self.pediaDetailViewModels.append(PediaDetailViewModel(wonder: wonderType))
            }
        case .improvements:
            for improvementType in ImprovementType.all {
                self.pediaDetailViewModels.append(PediaDetailViewModel(improvement: improvementType))
            }
        case .techs:
            for techType in TechType.all {
                self.pediaDetailViewModels.append(PediaDetailViewModel(tech: techType))
            }
        case .civics:
            for civicType in CivicType.all {
                self.pediaDetailViewModels.append(PediaDetailViewModel(civic: civicType))
            }
        }
    }

    func cancel() {

        self.delegate?.canceled()
    }
}
