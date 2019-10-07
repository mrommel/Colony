//
//  MenuSceneExtension.swift
//  Colony
//
//  Created by Michael Rommel on 09.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

extension MenuScene {
    
    func requestMapType() {
        
        if let mapTypeDialog = UI.mapTypeDialog() {
            
            mapTypeDialog.zPosition = 250
            
            mapTypeDialog.addResultHandler(handler: { typeResult in
                
                let type = MapType.from(result: typeResult)
                
                mapTypeDialog.close()
                
                self.requestMapSizeFor(type: type)
            })
            
            mapTypeDialog.addCancelAction(handler: {
                self.rootNode.sharpWith(completion: {
                    mapTypeDialog.close()
                })
            })
            
            self.cameraNode.addChild(mapTypeDialog)
        }
    }
    
    func requestMapSizeFor(type: MapType) {
        
        if let mapSizeDialog = UI.mapSizeDialog() {
            
            mapSizeDialog.zPosition = 250
            
            mapSizeDialog.addResultHandler(handler: { sizeResult in
                
                mapSizeDialog.close()
                
                let size = MapSize.from(result: sizeResult)
                
                // handle earth maps
                switch type {
                case .earth:
                    self.loadEarthMap(sized: size)
                    
                case .pangaea:
                    print("not handled: pangaea")
                    self.show(message: "not implemented")
                    
                    // one main continent, some small islands
                    
                case .continents:
                    // 3-4 main continents, some small islands
                    let mapOptions = MapOptions(withSize: size)
                    mapOptions.enhanced.sealevel = .low
                    
                    self.generateMap(from: mapOptions)
 
                case .archipelago:
                    print("not handled: archipelago")
                    self.show(message: "not implemented")
                    
                    // 8-10 small continents/islands, some small islands
                    
                case .inlandsea:
                    print("not handled: inlandsea")
                    self.show(message: "not implemented")
                    
                    // all landmass - ocean in the middle
                    
                case .random:
                    // age (magnitude of hills/mountains)
                    // rainfall (more or less vegetation)
                    // temperature (climate zones change)
                    // sea level: low, middle, high
                    
                    self.requestMapAge(for: size)
                }
            })
            
            mapSizeDialog.addCancelAction(handler: {
                self.rootNode.sharpWith(completion: {
                    mapSizeDialog.close()
                })
            })
            
            self.cameraNode.addChild(mapSizeDialog)
        }
    }
    
    func requestMapAge(for size: MapSize) {
        
        if let mapAgeDialog = UI.mapAgeDialog() {
            
            mapAgeDialog.zPosition = 250
            
            mapAgeDialog.addResultHandler(handler: { ageResult in
                
                let age = MapOptionAge.from(result: ageResult)
                
                mapAgeDialog.close()
                
                self.requestMapRainfall(for: size, age: age)
            })
            
            mapAgeDialog.addCancelAction(handler: {
                self.rootNode.sharpWith(completion: {
                    mapAgeDialog.close()
                })
            })
            
            self.cameraNode.addChild(mapAgeDialog)
        }
    }
    
    func requestMapRainfall(for size: MapSize, age: MapOptionAge) {
        
        if let mapRainfallDialog = UI.mapRainfallDialog() {
            
            mapRainfallDialog.zPosition = 250
            
            mapRainfallDialog.addResultHandler(handler: { rainfallResult in
                
                let rainfall = MapOptionRainfall.from(result: rainfallResult)
                
                mapRainfallDialog.close()
                
                self.requestMapClimate(for: size, age: age, rainfall: rainfall)
            })
            
            mapRainfallDialog.addCancelAction(handler: {
                self.rootNode.sharpWith(completion: {
                    mapRainfallDialog.close()
                })
            })
            
            self.cameraNode.addChild(mapRainfallDialog)
        }
    }
    
