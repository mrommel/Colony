//
//  MapProvider.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import SpriteKit

public typealias ProgressHandler = (Double, String) -> Void

public class MapGenerator {

    let options: MapOptions
	let width: Int
	let height: Int

	let terrain: Array2D<TerrainType>
	let zones: Array2D<ClimateZone>
	let distanceToCoast: Array2D<Int>
	var springLocations: [HexPoint]

	public var progressHandler: ProgressHandler?

	/**
	creates a new grid generator for a map of `width`x`height` dimension
	
	- Parameter width: width of the resulting map
	- Parameter height: height of the resulting map
	*/
    required public init(with options: MapOptions) {

        self.options = options
        self.width = options.size.width()
        self.height = options.size.height()

		// prepare terrain, distanceToCoast and zones
        self.terrain = Array2D<TerrainType>(width: self.width, height: self.height)
        self.distanceToCoast = Array2D<Int>(width: self.width, height: self.height)
        self.zones = Array2D<ClimateZone>(width: self.width, height: self.height)
		self.springLocations = []
	}

	public func generate() -> MapModel? {

		// prepare result value
        let grid = MapModel(size: MapSize.custom(width: self.width, height: self.height))

		// 0st step: height and moisture map
		let heightMap = HeightMap(width: self.width, height: self.height)
		let moistureMap = HeightMap(width: self.width, height: self.height)

		if let completionHandler = self.progressHandler {
			completionHandler(0.2, "initialized")
		}
        
        usleep(100000) // will sleep for 100 milliseconds

		// 1st step: land / water
		self.fillFromElevation(withWaterPercentage: options.waterPercentage, on: heightMap)

		if let completionHandler = self.progressHandler {
			completionHandler(0.4, "elevation map created")
		}
        
        usleep(100000) // will sleep for 100 milliseconds

		// 2nd step: climate
        self.setClimateZones()
        
		if let completionHandler = self.progressHandler {
			completionHandler(0.45, "climate zones generated")
		}
        
        usleep(100000) // will sleep for 100 milliseconds

		// 2.1nd step: refine climate based on cost distance
		self.prepareDistanceToCoast()
		self.refineClimate()

		if let completionHandler = self.progressHandler {
			completionHandler(0.5, "coastal distance calculated")
		}
        
        usleep(100000) // will sleep for 100 milliseconds

		// 3rd step: refine terrain
		self.refineTerrain(on: grid, with: heightMap, and: moistureMap)

		if let completionHandler = self.progressHandler {
			completionHandler(0.65, "terrain refined")
		}
        
        usleep(100000) // will sleep for 100 milliseconds

		// 4th step: rivers
		self.identifySpringLocations(on: heightMap)
		let rivers = self.add(rivers: options.rivers, on: heightMap)
		self.put(rivers: rivers, onto: grid)

		if let completionHandler = self.progressHandler {
			completionHandler(0.8, "springs and rivers identified")
		}
        
        usleep(100000) // will sleep for 100 milliseconds
        
        // 5th step: continents & oceans
        self.identifyContinents(on: grid)
        
        if let completionHandler = self.progressHandler {
            completionHandler(0.9, "continents identified")
        }
        
        self.identifyOceans(on: grid)
        
        if let completionHandler = self.progressHandler {
            completionHandler(1.0, "oceans identified")
        }
        
        usleep(100000) // will sleep for 100 milliseconds

		return grid
	}

	// MARK: 1st step methods

	func waterOrLandFrom(elevation: Double, waterLevel: Double) -> TerrainType {

		if elevation < waterLevel {
			return TerrainType.ocean
		}

		return TerrainType.grass
	}

	func fillFromElevation(withWaterPercentage waterPercentage: Double, on heightMap: HeightMap) {

		let waterLevel = heightMap.findWaterLevel(forWaterPercentage: waterPercentage)
        
		for x in 0..<width {
			for y in 0..<height {
				guard let height = heightMap[x, y] else {
					continue
				}

                self.terrain[x, y] = self.waterOrLandFrom(elevation: height, waterLevel: waterLevel)
			}
		}
	}

