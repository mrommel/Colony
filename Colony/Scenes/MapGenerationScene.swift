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

class MapGenerationScene: SKScene {
    
    var progressBarNode: ProgressBarNode!
    weak var mapGenerationDelegate: MapGenerationDelegate?
    
    override init(size: CGSize) {

        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "menu")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.zPosition = 0
        background.size = (self.view?.bounds.size)!
        self.addChild(background)
        
        let hugeButton = MenuButtonNode(titled: "Huge", buttonAction: {
            DispatchQueue.global(qos: .background).async {
                self.startMapGeneration(mapSize: .huge, waterPercentage: 0.4, rivers: 8)
            }
        })
        hugeButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 80)
        hugeButton.zPosition = 1
        self.addChild(hugeButton)
        
        let standardButton = MenuButtonNode(titled: "Standard", buttonAction: {
            DispatchQueue.global(qos: .background).async {
                self.startMapGeneration(mapSize: .standard, waterPercentage: 0.3, rivers: 4)
            }
        })
        standardButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 30)
        standardButton.zPosition = 1
        self.addChild(standardButton)
        
        self.progressBarNode = ProgressBarNode(size: CGSize(width: 200, height: 40))
        self.progressBarNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 80)
        self.progressBarNode.zPosition = 1
        self.progressBarNode.set(progress: 0.0)
        self.addChild(self.progressBarNode)
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
}
