//
//  MenuSceneExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

extension MenuScene {
    
    func requestLeader() {
        
        let gameLeaderDialog = GameLeaderDialog()
            
        gameLeaderDialog.zPosition = 250
        
        gameLeaderDialog.addResultHandler(handler: { typeResult in
            
            let leaderType = typeResult.toLeaderType()
            
            gameLeaderDialog.close()
            
            self.requestMapType(for: leaderType)
        })
        
        gameLeaderDialog.addCancelAction(handler: {
            self.rootNode.sharpWith(completion: {
                gameLeaderDialog.close()
            })
        })
        
        self.cameraNode.add(dialog: gameLeaderDialog)
    }
    
    func requestHandicapFor(type: MapType, size: MapSize, and leader: LeaderType) {
        
        let gameHandicapDialog = GameHandicapDialog()
            
        gameHandicapDialog.zPosition = 250
        
        gameHandicapDialog.addResultHandler(handler: { typeResult in
            
            let handicapType = typeResult.toHandicapType()
            
            gameHandicapDialog.close()
            
            // handle earth maps
            switch type {
            case .earth:
                self.loadEarthMap(sized: size, leader: leader, handicap: handicapType)
               
            case .continents:
                // 3-4 main continents, some small islands
                let mapOptions = MapOptions(withSize: size, leader: leader, handicap: handicapType)
                mapOptions.enhanced.sealevel = .low
               
                self.generateMap(from: mapOptions)

            case .pangaea:
                print("not handled: pangaea")
                fatalError("not implemented")
            
                // one main continent, some small islands
                
            case .archipelago:
                print("not handled: archipelago")
                fatalError("not implemented")
               
                // 8-10 small continents/islands, some small islands
               
            case .inlandsea:
                print("not handled: inlandsea")
                fatalError("not implemented")
               
                // all landmass - ocean in the middle
               
            case .custom:
                // age (magnitude of hills/mountains)
                // rainfall (more or less vegetation)
                // temperature (climate zones change)
                // sea level: low, middle, high
               
                self.requestMapAge(for: size, and: leader, handicap: handicapType)
            }
        })
        
        gameHandicapDialog.addCancelAction(handler: {
            self.rootNode.sharpWith(completion: {
                gameHandicapDialog.close()
            })
        })
        
        self.cameraNode.add(dialog: gameHandicapDialog)
    }
    
    func requestMapType(for leader: LeaderType) {
        
        let mapTypeDialog = MapTypeDialog()
            
        mapTypeDialog.zPosition = 250
        
        mapTypeDialog.addResultHandler(handler: { typeResult in
            
            let type = typeResult.toMapType()
            
            mapTypeDialog.close()
            
            self.requestMapSizeFor(type: type, and: leader)
        })
        
        mapTypeDialog.addCancelAction(handler: {
            self.rootNode.sharpWith(completion: {
                mapTypeDialog.close()
            })
        })
        
        self.cameraNode.add(dialog: mapTypeDialog)
    }

    func requestMapSizeFor(type: MapType, and leader: LeaderType) {
           
        let mapSizeDialog = MapSizeDialog()
               
        mapSizeDialog.zPosition = 250
       
        mapSizeDialog.addResultHandler(handler: { sizeResult in
           
            mapSizeDialog.close()
           
            let size = sizeResult.toMapSize()
           
            self.requestHandicapFor(type: type, size: size, and: leader)
        })
       
        mapSizeDialog.addCancelAction(handler: {
            self.rootNode.sharpWith(completion: {
                mapSizeDialog.close()
            })
        })
       
        self.cameraNode.add(dialog: mapSizeDialog)
    }
       
    func requestMapAge(for size: MapSize, and leader: LeaderType, handicap: HandicapType) {
           
        let mapAgeDialog = MapAgeDialog()
               
        mapAgeDialog.zPosition = 250
               
        mapAgeDialog.addResultHandler(handler: { ageResult in
                   
            let age = ageResult.toMapOptionAge()
                   
            mapAgeDialog.close()
                   
            self.requestMapRainfall(for: size, leader: leader, handicap: handicap, age: age)
        })
               
        mapAgeDialog.addCancelAction(handler: {
            self.rootNode.sharpWith(completion: {
                mapAgeDialog.close()
            })
        })
               
        self.cameraNode.add(dialog: mapAgeDialog)
    }
       
