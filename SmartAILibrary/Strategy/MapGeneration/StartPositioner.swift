//
//  StartPositioner.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

public struct StartLocation {
    
    public let point: HexPoint
    public let leader: LeaderType
    public let isHuman: Bool
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvStartPositioner
//!  \brief        Divides the map into regions of each fertility and places one major civ in each
//
//!  Key Attributes:
//!  - One instance for the entire game
//!  - Works with CvSiteEvaluatorForStart to compute fertility of each plot
//!  - Also divides minor civs between the regions and places them as well
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class StartPositioner {
    
    let map: MapModel?
    let tileFertilityEvaluator: TileFertilityEvaluator
    let numberOfPlayer: Int
    
    private var fertilityMap: Array2D<Int>
    private var startAreas: [StartArea]
    public var startLocations: [StartLocation]
    
    private struct StartArea {
        
        let area: HexArea
        let averageFertility: Double
        var used: Bool
    }

    init(on map: MapModel?, for numberOfPlayer: Int) {
        
        // properties
        self.map = map
        self.numberOfPlayer = numberOfPlayer
        
        guard let map = self.map else {
            fatalError("cant get map")
        }
        
        // internal
        self.tileFertilityEvaluator = TileFertilityEvaluator(map: self.map)
        self.startAreas = []
        self.fertilityMap = Array2D<Int>(width: map.size.width(), height: map.size.height())
        
        // result
        self.startLocations = []
    }
    
    func generateRegions() {
        
        guard let map = self.map else {
            fatalError("cant get map")
        }
        
        print("starting with: \(self.numberOfPlayer) civs")
        
        self.fertilityMap.fill(with: 0)
        
        let landAreaFert: WeightedList<String> = WeightedList<String>()

        // Obtain info on all landmasses for comparision purposes.
        var iGlobalFertilityOfLands = 0
        var iNumLandPlots = 0
        
        let mapSize = map.size
        
        // Cycle through all plots in the world, checking their Start Placement Fertility and AreaID.
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                
                if let plot = map.tile(x: x, y: y) {
                    
                    // Land plot, process it.
                    if plot.terrain().isLand() {
                        iNumLandPlots = iNumLandPlots + 1

                        if let continentIdentifier = plot.continentIdentifier() {
                            
                            // Check for coastal land is enabled.
                            let plotFertility = self.tileFertilityEvaluator.placementFertility(of: plot, checkForCoastalLand: true)
                            iGlobalFertilityOfLands = iGlobalFertilityOfLands + plotFertility
                            
                            //landAreaPlots.add(weight: 1, for: continentIdentifier)
                            self.fertilityMap[x, y] = plotFertility
                            landAreaFert.add(weight: plotFertility, for: continentIdentifier)
                        } else {
                            print("skipped small island")
                        }
                    }
                }
            }
        }
   
        // Sort areas, achieving a list of AreaIDs with best areas first.
        //
        // Fertility data in land_area_fert is stored with areaID index keys.
        // Need to generate a version of this table with indices of 1 to n, where n is number of land areas.
        // Sort the fertility values stored in the interim table. Sort order in Lua is lowest to highest.
        landAreaFert.sortReverse()
        
        // init number of civs on each continent
        let numberOfCivsPerArea: WeightedList<String> = WeightedList<String>()
        
        for landAreaFertItem in landAreaFert.items {
            numberOfCivsPerArea.set(weight: 0.0, for: landAreaFertItem.itemType)
        }
        
        // Assign continents to receive start plots. Record number of civs assigned to each landmass.
        for _ in 0..<self.numberOfPlayer {
            
            var bestRemainingAreaIdentifier: String = "---"
            var bestRemainingFertility = 0.0

            // Loop through areas, find the one with the best remaining fertility (civs added
            // to a landmass reduces its fertility rating for subsequent civs).
            for areaItem in landAreaFert.items {
                
                let thisLandmassCurrentFertility = areaItem.weight / (1 + numberOfCivsPerArea.weight(of: areaItem.itemType))
                
                if thisLandmassCurrentFertility > bestRemainingFertility {
                    bestRemainingAreaIdentifier = areaItem.itemType
                    bestRemainingFertility = thisLandmassCurrentFertility
                }
            }
            
            // Record results for this pass. (A landmass has been assigned to receive one more start point than it previously had).
            numberOfCivsPerArea.add(weight: 1.0, for: bestRemainingAreaIdentifier)
        }
        
