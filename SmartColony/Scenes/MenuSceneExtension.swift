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
            case .empty:
                print("not handled: empty")
                fatalError("not implemented")
                
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
                //print("not handled: archipelago")
                //fatalError("not implemented")
               
                // 8-10 small continents/islands, some small islands
                let mapOptions = MapOptions(withSize: size, leader: leader, handicap: handicapType)
                mapOptions.enhanced.sealevel = .high
               
                self.generateMap(from: mapOptions)
               
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
        
        var mapParameter: MapModel?
        let mapLoadingDialogViewModel = MapLoadingDialogViewModel(from: options.leader)
        let mapLoadingDialog = MapLoadingDialog(with: mapLoadingDialogViewModel)
            
        mapLoadingDialog.zPosition = 250
        mapLoadingDialog.addOkayAction(handler: {
            self.rootNode.sharpWith(completion: {
                DispatchQueue.main.async {
                    mapLoadingDialog.close()
                    self.menuDelegate?.startWith(map: mapParameter, leader: options.leader, handicap: options.handicap)
                }
            })
        })
            
        self.cameraNode.add(dialog: mapLoadingDialog)
            
        DispatchQueue.global(qos: .background).async {
            
            let generator = MapGenerator(with: options)
            generator.progressHandler = { progress, text in
                mapLoadingDialog.showProgress(value: progress, text: text)
            }
            
            if let map = generator.generate() {
                
                mapParameter = map
                
                // show okay button
                mapLoadingDialog.showBeginGameButton()
            }
        }
    }
    
    func loadEarthMap(sized size: MapSize, leader: LeaderType, handicap: HandicapType) {
        
        var mapParameter: MapModel?
        let mapLoadingDialogViewModel = MapLoadingDialogViewModel(from: leader)
        let mapLoadingDialog = MapLoadingDialog(with: mapLoadingDialogViewModel)
            
        mapLoadingDialog.zPosition = 250
        mapLoadingDialog.addOkayAction(handler: {
            
            self.rootNode.sharpWith(completion: {
                mapLoadingDialog.close()
                
                self.menuDelegate?.startWith(map: mapParameter, leader: leader, handicap: handicap)
            })
        })
        
        self.cameraNode.add(dialog: mapLoadingDialog)
        
        var url: URL?
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
        
        mapLoadingDialog.showProgress(value: 0.1, text: "Start Loading")
        
        DispatchQueue.global(qos: .background).async {
            let mapLoader = MapLoader()
            if let map = mapLoader.load(from: url, for: leader) {
                
                var volcanoPoints: [HexPoint] = []
                
                // post process
                for pt in map.points() {
                    if map.feature(at: pt) == .volcano {
                        volcanoPoints.append(pt)
                        map.set(feature: .mountains, at: pt)
                    }
                }
                
                for pt in volcanoPoints.shuffle().suffix(3) {
                    map.set(feature: .volcano, at: pt)
                }
                
                mapParameter = map
                
                DispatchQueue.main.async {
                    mapLoadingDialog.showProgress(value: 1.0, text: "Ready")

                    // show okay button
                    mapLoadingDialog.showBeginGameButton()
                }
            } else {
                
                print("failed map loading")
                
                self.rootNode.sharpWith(completion: {
                    mapLoadingDialog.close()
                })
            }
        }
    }
}