	// MARK: 2nd step methods

	func setClimateZones() {

		self.zones.fill(with: .temperate)

		for x in 0..<width {
			for y in 0..<height {

				let latitude = abs(Double(height / 2 - y)) / Double(height / 2)

				if latitude > 0.9 {
					self.zones[x, y] = .polar
				} else if latitude > 0.65 {
					self.zones[x, y] = .subpolar
				} else if latitude > 0.4 {
					self.zones[x, y] = .temperate
				} else if latitude > 0.2 {
					self.zones[x, y] = .subtropic
				} else {
					self.zones[x, y] = .tropic
				}
			}
		}

		return
	}

	/**
	this function assumes that the self.terrain is filled with Terrain.ocean or Terrain.grass only
	*/
	func refineClimate() {

		for x in 0..<width {
			for y in 0..<height {

				guard let distance = self.distanceToCoast[x, y] else {
					continue
				}

				if distance < 2 {
					self.zones[x, y] = self.zones[x, y]?.moderate
				}
			}
		}
	}

	func prepareDistanceToCoast() {

		self.distanceToCoast.fill(with: Int.max)

		var actionHappened: Bool = true
		while actionHappened {

			// reset
			actionHappened = false

			for x in 0..<width {
				for y in 0..<height {

					// this needs to be analyzed
					if self.distanceToCoast[x, y] == Int.max {

						// if field is ocean => no distance
						if self.terrain[x, y] == TerrainType.ocean {
							self.distanceToCoast[x, y] = 0
							actionHappened = true
						} else {
							// check neighbors
							var distance = Int.max
							let point = HexPoint(x: x, y: y)
							for direction in HexDirection.all {

								let neighbor = point.neighbor(in: direction)
								if neighbor.x >= 0 && neighbor.x < self.width && neighbor.y >= 0 && neighbor.y < self.height {

									if self.distanceToCoast[x, y] != Int.max {
										distance = min(distance, self.distanceToCoast[x, y]! + 1)
									}
								}
							}

							if distance < Int.max {
								self.distanceToCoast[x, y] = distance
								actionHappened = true
							}
						}
					}
				}
			}
		}
	}

	// MARK: 3rd step methods

	func refineTerrain(on grid: MapModel?, with heightMap: HeightMap, and moistureMap: HeightMap) {

		for x in 0..<width {
			for y in 0..<height {
				let gridPoint = HexPoint(x: x, y: y)

				if self.terrain[x, y] == TerrainType.ocean {

					if heightMap[x, y]! > 0.1 {
						grid?.set(terrain: .shore, at: gridPoint)
					} else {
						grid?.set(terrain: .ocean, at: gridPoint)
					}
				} else {
                    self.updateBiome(at: gridPoint, on: grid, elevation: heightMap[x, y]!, moisture: moistureMap[x, y]!, climate: self.zones[x, y]!)
				}
			}
		}
	}

	// from http://www.redblobgames.com/maps/terrain-from-noise/
    func updateBiome(at point: HexPoint, on grid: MapModel?, elevation: Double, moisture: Double, climate: ClimateZone) {

		switch climate {
		case .polar:
            grid?.set(terrain: .snow, at: point)
		case .subpolar:
            self.updateBiomeForSubpolar(at: point, on: grid, elevation: elevation, moisture: moisture)
		case .temperate:
			self.updateBiomeForTemperate(at: point, on: grid, elevation: elevation, moisture: moisture)
		case .subtropic:
			self.updateBiomeForSubtropic(at: point, on: grid, elevation: elevation, moisture: moisture)
		case .tropic:
			self.updateBiomeForTropic(at: point, on: grid, elevation: elevation, moisture: moisture)
		}
	}

