//
//  BaseScene.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SpriteKit

enum BaseSceneLayerOrdering {
    
    case cameraLayerOnTop
    case nodeLayerOnTop
}

class BaseScene: SKScene {

    // nodes
    var safeAreaNode: SafeAreaNode!
    var rootNode: BlurrableNode!
    var cameraNode: SKCameraNode!
    
    // layer ordering
    let layerOrdering: BaseSceneLayerOrdering
    
    override init(size: CGSize) {
        
        self.layerOrdering = .cameraLayerOnTop
        super.init(size: size)
    }
    
    init(size: CGSize, layerOrdering: BaseSceneLayerOrdering) {
        
        self.layerOrdering = layerOrdering
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
        
        self.setupLayer()
        
        self.safeAreaNode.updateLayout()
    }
    
    override func addChild(_ node: SKNode) {
        fatalError("can't add child to node anymore - use something else")
    }
    
    private func setupLayer() {
        
        switch self.layerOrdering {
            
        case .cameraLayerOnTop:
            self.cameraNode.zPosition = 50.0
            self.safeAreaNode.zPosition = 50.0
            self.rootNode.zPosition = 1.5
            
        case .nodeLayerOnTop:
            self.cameraNode.zPosition = 50.0
            self.safeAreaNode.zPosition = 50.0
            self.rootNode.zPosition = 51.0
        }
    }
    
    func updateLayout() {
        
        self.safeAreaNode.updateLayout()
        
        // debug
        // self.rootNode.renderNodeHierarchy()
        // self.cameraNode.renderNodeHierarchy()
    }
}