    func requestMapRainfall(for size: MapSize, leader: LeaderType, handicap: HandicapType, age: MapOptionAge) {

        let mapRainfallDialog = MapRainfallDialog()
               
        mapRainfallDialog.zPosition = 250
               
        mapRainfallDialog.addResultHandler(handler: { rainfallResult in
                   
            let rainfall = rainfallResult.toMapOptionRainfall()
                   
            mapRainfallDialog.close()
                   
            self.requestMapClimate(for: size, leader: leader, handicap: handicap, age: age, rainfall: rainfall)
        })
               
        mapRainfallDialog.addCancelAction(handler: {
            self.rootNode.sharpWith(completion: {
                mapRainfallDialog.close()
            })
        })
               
        self.cameraNode.add(dialog: mapRainfallDialog)
    }
       
    func requestMapClimate(for size: MapSize, leader: LeaderType, handicap: HandicapType, age: MapOptionAge, rainfall: MapOptionRainfall) {
           
        let mapClimateDialog = MapClimateDialog()
               
        mapClimateDialog.zPosition = 250
               
        mapClimateDialog.addResultHandler(handler: { climateResult in
                   
            let climate = climateResult.toMapOptionClimate()
                   
            mapClimateDialog.close()
                   
            self.requestMapSeaLevel(for: size, leader: leader, handicap: handicap, age: age, rainfall: rainfall, climate: climate)
        })
               
        mapClimateDialog.addCancelAction(handler: {
            self.rootNode.sharpWith(completion: {
                mapClimateDialog.close()
            })
        })
               
        self.cameraNode.add(dialog: mapClimateDialog)
    }
       
    func requestMapSeaLevel(for size: MapSize, leader: LeaderType, handicap: HandicapType, age: MapOptionAge, rainfall: MapOptionRainfall, climate: MapOptionClimate) {
           
        let mapSeaLevelDialog = MapSeaLevelDialog()
               
        mapSeaLevelDialog.zPosition = 250
               
        mapSeaLevelDialog.addResultHandler(handler: { seaLevelResult in
                   
            let seaLevel = seaLevelResult.toMapOptionSeaLevel()
                   
            mapSeaLevelDialog.close()
               
            let options = MapOptions(withSize: size, leader: leader, handicap: handicap)
            
            var enhancedOptions = MapOptionsEnhanced()
            enhancedOptions.age = age
            enhancedOptions.rainfall = rainfall
            enhancedOptions.climate = climate
            enhancedOptions.sealevel = seaLevel
            enhancedOptions.resources = .standard // <== ???
            
            options.enhanced = enhancedOptions
               
            self.generateMap(from: options)
        })
               
        mapSeaLevelDialog.addCancelAction(handler: {
            self.rootNode.sharpWith(completion: {
                mapSeaLevelDialog.close()
            })
        })
               
        self.cameraNode.add(dialog: mapSeaLevelDialog)
    }
}

extension MenuScene {
    
    func generateMap(from options: MapOptions) {
        
        let mapLoadingDialog = MapLoadingDialog()
            
        mapLoadingDialog.zPosition = 250
            
        self.cameraNode.add(dialog: mapLoadingDialog)
            
        DispatchQueue.global(qos: .background).async {
            
            self.generateMapAsync(from: options, progressHandler: { progress, text in
                
                DispatchQueue.main.async {
                    mapLoadingDialog.showProgress(value: progress, text: text)
                    
                    if progress == 1.0 {
                        self.rootNode.sharpWith(completion: {
                            mapLoadingDialog.close()
                        })
                    }
                }
            })
        }
    }
    
