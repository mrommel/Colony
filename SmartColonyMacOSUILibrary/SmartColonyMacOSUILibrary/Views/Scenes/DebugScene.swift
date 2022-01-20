//
//  DebugScene.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 20.01.22.
//

import Foundation
import SpriteKit
import SmartAILibrary
import SmartAssets

class DebugScene: BaseScene {

    // MARK: constructors

    override init(size: CGSize) {

        super.init(size: size, layerOrdering: .nodeLayerOnTop)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: methods

    #if os(watchOS)
    override func sceneDidLoad() {
        self.setupScene(to: self.view)
    }
    #else
    override func didMove(to view: SKView) {

        super.didMove(to: view)
        self.setupScene(to: view)
    }
    #endif

    func setupScene(to view: SKView) {

        /*let redBox: SKSpriteNode = SKSpriteNode(color: SKColor.red, size: CGSize.init(width: 128, height: 128))
        redBox.run(SKAction.repeatForever(SKAction.rotate(byAngle: 6, duration: 2)))
        self.rootNode.addChild(redBox)*/
        let bundle = Bundle.init(for: Textures.self)
        ImageCache.shared.add(
            image: bundle.image(forResource: "box-gold"),
            for: "box-gold"
        )

        let tooltipNode1 = TooltipNode(text: "27 [Production] Production, 25 [Gold] Gold")
        tooltipNode1.position = CGPoint(x: 0, y: -40)
        self.rootNode.addChild(tooltipNode1)

        let tooltipNode2 = TooltipNode(text: "[Capital] Berlin lorem ipsum 12 [Faith] Faith")
        tooltipNode2.position = CGPoint(x: 0, y: 0)
        self.rootNode.addChild(tooltipNode2)

        // position the camera on the gamescene.
        self.cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)

        // the scale sets the zoom level of the camera on the given position
        self.cameraNode.xScale = CGFloat(0.25)
        self.cameraNode.yScale = CGFloat(0.25)

        print("DebugScene setup successful")
    }
}