	func updateBiomeForSubpolar(at point: HexPoint, on grid: MapModel?, elevation: Double, moisture: Double) {

        if elevation > 0.9 {
            grid?.set(feature: .mountains, at: point)
            grid?.set(terrain: .snow, at: point)
            return
        }
        
        if elevation > 0.75 {
            grid?.set(hills: true, at: point)
            grid?.set(terrain: .snow, at: point)
            return
        }
        
		if elevation > 0.5 {
            grid?.set(terrain: .snow, at: point)
			return
		}

        if moisture > 0.5 && Double.random > 0.8 {
            grid?.set(feature: .forest, at: point)
        }
        grid?.set(terrain: .tundra, at: point)
		return
	}

	func updateBiomeForTemperate(at point: HexPoint, on grid: MapModel?, elevation: Double, moisture: Double) {

        if elevation > 0.9 {
            grid?.set(feature: .mountains, at: point)
            grid?.set(terrain: .grass, at: point)
            return
        }
        
        if elevation > 0.8 {
            grid?.set(hills: true, at: point)
            grid?.set(terrain: .grass, at: point)
            return
        }

		if moisture < 0.5 {
			grid?.set(terrain: .plains, at: point)
            return
		} else {
            if Double.random > 0.8 {
                grid?.set(feature: .forest, at: point)
            }
			grid?.set(terrain: .grass, at: point)
            return
		}
	}

	func updateBiomeForSubtropic(at point: HexPoint, on grid: MapModel?, elevation: Double, moisture: Double) {

		if elevation > 0.9 {
			grid?.set(feature: .mountains, at: point)
            grid?.set(terrain: .grass, at: point)
            return
		}
        
        if elevation > 0.8 {
            grid?.set(hills: true, at: point)
            grid?.set(terrain: .plains, at: point)
            return
        }

		if moisture < 0.2 {
            if Double.random > 0.9 {
                grid?.set(feature: .oasis, at: point)
            }
			grid?.set(terrain: .desert, at: point)
            return
		} else if moisture < 0.6 {
            if moisture > 0.5 && Double.random > 0.8 {
                grid?.set(feature: .forest, at: point)
            }
			grid?.set(terrain: .plains, at: point)
            return
		} else {
            if moisture > 0.5 && Double.random > 0.8 {
                grid?.set(feature: .rainforest, at: point)
            }
			grid?.set(terrain: .grass, at: point)
            return
		}
	}

	func updateBiomeForTropic(at point: HexPoint, on grid: MapModel?, elevation: Double, moisture: Double) {

		if elevation > 0.9 {
			grid?.set(feature: .mountains, at: point)
            grid?.set(terrain: .plains, at: point)
            return
		}
        
        if elevation > 0.8 {
            grid?.set(hills: true, at: point)
            grid?.set(terrain: .plains, at: point)
            return
        }

		if moisture < 0.3 {
            if Double.random > 0.9 {
                grid?.set(feature: .oasis, at: point)
            }
			grid?.set(terrain: .desert, at: point)
            return
		} else {
            if moisture > 0.5 && Double.random > 0.8 {
                grid?.set(feature: .rainforest, at: point)
            }
			grid?.set(terrain: .plains, at: point)
            return
		}
	}

	// MARK: 4th step methods - river

	func identifySpringLocations(on heightMap: HeightMap) {

		self.springLocations.removeAll()

		for x in 0..<width {
			for y in 0..<height {

				if let height = heightMap[x, y] {
					if height > 0.9 {
						let gridPoint = HexPoint(x: x, y: y)
						self.springLocations.append(gridPoint)
					}
				}
			}
		}
	}

