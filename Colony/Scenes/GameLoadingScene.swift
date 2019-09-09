//
//  GameLoadingScene.swift
//  Colony
//
//  Created by Michael Rommel on 08.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class GameLoadingScene: BaseScene {
    
    // UI
    private var backgroundNode: SKSpriteNode?
    private var progressBar: ProgressBarNode?
    
    // MARK: - Private class properties
    private var timer = Timer()
    private var progress: CGFloat = 0.0
    
    var completion: (() -> Void)?
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // Background
        self.backgroundColor = SKColor.black
        
        self.setup()
        
        self.fireTimer()
        
        self.preloadAssets(completion: {
            self.run(SKAction.wait(forDuration: 1.0), completion: {
                self.completion?()
            })
        })
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
    
    override func updateLayout() {
        
        super.updateLayout()
        
        let viewSize = (self.view?.bounds.size)!
        self.backgroundNode?.aspectFillTo(size: viewSize)
    }
    
    private func fireTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(GameLoadingScene.animateLoadingBar), userInfo: nil, repeats: true)
    }
    
    @objc func animateLoadingBar() {

        self.progress += 0.25
        self.progressBar?.set(progress: self.progress)
    }
    
    private func preloadAssets(completion: (() -> Void)!) {
        // Load your assets
        
        completion()
    }

    deinit {
        self.timer.invalidate()
    }
}
