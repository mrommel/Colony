//
//  GameLoadingScene.swift
//  SmartColony
//
//  Created by Michael Rommel on 03.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAssets

class GameLoadingScene: BaseScene {

    // variables
    var backgroundNode: SKSpriteNode?

    // delegate
    weak var gameDelegate: GameDelegate?

    private var progressBar: ProgressBarNode?

    // MARK: - Private class properties
    private var timer = Timer()
    private var progress: Double = 0.0

    var completion: (() -> Void)?

    override init(size: CGSize) {
        super.init(size: size, layerOrdering: .nodeLayerOnTop)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        super.didMove(to: view)

        let viewSize = (self.view?.bounds.size)!

        // background
        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode?.zPosition = 0
        self.backgroundNode?.size = viewSize
        self.rootNode.addChild(self.backgroundNode!)

        self.setup()

        self.fireTimer()

        self.preloadAssets(completion: {
            self.run(SKAction.wait(forDuration: 0.3), completion: {
                self.timer.invalidate()
                self.completion?()
            })
        })

        self.updateLayout()
    }

    private func setup() {

        let viewSize = (self.view?.bounds.size)!

        // background
        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.zPosition = 0
        self.backgroundNode?.size = viewSize
        self.rootNode.addChild(backgroundNode!)

        self.progressBar = ProgressBarNode(size: CGSize(width: 200, height: 40))
        self.progressBar?.set(progress: 0.0)
        self.progressBar?.position = CGPoint(x: 0.0, y: 0.0)
        self.progressBar?.zPosition = 5
        self.rootNode.addChild(self.progressBar!)

        self.updateLayout()
    }

    private func fireTimer() {
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(GameLoadingScene.animateLoadingBar),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func animateLoadingBar() {

        self.progress += 0.0333
        self.progressBar?.set(progress: self.progress)
    }

    private func preloadAssets(completion: (() -> Void)!) {

        // load assets into image cache
        print("-- pre-load images --")
        let bundle = Bundle.init(for: Textures.self)
        let textures = Textures(game: nil)

        print("- load \(textures.allTerrainTextureNames.count) terrain, " +
              "\(textures.allRiverTextureNames.count) river and " +
              "\(textures.allCoastTextureNames.count) coast textures")
        for textureName in textures.allTerrainTextureNames {
            ImageCache.shared.add(image: UIImage(named: textureName, in: bundle, with: nil), for: textureName)
        }

        for textureName in textures.allCoastTextureNames {
            ImageCache.shared.add(image: UIImage(named: textureName, in: bundle, with: nil), for: textureName)
        }

        for textureName in textures.allRiverTextureNames {
            ImageCache.shared.add(image: UIImage(named: textureName, in: bundle, with: nil), for: textureName)
        }

        print("- load \(textures.allFeatureTextureNames.count) feature (+ \(textures.allIceFeatureTextureNames.count) ice) textures")
        for textureName in textures.allFeatureTextureNames {
            ImageCache.shared.add(image: UIImage(named: textureName, in: bundle, with: nil), for: textureName)
        }

        for textureName in textures.allIceFeatureTextureNames {
            ImageCache.shared.add(image: UIImage(named: textureName, in: bundle, with: nil), for: textureName)
        }

        print("- load \(textures.allResourceTextureNames.count) resource textures")
        for textureName in textures.allResourceTextureNames {
            ImageCache.shared.add(image: UIImage(named: textureName, in: bundle, with: nil), for: textureName)
        }

        print("-- all textures loaded --")

        completion()
    }

    deinit {
        self.timer.invalidate()
    }
}
