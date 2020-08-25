//
//  BuildType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// CIV5Builds.xml
public enum BuildType: Int, Codable {
    
    case none
    case repair
    
    case ancientRoad
    case classicalRoad
    case removeRoad
    
    case farm
    case mine
    case quarry
    case plantation
    case camp
    case pasture
    case fishingBoats
    
    case removeForest
    case removeRainforest
    case removeMarsh
    
    public static var all: [BuildType] {
        return [.ancientRoad, .classicalRoad, .removeRoad, .repair, .farm, .mine, .quarry, .plantation, .camp, .pasture, .fishingBoats, .removeForest, .removeRainforest, .removeMarsh]
    }
    
    public static var allImprovements: [BuildType] {
        return [.farm, .mine, .quarry, .plantation, .camp, .pasture]
    }
    
    func name() -> String {
        
        return self.data().name
    }
    
    func repair() -> Bool {
        
        return self.data().repair
    }
    
    func improvement() -> ImprovementType? {
        
        return self.data().improvement
    }
    
    func route() -> RouteType? {
        
        return self.data().route
    }
    
    func removeRoute() -> Bool {
        
        return self.data().removeRoad
    }
    
    func required() -> TechType? {
        
        return self.data().required
    }
    
    func canRemove(feature: FeatureType) -> Bool {
        
        if let featureBuild = self.data().featureBuilds.first(where: { $0.featureType == feature }) {
            return featureBuild.isRemove
        }
        
        return false
    }
    
    func requiredRemoveTech(for feature: FeatureType) -> TechType? {
        
        if let featureBuild = self.data().featureBuilds.first(where: { $0.featureType == feature }) {
            return featureBuild.required
        }
        
        return nil
    }
    
    func buildTime(on tile: AbstractTile?) -> Int {
        
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        var time = self.data().duration
        
        for featureType in FeatureType.all {
            if tile.has(feature: featureType) {
                if let featureBuild = self.data().featureBuilds.first(where: { $0.featureType == featureType }) {
                    time += featureBuild.duration
                } else {
                    // build cant handle feature
                    return Int.max
                }
            }
        }
        
        return time
    }
    
    func productionFromRemoval(of feature: FeatureType) -> Int {
        
        if let featureBuild = self.data().featureBuilds.first(where: { $0.featureType == feature }) {
            return featureBuild.production
        }
        
        return 0
    }
    
    // MARK: private data structure
    
    private class BuildTypeData {
        
        let name: String
        let repair: Bool
        let required: TechType?
        let era: EraType?
        let improvement: ImprovementType?
        let route: RouteType?
        let removeRoad: Bool
        var featureBuilds: [FeatureBuild] = []
        let duration: Int
        
        init(name: String, repair: Bool = false, required: TechType? = nil, era: EraType? = nil, improvement: ImprovementType? = nil, route: RouteType? = nil, removeRoad: Bool = false, duration: Int) {
            
            self.name = name
            self.repair = repair
            self.required = required
            self.era = era
            self.improvement = improvement
            self.route = route
            self.removeRoad = removeRoad
            self.duration = duration
        }
    }
    
    private struct FeatureBuild {
        
        let featureType: FeatureType
        let required: TechType?
        let production: Int // on removal
        let duration: Int
        let isRemove: Bool
    }
    