        for numberOfCivsPerAreaItem in numberOfCivsPerArea.items {
        
            let numberOfCivsOnCurrentArea = Int(numberOfCivsPerAreaItem.weight)
            
            //print("numberOfCivsOnCurrentArea: \(numberOfCivsOnCurrentArea) on continent '\(numberOfCivsPerAreaItem.itemType)'")
            if let continent = map.continent(by: numberOfCivsPerAreaItem.itemType) {
            
                let area = HexArea(points: continent.points)
                
                // Divide this landmass in to number of regions equal to civs assigned here.
                if numberOfCivsOnCurrentArea > 0 && numberOfCivsOnCurrentArea <= 12 {
                    self.divideIntoRegions(numOfDivisions: Int(numberOfCivsPerAreaItem.weight), area: area)
                }
            }
        }
    }
    
    func chooseLocations(for aiLeaders: [LeaderType], human: LeaderType) {
        
        var combined: [LeaderType] = aiLeaders
        combined.append(human)
        
        for leader in combined.shuffled {
            
            let civ = leader.civilization()
            
            var bestArea: StartArea? = nil
            var bestValue: Int = 0
            var bestLocation: HexPoint = HexPoint.zero
            
            // find best spot for civ in all areas
            for startArea in self.startAreas {
                
                if startArea.used {
                    continue
                }
                
                for startPoint in startArea.area {
                    
                    var valueSum: Int = 0
                    var tooClose: Bool = false
                    
                    // other start locations
                    for otherStartLocation in self.startLocations {
                        if startPoint.distance(to: otherStartLocation.point) < 10 {
                            tooClose = true
                            break
                        }
                    }
                    
                    if tooClose {
                        continue
                    }
                    
                    for loopPoint in startPoint.areaWith(radius: 2) {
                        if let tile = self.map?.tile(at: loopPoint) {
                            
                            valueSum += self.fertilityMap[tile.point] ?? 0
                            valueSum += civ.startingBias(for: tile, in: self.map)
                        }
                    }
                    
                    if valueSum > bestValue {
                        
                        bestValue = valueSum
                        bestLocation = startPoint
                        bestArea = startArea
                    }
                }
            }
            
            // remove current start area
            if let identifier = bestArea?.area.identifier {
                self.startAreas = self.startAreas.filter({ $0.area.identifier != identifier })
            }
            
            // sanity check - should restart
            guard bestLocation != HexPoint.zero else {
                fatalError("Can't find valid start location")
            }
            
            self.startLocations.append(StartLocation(point: bestLocation, leader: leader, isHuman: leader == human))
        }
        
        // sort human to the end
        self.startLocations.sort(by: { !$0.isHuman && $1.isHuman })
        
        // debug
        var allLeaders = aiLeaders
        allLeaders.append(human)
        
        for leader in allLeaders {
            if let leaderPos = self.startLocations.first(where: { $0.leader == leader }) {
                print("- \(leader) (\(leaderPos.isHuman ? "human" : "ai")) has start position \(leaderPos.point)")
                
                for leader2 in allLeaders {
                    
                    if leader == leader2 {
                        continue
                    }
                    
                    if let leader2Pos = self.startLocations.first(where: { $0.leader == leader2 }) {
                        let distance = leaderPos.point.distance(to: leader2Pos.point)
                        print("   - distance: \(distance) to \(leader2)")
                    }
                }
            }
        }
    }
    
    private func divideIntoRegions(numOfDivisions: Int, area: HexArea) {
        
        var numDivides = 0
        var subDivisions = 0
        
        switch numOfDivisions {
        case 1:
            let averageFertility = Double(area.points.map({ self.fertilityMap[$0]! }).reduce(0, +)) / Double(area.points.count)
            
            print("add start area with \(averageFertility) fertility and \(area.points.count) points")
            
            self.startAreas.append(StartArea(area: area, averageFertility: averageFertility, used: false))
            
            return
        case 2:
            numDivides = 2
            subDivisions = 1
        case 3:
            numDivides = 3
            subDivisions = 1
        case 4:
            numDivides = 2
            subDivisions = 2
        case 5, 6:
            numDivides = 3
            subDivisions = 2
        case 7, 8:
            numDivides = 2
            subDivisions = 4
        case 9:
            numDivides = 3
            subDivisions = 3
        case 10:
            numDivides = 2
            subDivisions = 5
        case 11, 12:
            numDivides = 3
            subDivisions = 4
        default:
            fatalError("Erroneous number of regional divisions : \(numOfDivisions)")
        }
        
        if numDivides == 2 {
            
            let area1, area2: HexArea
            let boundingBox = area.boundingBox
            
            if boundingBox.width > boundingBox.height {
                (area1, area2) = area.divideHorizontally(at: boundingBox.minX + boundingBox.width / 2)
            } else {
                (area1, area2) = area.divideVertically(at: boundingBox.minY + boundingBox.height / 2)
            }

            self.divideIntoRegions(numOfDivisions: subDivisions, area: area1)
            self.divideIntoRegions(numOfDivisions: subDivisions, area: area2)
        } else if numDivides == 3 {
            
            let area1, area2, area3, areaTmp: HexArea
            let boundingBox = area.boundingBox
            
            if boundingBox.width > boundingBox.height {
                (area1, areaTmp) = area.divideHorizontally(at: boundingBox.minX + boundingBox.width / 3)
                
                (area2, area3) = areaTmp.divideHorizontally(at: boundingBox.minX + 2 * boundingBox.width / 3)
                
            } else {
                (area1, areaTmp) = area.divideVertically(at: boundingBox.minY + boundingBox.height / 3)
                
                (area2, area3) = areaTmp.divideVertically(at: boundingBox.minY + 2 * boundingBox.height / 3)
            }
            
            self.divideIntoRegions(numOfDivisions: subDivisions, area: area1)
            self.divideIntoRegions(numOfDivisions: subDivisions, area: area2)
            self.divideIntoRegions(numOfDivisions: subDivisions, area: area3)
        } else {
            fatalError("wrong number of sub divisions")
        }
        
    }
}