	func add(rivers numberOfRivers: Int, on heightMap: HeightMap) -> [River] {

		let number = min(numberOfRivers, self.springLocations.count)

		// get a random excerpt of springLocations
		self.springLocations.shuffle()
		let selectedSprings = self.springLocations.choose(number)

		var rivers: [River] = []
		var unusedRiverNames = riverNames

		for spring in selectedSprings {

			let riverName = unusedRiverNames.chooseOne
			rivers.append(self.startRiver(with: riverName, at: spring, on: heightMap))
            let riverIndex = unusedRiverNames.firstIndex(where: { $0 == riverName })
			unusedRiverNames.remove(at: riverIndex!)
		}

		return rivers
	}

	func heightOf(corner: HexPointCorner, at gridPoint: HexPoint, on heightMap: HeightMap) -> Double {

		let adjacentPoints = gridPoint.adjacentPoints(of: corner)
		var amountOfPoints: Double = 0.0
		var height: Double = 0.0

		for adjacentPoint in adjacentPoints {
			// check if adjacentPoint is on map
			if adjacentPoint.x >= 0 && adjacentPoint.x < self.width && adjacentPoint.y >= 0 && adjacentPoint.y < self.height {
				amountOfPoints += 1.0
				if let heightValue = heightMap[adjacentPoint.x, adjacentPoint.y] {
					height += heightValue
				}
			}
		}

		if amountOfPoints > 0 {
			return height / amountOfPoints
		} else {
			return 0.0
		}
	}

	func startRiver(with name: String, at gridPoint: HexPoint, on heightMap: HeightMap) -> River {

		// get random corner
		let startCorner = randomGridPointCorner()
		let startGridPointWithCorner = HexPointWithCorner(with: gridPoint, andCorner: startCorner)

		let hexPointCorners = self.followRiver(at: startGridPointWithCorner, on: heightMap, depth: 30)

        //if let lastHexPointCorners = hexPointCorners.last {
            // FIXME
        //}
        
		let river = River(with: name, and: hexPointCorners)

		return river
	}

	func followRiver(at gridPointWithCorner: HexPointWithCorner, on heightMap: HeightMap, depth: Int) -> [HexPointWithCorner] {

		// cut recursion
		if depth <= 0 {
			return []
		}

		var lowestGridPointWithCorner: HexPointWithCorner = gridPointWithCorner
		var lowestValue: Double = Double.greatestFiniteMagnitude

		for corner in gridPointWithCorner.adjacentCorners() {

			// skip points outside the map
			if corner.point.x >= 0 && corner.point.x < self.width && corner.point.y >= 0 && corner.point.y < self.height {

				let heightOfCorner = self.heightOf(corner: corner.corner, at: corner.point, on: heightMap)

				if heightOfCorner < lowestValue {
					lowestValue = heightOfCorner
					lowestGridPointWithCorner = corner
				}
			}
		}

		var result: [HexPointWithCorner] = []

		if lowestValue < Double.greatestFiniteMagnitude {

			let targetTerrain = self.terrain[lowestGridPointWithCorner.point.x, lowestGridPointWithCorner.point.y]

			if targetTerrain != .ocean {

				// TODO: river sometimes get stuck and end in lakes

				result.append(lowestGridPointWithCorner)
				let newRiverTile = self.followRiver(at: lowestGridPointWithCorner, on: heightMap, depth: depth - 1)
				result.append(contentsOf: newRiverTile)
			}
		}

		return result
	}

	func put(rivers: [River], onto grid: MapModel?) {

		for river in rivers {
            grid?.add(river: river)
		}
	}
    
    // MARK: 5th continents
    
    func identifyContinents(on grid: MapModel?) {
        
        guard let grid = grid else {
            return
        }
        
        let finder = ContinentFinder(width: grid.size.width(), height: grid.size.height())
        let continents = finder.execute(on: grid)
        
        grid.continents = continents
    }
    
    func identifyOceans(on grid: MapModel?) {
        
        guard let grid = grid else {
            return
        }
        
        let finder = OceanFinder(width: grid.size.width(), height: grid.size.height())
        let oceans = finder.execute(on: grid)
        
        grid.oceans = oceans
    }
}