    private func data() -> BuildTypeData {
    
        switch self {
            
        case .none: return BuildTypeData(name: "None", duration: 0)
        case .repair: return BuildTypeData(name: "Repair", repair: true, duration: 300)
            
        case .ancientRoad: return BuildTypeData(name: "Road", era: .ancient, route: .ancientRoad, duration: 300)
        case .classicalRoad: return BuildTypeData(name: "Road", era: .classical, route: .classicalRoad, duration: 300)
            
        case .removeRoad: return BuildTypeData(name: "Remove Road", required: .wheel, removeRoad: true, duration: 300)
            
        case .farm:
            let farmBuild = BuildTypeData(name: "Farm", improvement: .farm, duration: 600)
            farmBuild.featureBuilds.append(FeatureBuild(featureType: .rainforest, required: .bronzeWorking, production: 0, duration: 600, isRemove: true))
            farmBuild.featureBuilds.append(FeatureBuild(featureType: .forest, required: .mining, production: 20, duration: 300, isRemove: true))
            farmBuild.featureBuilds.append(FeatureBuild(featureType: .marsh, required: .masonry, production: 0, duration: 500, isRemove: true))
            return farmBuild
        case .mine:
            let mineBuild = BuildTypeData(name: "Mine", required: .mining, improvement: .mine, duration: 600)
            mineBuild.featureBuilds.append(FeatureBuild(featureType: .rainforest, required: .bronzeWorking, production: 0, duration: 600, isRemove: true))
            mineBuild.featureBuilds.append(FeatureBuild(featureType: .forest, required: .mining, production: 20, duration: 300, isRemove: true))
            mineBuild.featureBuilds.append(FeatureBuild(featureType: .marsh, required: .masonry, production: 0, duration: 500, isRemove: true))
            return mineBuild
        case .quarry:
            let quarryBuild = BuildTypeData(name: "Quarry", required: .mining, improvement: .quarry, duration: 700)
            quarryBuild.featureBuilds.append(FeatureBuild(featureType: .rainforest, required: .bronzeWorking, production: 0, duration: 600, isRemove: true))
            quarryBuild.featureBuilds.append(FeatureBuild(featureType: .forest, required: .mining, production: 20, duration: 300, isRemove: true))
            quarryBuild.featureBuilds.append(FeatureBuild(featureType: .marsh, required: .masonry, production: 0, duration: 500, isRemove: true))
            return quarryBuild
        case .plantation:
            let plantationBuild = BuildTypeData(name: "Plantation", required: .irrigation, improvement: .plantation, duration: 500)
            plantationBuild.featureBuilds.append(FeatureBuild(featureType: .rainforest, required: .bronzeWorking, production: 0, duration: 600, isRemove: true))
            plantationBuild.featureBuilds.append(FeatureBuild(featureType: .forest, required: .mining, production: 20, duration: 300, isRemove: true))
            plantationBuild.featureBuilds.append(FeatureBuild(featureType: .marsh, required: .masonry, production: 0, duration: 500, isRemove: true))
            return plantationBuild
        case .camp:
            let campBuild = BuildTypeData(name: "Camp", required: .animalHusbandry, improvement: .camp, duration: 600)
            
            return campBuild
        case .pasture:
            let pastureBuild = BuildTypeData(name: "Pasture", required: .animalHusbandry, improvement: .pasture, duration: 700)
            pastureBuild.featureBuilds.append(FeatureBuild(featureType: .rainforest, required: .bronzeWorking, production: 0, duration: 600, isRemove: true))
            pastureBuild.featureBuilds.append(FeatureBuild(featureType: .forest, required: .mining, production: 20, duration: 300, isRemove: true))
            pastureBuild.featureBuilds.append(FeatureBuild(featureType: .marsh, required: .masonry, production: 0, duration: 500, isRemove: true))
            return pastureBuild
            
        case .fishingBoats:
            let fishingBoatsBuild = BuildTypeData(name: "Fishing Boats", required: .sailing, improvement: .fishingBoats, duration: 700)
            
            return fishingBoatsBuild
            
        case .removeForest:
            let removeForestBuild = BuildTypeData(name: "Remove Forest", duration: 300)
            removeForestBuild.featureBuilds.append(FeatureBuild(featureType: .forest, required: .mining, production: 20, duration: 300, isRemove: true))
            return removeForestBuild
            
        case .removeRainforest:
            let removeRainforestBuild = BuildTypeData(name: "Remove Rainforest", duration: 600)
            removeRainforestBuild.featureBuilds.append(FeatureBuild(featureType: .rainforest, required: .bronzeWorking, production: 0, duration: 600, isRemove: true))
            return removeRainforestBuild
            
        case .removeMarsh:
            let removeMarshBuild = BuildTypeData(name: "Remove Marsh", duration: 500)
            removeMarshBuild.featureBuilds.append(FeatureBuild(featureType: .marsh, required: .masonry, production: 0, duration: 500, isRemove: true))
            return removeMarshBuild
        }
    }
    
    func isKill() -> Bool {
        
        return false
    }
}
