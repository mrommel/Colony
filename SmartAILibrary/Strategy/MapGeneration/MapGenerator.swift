//
//  MapProvider.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import SpriteKit

public typealias ProgressHandler = (Double, String) -> Void

enum PlotType: Int, Codable {
    
    case sea = 0
    case land = 1
}

public class MapGenerator: BaseMapHandler {

    let options: MapOptions
	let width: Int
	let height: Int

    let plots: Array2D<PlotType>
	let climateZones: Array2D<ClimateZone>
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
        self.plots = Array2D<PlotType>(width: self.width, height: self.height)
        self.distanceToCoast = Array2D<Int>(width: self.width, height: self.height)
        self.climateZones = Array2D<ClimateZone>(width: self.width, height: self.height)
		self.springLocations = []
	}

	public func generate() -> MapModel? {

		// prepare result value
        let grid = MapModel(size: MapSize.custom(width: self.width, height: self.height))

		// 0st step: height and moisture map
        let heightMap = HeightMap(width: self.width, height: self.height, octaves: options.octaves, zoom: 1.0, andPersistence: 1.0) // 4, 80, 0.52
		let moistureMap = HeightMap(width: self.width, height: self.height)

		if let completionHandler = self.progressHandler {
			completionHandler(0.2, "initialized")
		}
        
        usleep(10000) // will sleep for 10 milliseconds

		// 1st step: land / water
        //self.wrapHeightmap
		self.fillFromElevation(withWaterPercentage: options.waterPercentage, on: heightMap)
        // self.flipSomeCoastTiles()

		if let completionHandler = self.progressHandler {
			completionHandler(0.3, "elevation map created")
		}
        
        usleep(10000) // will sleep for 10 milliseconds

		// 2nd step: climate
        self.setClimateZones()
        
		if let completionHandler = self.progressHandler {
			completionHandler(0.35, "climate zones generated")
		}
        
        usleep(10000) // will sleep for 10 milliseconds

		// 2.1nd step: refine climate based on cost distance
		self.prepareDistanceToCoast()
		self.refineClimate()

		if let completionHandler = self.progressHandler {
			completionHandler(0.4, "coastal distance calculated")
		}
        
        usleep(10000) // will sleep for 10 milliseconds

		// 3rd step: refine terrain
		self.refineTerrain(on: grid, with: heightMap, and: moistureMap)
        self.blendTerrains(on: grid)

		if let completionHandler = self.progressHandler {
			completionHandler(0.5, "terrain refined")
		}
        
        usleep(10000) // will sleep for 10 milliseconds
        
        self.placeResources(on: grid)
        
        if let completionHandler = self.progressHandler {
            completionHandler(0.6, "resouces added")
        }
        
        usleep(10000) // will sleep for 10 milliseconds

		// 4th step: rivers
		self.identifySpringLocations(on: heightMap)
		let rivers = self.add(rivers: options.rivers, on: heightMap)
		self.put(rivers: rivers, onto: grid)

		if let completionHandler = self.progressHandler {
			completionHandler(0.7, "springs and rivers identified")
		}
        
        usleep(10000) // will sleep for 10 milliseconds
        
        // 5th step: features
        self.refineFeatures(on: grid)

        if let completionHandler = self.progressHandler {
            completionHandler(0.8, "features added")
        }
        
        usleep(10000) // will sleep for 10 milliseconds
        
        // 6th step: features
        self.refineNaturalWonders(on: grid)

        if let completionHandler = self.progressHandler {
            completionHandler(0.8, "natural wonders added")
        }
        
        usleep(10000) // will sleep for 10 milliseconds
        
        // 7th step: continents & oceans
        self.identifyContinents(on: grid)
        
        if let completionHandler = self.progressHandler {
            completionHandler(0.8, "continents identified")
        }
        
        usleep(10000) // will sleep for 10 milliseconds
        
        self.identifyOceans(on: grid)
        
        if let completionHandler = self.progressHandler {
            completionHandler(0.9, "oceans identified")
        }
        
        usleep(10000) // will sleep for 10 milliseconds
        
        self.identifyStartPositions(on: grid)
        
        if let completionHandler = self.progressHandler {
            completionHandler(0.9, "start positions identified")
        }
        
        usleep(10000) // will sleep for 10 milliseconds
        
        self.addGoodies(on: grid)
        
        if let completionHandler = self.progressHandler {
            completionHandler(0.99, "added goodies")
        }
        
        usleep(10000) // will sleep for 10 milliseconds

		return grid
	}

	// MARK: 1st step methods

	func waterOrLandFrom(elevation: Double, waterLevel: Double) -> PlotType {

		if elevation < waterLevel {
			return PlotType.sea
		}

		return PlotType.land
	}

	func fillFromElevation(withWaterPercentage waterPercentage: Double, on heightMap: HeightMap) {

        let waterLevel = heightMap.findThresholdBelow(percentage: waterPercentage)
        
		for x in 0..<width {
			for y in 0..<height {
				guard let height = heightMap[x, y] else {
					continue
				}

                self.plots[x, y] = self.waterOrLandFrom(elevation: height, waterLevel: waterLevel)
			}
		}
	}

	// MARK: 2nd step methods

	func setClimateZones() {

		self.climateZones.fill(with: .temperate)

		for x in 0..<width {
			for y in 0..<height {

				let latitude = abs(Double(height / 2 - y)) / Double(height / 2)

				if latitude > 0.9 || y == 0 || y == height - 1 {
					self.climateZones[x, y] = .polar
				} else if latitude > 0.65 {
					self.climateZones[x, y] = .subpolar
				} else if latitude > 0.4 {
					self.climateZones[x, y] = .temperate
				} else if latitude > 0.2 {
					self.climateZones[x, y] = .subtropic
				} else {
					self.climateZones[x, y] = .tropic
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
					self.climateZones[x, y] = self.climateZones[x, y]?.moderate
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
						if self.plots[x, y] == PlotType.sea {
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

        var landPlots: Int = 0
        
		for x in 0..<width {
			for y in 0..<height {
				let gridPoint = HexPoint(x: x, y: y)

				if self.plots[x, y] == PlotType.sea {

					if heightMap[x, y]! > 0.1 {
						grid?.set(terrain: .shore, at: gridPoint)
					} else {
						grid?.set(terrain: .ocean, at: gridPoint)
					}
				} else {
                    landPlots += 1
                    
                    self.updateBiome(at: gridPoint, on: grid, elevation: heightMap[x, y]!, moisture: moistureMap[x, y]!, climate: self.climateZones[x, y]!)
				}
			}
		}
        
        // get highest percent tiles from height map
        let combinedPercentage = self.options.mountainsPercentage * self.options.landPercentage
        let mountainThresold = heightMap.findThresholdAbove(percentage: combinedPercentage)
        
        var numberOfMountains: Int = 0
        
        for x in 0..<width {
            for y in 0..<height {
                let gridPoint = HexPoint(x: x, y: y)
                
                if heightMap[gridPoint]! >= mountainThresold {
                    grid?.set(feature: .mountains, at: gridPoint)
                    numberOfMountains += 1
                }
            }
        }
        
        print("Number of Mountains: \(numberOfMountains)")
	}
    
    private func blendTerrains(on gridRef: MapModel?) {
        
        guard let grid = gridRef else {
            fatalError("no grid")
        }
        
        // mglobal.hillsBlendPercent        = 0.45 -- Chance for flat land to become hills per near mountain. Requires at least 2 near mountains.
        let terrainBlendRange = 3       // range to smooth terrain (desert surrounded by plains turns to plains, etc)
        let terrainBlendRandom = 0.6  //random modifier for terrain smoothing
        
        
        let points = grid.points().shuffled
        
        for pt in points {
            
            guard let tile = grid.tile(at: pt) else {
                continue
            }
            
            if tile.isWater() {
                continue
            }
            
            let plotPercents = grid.plotStatistics(at: pt, radius: terrainBlendRange)
            let randPercent = 1.0 + Double.random * 2.0 * terrainBlendRandom - terrainBlendRandom
            
            if tile.feature() == .mountains {
                
                var numNearMountains = 0
                
                for neighbor in tile.point.neighbors() {
                    
                    guard let neighborTile = grid.tile(at: neighbor) else {
                        continue
                    }
                    
                    if neighborTile.feature() == .mountains {
                        numNearMountains += 1
                    }
                }
                
                if 2 <= numNearMountains && numNearMountains <= 4 {
                    self.createPossibleMountainPass(at: tile.point, on: gridRef)
                }
            } else {
                
                if tile.terrain() == .grass {
                    if plotPercents.desert + plotPercents.snow >= 0.33 * randPercent {
                        tile.set(terrain: .plains)
                        if tile.feature() == .marsh {
                            tile.set(feature: .forest)
                        }
                    }
                } else if tile.terrain() == .plains {
                    if plotPercents.desert >= 0.5 * randPercent {
                         // plot:SetTerrainType(TerrainTypes.TERRAIN_DESERT, true, true)
                    }
                } else if tile.terrain() == .desert {
                    if plotPercents.grass + plotPercents.snow >= 0.25 * randPercent {
                        tile.set(terrain: .plains)
                    } /*else if plotPercents.rainforest + plotPercents.MARSH >= 0.25 * randPercent {
                         plot:SetTerrainType(TerrainTypes.TERRAIN_PLAINS, true, true)
                    }*/
                } else if tile.feature() == .rainforest && tile.feature() == .marsh {
                    if plotPercents.snow + plotPercents.tundra + plotPercents.desert >= 0.25 * randPercent {
                        tile.set(feature: .none)
                    }
                } else if tile.terrain() == .tundra {
                    if 2.0 * plotPercents.grass + plotPercents.plains + plotPercents.desert >= 0.5 * randPercent {
                        tile.set(terrain: .plains)
                    }
                }
            }
        }
    }
    
    func createPossibleMountainPass(at point: HexPoint, on gridRef: MapModel?) {
        
        guard let grid = gridRef else {
            fatalError("no grid")
        }
        
        guard let plot = grid.tile(at: point) else {
            return
        }
        
        guard plot.feature() == .mountains else {
            return
        }
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = MoveTypeIgnoreUnitsPathfinderDataSource(in: grid, for: .walk, for: nil, options: MoveTypeIgnoreUnitsOptions(unitMapType: .civilian, canEmbark: false))
        
        var longestRoute = 0
        
        for dirA in 0...3 {
            
            guard let plotA = grid.tile(at: point.neighbor(in: HexDirection(rawValue: dirA)!)) else {
                continue
            }
            
            if plotA.terrain().isLand() && plotA.feature() != .mountains {
                
                for dirB in (dirA + 2)...5 {
                    
                    guard let plotB = grid.tile(at: point.neighbor(in: HexDirection(rawValue: dirB)!)) else {
                        continue
                    }
                    
                    if plotB.terrain().isLand() && plotB.feature() != .mountains {
                        
                        if let path = pathFinder.shortestPath(fromTileCoord: plotA.point, toTileCoord: plotB.point) {
                            longestRoute = max(longestRoute, path.count)
                        }
                        
                        if longestRoute == 0 || longestRoute > 15 {
                            print("-- CreatePossibleMountainPass path distance = \(longestRoute) - Change to Hills at \(point)")
                            plot.set(feature: .none)
                            plot.set(hills: true)
                        }
                    }
                }
            }
        }
    }
    
    private func refineFeatures(on gridRef: MapModel?) {
        
        guard let grid = gridRef else {
            fatalError("no grid")
        }
        
        // precheck
        // let polarPlots = self.climateZones.filter(where: { $0 == .polar })//.count
        
        // presets
        let rainForestPercent = 36
        let forestPercent = 22
        let marshPercent = 3
        let oasisPercent = 1
        let reefPercent = 5
        
        var waterTilesWithIcePossible: [HexPoint] = []
        var waterTilesWithReefPossible: [HexPoint] = []
        var landTilesWithFeaturePossible: [HexPoint] = []
        
        // statistics
        var iceFeatures: Int = 0
        var reefFeatures: Int = 0
        var floodPlainsFeatures: Int = 0
        var oasisFeatures: Int = 0
        var marshFeatures: Int = 0
        var rainForestFeatures: Int = 0
        var forestFeatures: Int = 0
        
        for x in 0..<width {
            for y in 0..<height {
                let gridPoint = HexPoint(x: x, y: y)
                
                guard let tile = grid.tile(at: gridPoint) else {
                    continue
                }
                
                if (tile.isImpassable(for: .walk) && tile.isImpassable(for: .swim)) || grid.feature(at: gridPoint) != .none {
                    continue
                }
                
                if tile.isWater() {

                    var canHaveIce = false
                    if grid.canHave(feature: .ice, at: gridPoint) && !grid.river(at: gridPoint) && (y == 0 || y == grid.size.height() - 1) /*&& self.climateZones[x, y] == .polar*/ {
                        waterTilesWithIcePossible.append(gridPoint)
                        canHaveIce = true
                    }
                    
                    if !canHaveIce && grid.canHave(feature: .reef, at: gridPoint) {
                        waterTilesWithReefPossible.append(gridPoint)
                    }
                } else {
                    landTilesWithFeaturePossible.append(gridPoint)
                }
            }
        }
        
        // ice ice baby
        for iceLocation in waterTilesWithIcePossible {
            gridRef?.set(feature: .ice, at: iceLocation)
            iceFeatures += 1
        }
        
        // reef reef baby
        for reefLocation in waterTilesWithReefPossible.shuffled {
            
            // 10% chance for reefs
            if (reefFeatures * 100 / waterTilesWithReefPossible.count) <= reefPercent {
                gridRef?.set(feature: .reef, at: reefLocation)
                reefFeatures += 1
            }
        }
        
        // second pass, add features to all land plots as appropriate based on the count and percentage of that type
        for featureLocation in landTilesWithFeaturePossible.shuffled {
            
            guard let featureTile = grid.tile(at: featureLocation) else {
                continue
            }
            
            if grid.canHave(feature: .floodplains, at: featureLocation) {
                gridRef?.set(feature: .floodplains, at: featureLocation)
                floodPlainsFeatures += 1
                
                continue
            } else if grid.canHave(feature: .oasis, at: featureLocation) && (oasisFeatures * 100 / landTilesWithFeaturePossible.count) <= oasisPercent {
                gridRef?.set(feature: .oasis, at: featureLocation)
                oasisFeatures += 1
                
                continue
            }
            
            if grid.canHave(feature: .marsh, at: featureLocation) && (marshFeatures * 100 / landTilesWithFeaturePossible.count) <= marshPercent {
                // First check to add Marsh
                gridRef?.set(feature: .marsh, at: featureLocation)
                marshFeatures += 1
            } else if grid.canHave(feature: .rainforest, at: featureLocation) && (rainForestFeatures * 100 / landTilesWithFeaturePossible.count) <= rainForestPercent {
                // First check to add Jungle
                gridRef?.set(feature: .rainforest, at: featureLocation)
                rainForestFeatures += 1
            } else if grid.canHave(feature: .forest, at: featureLocation) && (forestFeatures * 100 / landTilesWithFeaturePossible.count) <= forestPercent {
                // First check to add Forest
                gridRef?.set(feature: .forest, at: featureLocation)
                forestFeatures += 1
            }
        }
        
        // stats
        print("Number of Ices: \(iceFeatures)")
        print("Number of Reefs: \(reefFeatures)")
        print("Number of Floodplains: \(floodPlainsFeatures)")
        print("Number of Marshes: \(marshFeatures)")
        print("Number of Jungle: \(rainForestFeatures)")
        print("Number of Forest: \(forestFeatures)")
        print("Number of Oasis: \(oasisFeatures)")
    }
    
    private func refineNaturalWonders(on gridRef: MapModel?) {
        
        guard let grid = gridRef else {
            fatalError("no grid")
        }
        
        var possibleWonderSpots: [FeatureType: [HexPoint]] = [:]
        
        // init
        for naturalWonderType in FeatureType.naturalWonders {
            possibleWonderSpots[naturalWonderType] = []
        }
        
        for x in 0..<width {
            for y in 0..<height {
                let gridPoint = HexPoint(x: x, y: y)
                
                for naturalWonderType in FeatureType.naturalWonders.shuffled {
                    
                    if grid.canHave(feature: naturalWonderType, at: gridPoint) {

                        possibleWonderSpots[naturalWonderType]?.append(gridPoint)
                    }
                }
            }
        }
        
        for item in possibleWonderSpots.keys {
            print("Possible spots for \(item) = \(possibleWonderSpots[item]?.count)")
        }
    }

	// from http://www.redblobgames.com/maps/terrain-from-noise/
    func updateBiome(at point: HexPoint, on grid: MapModel?, elevation: Double, moisture: Double, climate: ClimateZone) {

		switch climate {
		case .polar:
            self.updateBiomeForPolar(at: point, on: grid, elevation: elevation, moisture: moisture)
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
    
    func updateBiomeForPolar(at point: HexPoint, on grid: MapModel?, elevation: Double, moisture: Double) {
        
        if Double.random > 0.5 {
            grid?.set(hills: true, at: point)
        }
        
        grid?.set(terrain: .snow, at: point)
    }

	func updateBiomeForSubpolar(at point: HexPoint, on grid: MapModel?, elevation: Double, moisture: Double) {
        
        if elevation > 0.7 && Double.random > 0.7 {
            grid?.set(hills: true, at: point)
            grid?.set(terrain: .snow, at: point)
            return
        }
        
		if elevation > 0.5 && Double.random > 0.6 {
            grid?.set(terrain: .snow, at: point)
			return
		}
        
        if Double.random > 0.85 {
            grid?.set(hills: true, at: point)
        }
        
        grid?.set(terrain: .tundra, at: point)
		return
	}

	func updateBiomeForTemperate(at point: HexPoint, on grid: MapModel?, elevation: Double, moisture: Double) {
        
        if elevation > 0.7 && Double.random > 0.7 {
            grid?.set(hills: true, at: point)
            grid?.set(terrain: .grass, at: point)
            return
        }
        
        if Double.random > 0.85 {
            grid?.set(hills: true, at: point)
        }

		if moisture < 0.5 {
			grid?.set(terrain: .plains, at: point)
            return
		} else {
			grid?.set(terrain: .grass, at: point)
            return
		}
	}

	func updateBiomeForSubtropic(at point: HexPoint, on grid: MapModel?, elevation: Double, moisture: Double) {
        
        if elevation > 0.7 && Double.random > 0.7 {
            grid?.set(hills: true, at: point)
            grid?.set(terrain: .plains, at: point)
            return
        }
        
        if Double.random > 0.85 {
            grid?.set(hills: true, at: point)
        }

		if moisture < 0.2 {
            if Double.random < 0.3 {
                grid?.set(terrain: .desert, at: point)
            } else {
                grid?.set(terrain: .plains, at: point)
            }
		} else if moisture < 0.6 {
			grid?.set(terrain: .plains, at: point)
		} else {
			grid?.set(terrain: .grass, at: point)
		}
	}

	func updateBiomeForTropic(at point: HexPoint, on grid: MapModel?, elevation: Double, moisture: Double) {
        
        if elevation > 0.7 && Double.random > 0.7 {
            grid?.set(hills: true, at: point)
            grid?.set(terrain: .plains, at: point)
            return
        }
        
        if Double.random > 0.85 {
            grid?.set(hills: true, at: point)
        }

        // arid
		if moisture < 0.3 {
            
            if Double.random < 0.4 {
                grid?.set(terrain: .desert, at: point)
            } else {
                grid?.set(terrain: .plains, at: point)
            }
		} else {
			grid?.set(terrain: .plains, at: point)
		}
	}

	// MARK: 4th step methods - river

	func identifySpringLocations(on heightMap: HeightMap) {

		self.springLocations.removeAll()

		for x in 0..<width {
			for y in 0..<height {

				if let height = heightMap[x, y] {
					if height > 0.8 {
						let gridPoint = HexPoint(x: x, y: y)
                        
                        // make sure no neighbors
                        let distancesToExistingSpringLocation = self.springLocations.map( { $0.distance(to: gridPoint) } )
                        if distancesToExistingSpringLocation.min() ?? 5 > 1 {
                            self.springLocations.append(gridPoint)
                        }
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

			let targetPlot = self.plots[lowestGridPointWithCorner.point.x, lowestGridPointWithCorner.point.y]

			if targetPlot != .sea {

				// TODO: river sometimes get stuck and end in lakes

				result.append(lowestGridPointWithCorner)
				let newRiverTile = self.followRiver(at: lowestGridPointWithCorner, on: heightMap, depth: depth - 1)
				result.append(contentsOf: newRiverTile)
			}
		}

		return result
	}

	func put(rivers: [River], onto grid: MapModel?) {

        // put river to map
		for river in rivers {
            grid?.add(river: river)
		}
        
        // update terrain if terrain is adjacent to river
        // A river will also turn adjacent flat desert tiles into flood plains, adjacent snow tiles to tundra tiles, and adjacent tundra tiles to plains.
        for x in 0..<width {
            for y in 0..<height {
                if let tile = grid?.tile(x: x, y: y) {
                
                    if tile.isRiver() {
                        if tile.terrain() == .desert {
                            tile.set(feature: .floodplains)
                        }
                        
                        if tile.terrain() == .tundra {
                            tile.set(terrain: .plains)
                        }
                        
                        if tile.terrain() == .snow {
                            tile.set(terrain: .tundra)
                        }
                    }
                }
            }
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
        
        // set area on plots
        for continent in continents {
            for point in continent.points {
                grid.set(continent: continent, at: point)
            }
        }
        
        print("found: \(continents.count) continents")
    }
    
    func identifyOceans(on grid: MapModel?) {
        
        guard let grid = grid else {
            return
        }
        
        let finder = OceanFinder(width: grid.size.width(), height: grid.size.height())
        let oceans = finder.execute(on: grid)
        
        grid.oceans = oceans
    }
    
    func identifyStartPositions(on grid: MapModel?) {
        
        guard let grid = grid else {
            return
        }
        
        let numberOfPlayers = self.options.numberOfPlayers

        let startPositioner = StartPositioner(on: grid, for: numberOfPlayers)
        startPositioner.generateRegions()
        
        let aiLeaders: [LeaderType] = LeaderType.all.filter({ $0 != self.options.leader }).choose(numberOfPlayers - 1)

        startPositioner.chooseLocations(for: aiLeaders, human: self.options.leader)
    
        grid.startLocations = startPositioner.startLocations
    }
}
