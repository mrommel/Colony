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
        .techs, .civics]
    
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
        self.summary = "Base terrain of the \(terrain.domain()) domain."
        self.detail = "Yields: \(terrain.yields().food) Food, \(terrain.yields().production) Production and \(terrain.yields().gold) Gold"
        self.imageName = terrain.textureNames().first ?? "no_image" // add default
    }
    
    init(feature: FeatureType) {
        
        self.title = feature.name()
        self.summary = "Terrain feature that can be found on ???"
        self.detail = "Yields: \(feature.yields().food) Food, \(feature.yields().production) Production and \(feature.yields().gold) Gold"
        self.imageName = feature.textureNames().first ?? "no_image" // add default
    }
    
    init(resource: ResourceType) {
        
        self.title = resource.name()
        self.summary = "Resource that can be found on ???"
        self.detail = "Yields: \(resource.yields().food) Food, \(resource.yields().production) Production and \(resource.yields().gold) Gold"
        self.imageName = resource.textureName()
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
        
        for pediaCategory in PediaCategory.all {
            self.pediaCategoryViewModels.append(PediaCategoryViewModel(category: pediaCategory))
        }
        
        let bundle = Bundle.init(for: Textures.self)
        let textures: Textures = Textures(game: nil)
        
        print("- load \(textures.allTerrainTextureNames.count) terrains")
        for terrainTextureName in textures.allTerrainTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: terrainTextureName), for: terrainTextureName)
        }

        print("- load \(textures.allFeatureTextureNames.count) features")
        for featureTextureName in textures.allFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: featureTextureName), for: featureTextureName)
        }
        
        print("- load \(textures.allResourceTextureNames.count) resources")
        for resourceTextureName in textures.allResourceTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: resourceTextureName), for: resourceTextureName)
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
            print("units")
        case .buildings:
            print("buildings")
        case .districts:
            print("districts")
        case .wonders:
            print("wonders")
        case .improvements:
            print("improvements")
            
        case .techs:
            print("techs")
        case .civics:
            print("civics")
        }
    }
    
    func cancel() {
        
        self.delegate?.canceled()
    }
}
