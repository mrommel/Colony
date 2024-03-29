//
//  StartPositioner.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

public class StartLocation: Codable {

    enum CodingKeys: CodingKey {

        case point
        case leader
        case isHuman
    }

    public var point: HexPoint
    public let leader: LeaderType
    public let isHuman: Bool

    init(point: HexPoint, leader: LeaderType, isHuman: Bool) {

        self.point = point
        self.leader = leader
        self.isHuman = isHuman
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.point = try container.decode(HexPoint.self, forKey: .point)
        self.leader = try container.decode(LeaderType.self, forKey: .leader)
        self.isHuman = try container.decode(Bool.self, forKey: .isHuman)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.point, forKey: .point)
        try container.encode(self.leader, forKey: .leader)
        try container.encode(self.isHuman, forKey: .isHuman)
    }
}

public class WeightedStringList: WeightedList<String> {

}

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvStartPositioner
//  \brief        Divides the map into regions of each fertility and places one major civ in each
//
//  Key Attributes:
//   - One instance for the entire game
//   - Works with CvSiteEvaluatorForStart to compute fertility of each plot
//   - Also divides minor civs between the regions and places them as well
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class StartPositioner {

    let map: MapModel?
    let tileFertilityEvaluator: TileFertilityEvaluator
    let numberOfPlayers: Int
    let numberOfCityStates: Int

    private var fertilityMap: Array2D<Int>
    private var startAreas: [StartArea]
    public var startLocations: [StartLocation]
    public var cityStateStartLocations: [StartLocation]

    private struct StartArea {

        let area: HexArea
        let averageFertility: Double
        var used: Bool
    }

    init(on map: MapModel?, for numberOfPlayers: Int, and numberOfCityStates: Int) {

        // properties
        self.map = map
        self.numberOfPlayers = numberOfPlayers
        self.numberOfCityStates = numberOfCityStates

        guard let map = self.map else {
            fatalError("cant get map")
        }

        // internal
        self.tileFertilityEvaluator = TileFertilityEvaluator(map: self.map)
        self.startAreas = []
        self.fertilityMap = Array2D<Int>(width: map.size.width(), height: map.size.height())

        // result
        self.startLocations = []
        self.cityStateStartLocations = []
    }

    func generateRegions() {

        guard let map = self.map else {
            fatalError("cant get map")
        }

        print("starting with: \(self.numberOfPlayers) civs and \(self.numberOfCityStates) city states")

        self.fertilityMap.fill(with: 0)

        let landAreaFert: WeightedStringList = WeightedStringList()

        // Obtain info on all landmasses for comparision purposes.
        var globalFertilityOfLands = 0
        var numberOfLandPlots = 0

        let mapSize = map.size

        // Cycle through all plots in the world, checking their Start Placement Fertility and AreaID.
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                if let plot = map.tile(x: x, y: y) {

                    // Land plot, process it.
                    if plot.terrain().isLand() {
                        numberOfLandPlots += 1

                        if let continentIdentifier = plot.continentIdentifier() {

                            // Check for coastal land is enabled.
                            let plotFertility = self.tileFertilityEvaluator.placementFertility(of: plot, checkForCoastalLand: true)
                            globalFertilityOfLands += plotFertility

                            self.fertilityMap[x, y] = plotFertility
                            landAreaFert.add(weight: plotFertility, for: continentIdentifier)
                        } else {
                            print("skipped small island")
                        }
                    }
                }
            }
        }

        // init number of civs on each continent
        let numberOfCivsPerArea: WeightedStringList = WeightedStringList()

        for landAreaFertItem in landAreaFert.items {
            numberOfCivsPerArea.set(weight: 0.0, for: landAreaFertItem.0)
        }

        // Assign continents to receive start plots. Record number of civs assigned to each landmass.
        for _ in 0..<(self.numberOfPlayers + self.numberOfCityStates) {

            var bestRemainingAreaIdentifier: String = "---"
            var bestRemainingFertility = 0.0

            // Loop through areas, find the one with the best remaining fertility (civs added
            // to a landmass reduces its fertility rating for subsequent civs).
            for areaItem in landAreaFert.items {

                let thisLandmassCurrentFertility = areaItem.1 / (1 + numberOfCivsPerArea.weight(of: areaItem.0))

                if thisLandmassCurrentFertility > bestRemainingFertility {
                    bestRemainingAreaIdentifier = areaItem.0
                    bestRemainingFertility = thisLandmassCurrentFertility
                }
            }

            // Record results for this pass. (A landmass has been assigned to receive one more start point than it previously had).
            numberOfCivsPerArea.add(weight: 1.0, for: bestRemainingAreaIdentifier)
        }

        for numberOfCivsPerAreaItem in numberOfCivsPerArea.items {

            let numberOfCivsOnCurrentArea = Int(numberOfCivsPerAreaItem.1)

            // print("numberOfCivsOnCurrentArea: \(numberOfCivsOnCurrentArea) on continent '\(numberOfCivsPerAreaItem.itemType)'")
            if let continent = map.continent(by: numberOfCivsPerAreaItem.0) {

                let area = HexArea(points: continent.points)

                // Divide this landmass into a number of regions equal to civs assigned here.
                if numberOfCivsOnCurrentArea > 0 && numberOfCivsOnCurrentArea <= 12 {
                    self.divideIntoRegions(numberOfDivisions: Int(numberOfCivsPerAreaItem.1), area: area)
                }
            }
        }

        self.startAreas.sort(by: { $0.area.points.count > $1.area.points.count })

        // debug
        print("stats")
        print("  number of land plots: \(numberOfLandPlots)")
        print("  global fertility of land plots: \(globalFertilityOfLands)")
        print("  regions")
        for startArea in self.startAreas {
            print("  - start era: \(startArea.area.boundingBox) / \(startArea.area.points.count) points")
        }
        print("----")
    }

    func chooseLocations(for aiLeaders: [LeaderType], human: LeaderType) {

        guard let map = self.map else {
            fatalError("cant get map")
        }

        var combined: [LeaderType] = aiLeaders
        combined.append(human)

        let wrapX: Int? = map.wrapX ? map.size.width() : nil

        for leader in combined.shuffled {

            print("choose location for \(leader.name())")
            let civ = leader.civilization()

            var bestArea: StartArea?
            var bestValue: Int = 0
            var bestLocation: HexPoint = HexPoint.zero

            // find best spot for civ in all areas
            for startArea in self.startAreas {

                if startArea.used {
                    continue
                }

                print("evaluate area with \(startArea.area.points.count) points")

                for startPoint in startArea.area.points {

                    // check other start locations
                    let smallestDistanceOther = self.startLocations
                        .map { startPoint.distance(to: $0.point, wrapX: wrapX) }
                        .min() ?? Int.max // this is needed, when the list is empty - the value will be large

                    if smallestDistanceOther < 8 {
                        continue
                    }

                    var valueSum: Int = 0
                    for loopPoint in startPoint.areaWith(radius: 2) {
                        if let tile = self.map?.tile(at: loopPoint) {

                            var tileValue: Int = 0
                            // count center 3 times
                            if loopPoint == startPoint {
                                tileValue += 3 * (self.fertilityMap[tile.point] ?? 0)
                                tileValue += 3 * civ.startingBias(for: tile, in: self.map)
                            } else {
                                tileValue += self.fertilityMap[tile.point] ?? 0
                                tileValue += civ.startingBias(for: tile, in: self.map)
                            }
                            valueSum += tileValue
                            // print("value of \(tile.point) => \(tileValue)")
                        }
                    }

                    if valueSum > bestValue {

                        bestValue = valueSum
                        bestLocation = startPoint
                        bestArea = startArea
                        print("new best location: \(bestLocation) - \(bestValue)")
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
                        let distance = leaderPos.point.distance(to: leader2Pos.point, wrapX: wrapX)
                        print("   - distance: \(distance) to \(leader2)")
                    }
                }
            }
        }
    }

    private func divideIntoRegions(numberOfDivisions: Int, area: HexArea) {

        var numDivides = 0
        var subDivisions = 0

        switch numberOfDivisions {
        case 1:
            let averageFertility = Double(area.points.map({ self.fertilityMap[$0]! }).reduce(0, +)) / Double(area.points.count)

            // print("add start area with \(averageFertility) fertility and \(area.points.count) points")

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
            fatalError("Erroneous number of regional divisions : \(numberOfDivisions)")
        }

        if numDivides == 2 {

            let area1, area2: HexArea
            let boundingBox = area.boundingBox

            if boundingBox.width > boundingBox.height {
                let midX = area.center().x
                (area1, area2) = area.divideHorizontally(at: midX)
            } else {
                let midY = area.center().y
                (area1, area2) = area.divideVertically(at: midY)
            }

            self.divideIntoRegions(numberOfDivisions: subDivisions, area: area1)
            self.divideIntoRegions(numberOfDivisions: subDivisions, area: area2)
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

            self.divideIntoRegions(numberOfDivisions: subDivisions, area: area1)
            self.divideIntoRegions(numberOfDivisions: subDivisions, area: area2)
            self.divideIntoRegions(numberOfDivisions: subDivisions, area: area3)
        } else {
            fatalError("wrong number of sub divisions")
        }
    }

    func chooseCityStateLocations(for cityStateLeaders: [LeaderType]) {

        guard let map = self.map else {
            fatalError("cant get map")
        }

        let wrapX: Int? = map.wrapX ? map.size.width() : nil
        // let unusedStartAreas = self.startAreas.filter { !$0.used }
        // print("unused start areas: \(unusedStartAreas)")

        for leader in cityStateLeaders.shuffled {

            var bestArea: StartArea?
            var bestValue: Int = 0
            var bestLocation: HexPoint = HexPoint.invalid

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
                        if startPoint.distance(to: otherStartLocation.point, wrapX: wrapX) < 8 {
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
            if bestLocation == HexPoint.invalid {
                print("Warning: Can't find valid start location for city state")
            } else {
                self.cityStateStartLocations.append(StartLocation(point: bestLocation, leader: leader, isHuman: false))
            }
        }

        // sort human to the end
        self.startLocations.sort(by: { !$0.isHuman && $1.isHuman })
    }
}