    func requestMapClimate(for size: MapSize, age: MapOptionAge, rainfall: MapOptionRainfall) {
        
        if let mapClimateDialog = UI.mapClimateDialog() {
            
            mapClimateDialog.zPosition = 250
            
            mapClimateDialog.addResultHandler(handler: { climateResult in
                
                let climate = MapOptionClimate.from(result: climateResult)
                
                mapClimateDialog.close()
                
                self.requestMapSeaLevel(for: size, age: age, rainfall: rainfall, climate: climate)
            })
            
            mapClimateDialog.addCancelAction(handler: {
                self.rootNode.sharpWith(completion: {
                    mapClimateDialog.close()
                })
            })
            
            self.cameraNode.addChild(mapClimateDialog)
        }
    }
    
    func requestMapSeaLevel(for size: MapSize, age: MapOptionAge, rainfall: MapOptionRainfall, climate: MapOptionClimate) {
        
        if let mapSeaLevelDialog = UI.mapSeaLevelDialog() {
            
            mapSeaLevelDialog.zPosition = 250
            
            mapSeaLevelDialog.addResultHandler(handler: { seaLevelResult in
                
                let seaLevel = MapOptionSeaLevel.from(result: seaLevelResult)
                
                mapSeaLevelDialog.close()
                
                let options = MapOptions(withSize: size)
                var enhancedOptions = MapOptionsEnhanced()
                enhancedOptions.age = age
                enhancedOptions.rainfall = rainfall
                enhancedOptions.climate = climate
                enhancedOptions.sealevel = seaLevel
                options.enhanced = enhancedOptions
                
                self.generateMap(from: options)
                //self.requestMapTemperature(for: size, age: age, rainfall: rainfall)
            })
            
            mapSeaLevelDialog.addCancelAction(handler: {
                self.rootNode.sharpWith(completion: {
                    mapSeaLevelDialog.close()
                })
            })
            
            self.cameraNode.addChild(mapSeaLevelDialog)
        }
    }
}

extension MenuScene {
    
    func generateMap(from options: MapOptions) {
        
        if let mapLoadingDialog = UI.mapLoadingDialog() {
            
            mapLoadingDialog.zPosition = 250
            
            self.cameraNode.addChild(mapLoadingDialog)
            
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
    }
    
    func loadEarthMap(sized size: MapSize) {
        
        if let mapLoadingDialog = UI.mapLoadingDialog() {
            
            mapLoadingDialog.zPosition = 250
            
            self.cameraNode.addChild(mapLoadingDialog)
            
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
                self.loadMapAsync(from: url, progressHandler: { progress, text in
                    
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
    }
    
    func generateMapAsync(from options: MapOptions, progressHandler: @escaping (CGFloat, String) -> Void) {
        
        let generator = MapGenerator(with: options)
        generator.progressHandler = { progress, text in
            progressHandler(progress, text)
        }
        
        if let map = generator.generate() {
            self.rootNode.sharpWith(completion: {
                DispatchQueue.main.async {
                    self.menuDelegate?.startWith(map: map)
                }
            })
        }
    }
    
    func loadMapAsync(from url: URL?, progressHandler: @escaping (CGFloat, String) -> Void) {
        
        let mapUsecase = MapUsecase()
        if let map = mapUsecase.load(from: url) {
            
            progressHandler(0.4, "map loaded")
            
            let continentFinder = ContinentFinder(width: map.width, height: map.height)
            let continents = continentFinder.execute(on: map)
            map.continents = continents
            
            progressHandler(0.6, "found continent")
            
            let oceanFinder = OceanFinder(width: map.width, height: map.height)
            let oceans = oceanFinder.execute(on: map)
            map.oceans = oceans
            
            progressHandler(0.9, "found oceans")
            
            // not sure why
            map.fogManager?.map = map
            
            print("ready 0")
            progressHandler(1.0, "ready")
            
            self.rootNode.sharpWith(completion: {
                DispatchQueue.main.async {
                    
                    self.menuDelegate?.startWith(map: map)
                    print("ready 2")
                }
            })
        
        } else {
            DispatchQueue.main.async {
                //self.mapGenerationDelegate?.failed()
            }
        }
    }
    
    @available(iOS, deprecated: 12.0, message: "should not be used anymore")
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
    }
}