    func loadEarthMap(sized size: MapSize, leader: LeaderType, handicap: HandicapType) {
        
        let mapLoadingDialog = MapLoadingDialog()
            
        mapLoadingDialog.zPosition = 250
        
        self.cameraNode.add(dialog: mapLoadingDialog)
        
        var url: URL? = nil
        switch size {
        case .huge:
            url = R.file.earth_hugeMap()
        case .large:
            url = R.file.earth_largeMap()
        case .standard:
            url = R.file.earth_standardMap()
        case .small:
            url = R.file.earth_smallMap()
        case .tiny:
            fatalError("not handled: tiny earth")
        default:
            fatalError("not handled: \(size)")
        }
        
        DispatchQueue.global(qos: .background).async {
            self.loadMapAsync(from: url, leader: leader, with: handicap, progressHandler: { progress, text in
                
                DispatchQueue.main.async {
                    mapLoadingDialog.showProgress(value: progress, text: text)
                    
                    if progress == 1.0 {
                        print("ready 1")
                        mapLoadingDialog.close()
                    }
                }
            })
        }
    }
    
    func generateMapAsync(from options: MapOptions, progressHandler: @escaping (Double, String) -> Void) {
        
        let generator = MapGenerator(with: options)
        
        generator.progressHandler = { progress, text in
            progressHandler(progress, text)
        }
        
        if let map = generator.generate() {
            self.rootNode.sharpWith(completion: {
                DispatchQueue.main.async {
                    self.menuDelegate?.startWith(map: map, leader: options.leader, handicap: options.handicap)
                }
            })
        }
    }
    
    func loadMapAsync(from url: URL?, leader: LeaderType, with handicap: HandicapType, progressHandler: @escaping (Double, String) -> Void) {
        
        let mapLoader = MapLoader()
        if let map = mapLoader.load(from: url) {
            
            progressHandler(0.4, "map loaded")
            
            /*let continentFinder = ContinentFinder(size: map.size)
            let continents = continentFinder.execute(on: map)
            map.set(continents: continents)
            
            progressHandler(0.6, "found continent")
            
            let oceanFinder = OceanFinder(size: map.size)
            let oceans = oceanFinder.execute(on: map)
            map.set(oceans: oceans)
            
            progressHandler(0.9, "found oceans")*/
            
            // not sure why
            // map.fogManager?.map = map
            
            print("ready 0")
            progressHandler(1.0, "ready")
            
            self.rootNode.sharpWith(completion: {
                DispatchQueue.main.async {
                    
                    self.menuDelegate?.startWith(map: map, leader: leader, handicap: handicap)
                    print("ready 2")
                }
            })
        
        } else {
            
            progressHandler(1.0, "failure")
            
            self.rootNode.sharpWith(completion: {
                DispatchQueue.main.async {
                    //self.mapGenerationDelegate?.failed()
                    print("failed")
                }
            })
        }
    }
    
    /*@available(iOS, deprecated: 12.0, message: "should not be used anymore")
    func loadCiv5MapAsync(from url: URL?, progressHandler: @escaping (CGFloat, String) -> Void) {
        
        let civ5MapReader = Civ5MapReader()
        guard let civ5Map = civ5MapReader.load(from: url) else {
            fatalError("Map could not be loaded")
        }
        
        progressHandler(0.2, "def")
        
        guard let map = civ5Map.toMap() else {
            fatalError("civ5 Map could not be transformed into custom formet")
        }
        
        progressHandler(0.4, "abc")
        
        let continentFinder = ContinentFinder(width: map.width, height: map.height)
        let continents = continentFinder.execute(on: map)
        map.continents = continents
        
        progressHandler(0.6, "abc")
        
        let oceanFinder = OceanFinder(width: map.width, height: map.height)
        let oceans = oceanFinder.execute(on: map)
        map.oceans = oceans
        
        progressHandler(0.9, "abc")
        
        let mapUsecase = MapUsecase()
        mapUsecase.store(map: map, to: "map.map")
        
        DispatchQueue.main.async {
            //self.menuDelegate?.startWith(map: map)
        }
    }*/
}
