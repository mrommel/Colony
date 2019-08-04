//
//  MapGenerationScene.swift
//  Colony
//
//  Created by Michael Rommel on 02.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol MapGenerationDelegate: class {
    
    func generated(map: HexagonTileMap)
}

class MapGenerationScene: BaseScene {
    
    // nodes
    var backgroundNode: SKSpriteNode!
    var hugeButton: MenuButtonNode!
    var standardButton: MenuButtonNode!
    var earthButton: MenuButtonNode!
    var progressBarNode: ProgressBarNode!
    
    weak var mapGenerationDelegate: MapGenerationDelegate?
    
    override init(size: CGSize) {

        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode.zPosition = 0
        self.backgroundNode.size = (self.view?.bounds.size)!
        self.addChild(self.backgroundNode)
        
        self.hugeButton = MenuButtonNode(titled: "Huge", buttonAction: {
            DispatchQueue.global(qos: .background).async {
                self.startMapGeneration(mapSize: .huge, waterPercentage: 0.4, rivers: 8)
            }
        })
        self.hugeButton.zPosition = 1
        self.addChild(self.hugeButton)
        
        self.standardButton = MenuButtonNode(titled: "Standard", buttonAction: {
            DispatchQueue.global(qos: .background).async {
                self.startMapGeneration(mapSize: .standard, waterPercentage: 0.3, rivers: 4)
            }
        })
        self.standardButton.zPosition = 1
        self.addChild(self.standardButton)
        
        self.earthButton = MenuButtonNode(titled: "Earth", buttonAction: {
            DispatchQueue.global(qos: .background).async {
                self.loadMapAsync()
            }
        })
        self.earthButton.zPosition = 1
        self.addChild(self.earthButton)
        
        self.progressBarNode = ProgressBarNode(size: CGSize(width: 200, height: 40))
        self.progressBarNode.zPosition = 1
        self.progressBarNode.set(progress: 0.0)
        self.addChild(self.progressBarNode)
        
        self.updateLayout()
    }
    
    func startMapGeneration(mapSize: MapSize, waterPercentage: Float, rivers: Int) {
        
        let options = MapGeneratorOptions(withSize: mapSize, zone: .earth, waterPercentage: waterPercentage, rivers: rivers)
        
        let generator = MapGenerator(width: mapSize.width, height: mapSize.height)
        generator.progressHandler = { progress in
            
            DispatchQueue.main.async {
                let progressValue: CGFloat = CGFloat(progress)
                //print("progress: \(progressValue)")
                self.progressBarNode.set(progress: progressValue)
            }
        }
        
        if let map = generator.generate(with: options) {
            
            DispatchQueue.main.async {
                self.mapGenerationDelegate?.generated(map: map)
            }
        }
    }
    
    func loadMapAsync() {
        
        let civ5MapReader = Civ5MapReader()
        //let civ5MapUrl = R.file.earth_HugeCiv5Map()
        let civ5MapUrl = R.file.accurate_EarthCiv5Map()
        guard let civ5Map = civ5MapReader.load(from: civ5MapUrl) else {
            fatalError("Map could not be loaded")
        }
        
        DispatchQueue.main.async {
            self.progressBarNode.set(progress: 0.2)
        }
        
        guard let map = civ5Map.toMap() else {
            fatalError("civ5 Map could not be transformed into custom formet")
        }
        
        DispatchQueue.main.async {
            self.progressBarNode.set(progress: 0.4)
        }
        
        let continentFinder = ContinentFinder(width: map.width, height: map.height)
        let continents = continentFinder.execute(on: map)
        map.continents = continents
        
        DispatchQueue.main.async {
            self.progressBarNode.set(progress: 0.6)
        }
        
        let oceanFinder = OceanFinder(width: map.width, height: map.height)
        let oceans = oceanFinder.execute(on: map)
        map.oceans = oceans
        
        DispatchQueue.main.async {
            self.progressBarNode.set(progress: 0.9)
        }

        DispatchQueue.main.async {
            self.mapGenerationDelegate?.generated(map: map)
        }
    }
    
    override func updateLayout() {
        
        super.updateLayout()
        
        let viewSize = (self.view?.bounds.size)!
        let backgroundTileHeight = 812 * viewSize.width / 375
        
        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.size = CGSize(width: viewSize.width, height: backgroundTileHeight)
        
        self.standardButton.position = CGPoint(x: 0, y: 0 + 30)
        self.hugeButton.position = CGPoint(x: 0, y: 80)
        self.earthButton.position = CGPoint(x: 0, y: 130)
        
        self.progressBarNode.position = CGPoint(x: 0, y: -80)
    }
}
