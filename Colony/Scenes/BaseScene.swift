//
//  BaseSkene.swift
//  Colony
//
//  Created by Michael Rommel on 31.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class BaseScene: SKScene {

    // nodes
    var safeAreaNode: SafeAreaNode!
    var rootNode: BlurrableNode!
    var cameraNode: SKCameraNode!

    var messages: [NotificationNode] = []

    override init(size: CGSize) {

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        // camera
        self.cameraNode = SKCameraNode() // initialize and assign an instance of SKCameraNode to the cam variable.
        self.cameraNode.zPosition = 50.0
        self.camera = self.cameraNode // set the scene's camera to reference cam
        super.addChild(self.cameraNode) // make the cam a childElement of the scene itself.

        // the safeAreaNode holds the main UI
        self.safeAreaNode = SafeAreaNode()
        self.safeAreaNode.zPosition = 50.0
        self.cameraNode.addChild(self.safeAreaNode)

        // blurrable node
        self.rootNode = BlurrableNode()
        self.rootNode.zPosition = 1.5
        super.addChild(self.rootNode)

        self.safeAreaNode.updateLayout()
    }
    
    override func addChild(_ node: SKNode) {
        fatalError("can't add child to node anymore - use something else")
    }

    func blurWithCompletion() {

        let duration: CGFloat = 0.5
        let filter: CIFilter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": NSNumber(value: 1.0)])!
        self.filter = filter
        self.shouldRasterize = true
        self.shouldEnableEffects = true
        self.run(SKAction.customAction(withDuration: TimeInterval(duration), actionBlock: { (node: SKNode, elapsedTime: CGFloat) in
                let radius = (elapsedTime / duration) * 10.0
                (node as? SKEffectNode)!.filter!.setValue(radius, forKey: "inputRadius")
            }))
    }

    func updateLayout() {

        self.safeAreaNode.updateLayout()
        
        self.rootNode.renderNodeHieararchy()
        self.cameraNode.renderNodeHieararchy()
    }

    func show(message: String, for seconds: TimeInterval = 5.0) {

        let notificationNode = NotificationNode(message: message)
        notificationNode.zPosition = GameScene.Constants.ZLevels.messages // on top of everything
        notificationNode.position = self.nextNotificationPosition()
        notificationNode.alpha = 0

        self.safeAreaNode.addChild(notificationNode)

        self.messages.append(notificationNode)
        self.updateMessages()

        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let display = SKAction.wait(forDuration: seconds)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let flashAction = SKAction.sequence([fadeIn, display, fadeOut])

        notificationNode.run(flashAction, completion: {
            notificationNode.removeFromParent()
            self.messages.removeFirst()
            self.updateMessages()
        })
    }

    private func nextNotificationPosition() -> CGPoint {

        let posY = self.size.halfHeight - 50
        return CGPoint(x: 0, y: posY - 36.0 * CGFloat(self.messages.count))
    }

    private func updateMessages() {

        var posY = self.size.halfHeight - 50
        for message in self.messages {

            let moveAction = SKAction.move(to: CGPoint(x: 0, y: posY), duration: 0.5)
            message.run(moveAction)

            posY -= 36
        }
    }
}
