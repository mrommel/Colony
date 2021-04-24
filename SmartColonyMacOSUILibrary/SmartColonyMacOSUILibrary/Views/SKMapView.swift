//
//  SKMapView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SwiftUI
import SpriteKit
import SmartAILibrary
import SmartAssets

class MapNode: SKNode {

    // MARK: layer

    var terrainLayer: TerrainLayer
    var featureLayer: FeatureLayer
    /*var resourceLayer: ResourceLayer
    var resourceMarkerLayer: ResourceMarkerLayer
    var boardLayer: BoardLayer
    var riverLayer: RiverLayer
    
    // can be shown by map options
    var yieldLayer: YieldLayer
    var waterLayer: WaterLayer
    
    var unitLayer: UnitLayer
    var cityLayer: CityLayer
    var improvementLayer: ImprovementLayer
    var borderLayer: BorderLayer
    var tooltipLayer: TooltipLayer*/

    // MARK: properties

    private var game: GameModel?

    // MARK: constructors
    
    init(with game: GameModel?) {

        self.game = game
        
        guard let game = self.game else {
            fatalError("cant get game")
        }
        
        let humanPlayer = game.humanPlayer()

        self.terrainLayer = TerrainLayer(player: humanPlayer)
        self.terrainLayer.populate(with: self.game)
        self.terrainLayer.zPosition = Globals.ZLevels.terrain
        
        /*self.borderLayer = BorderLayer(player: humanPlayer)
        self.borderLayer.populate(with: self.game)
        self.borderLayer.zPosition = Globals.ZLevels.border*/

        self.featureLayer = FeatureLayer(player: humanPlayer)
        self.featureLayer.populate(with: self.game)
        self.featureLayer.zPosition = Globals.ZLevels.feature
        
        /*self.resourceLayer = ResourceLayer(player: humanPlayer)
        self.resourceLayer.populate(with: self.game)
        self.resourceLayer.zPosition = Globals.ZLevels.resource
        
        self.resourceMarkerLayer = ResourceMarkerLayer(player: humanPlayer)
        self.resourceMarkerLayer.populate(with: self.game)
        self.resourceMarkerLayer.zPosition = Globals.ZLevels.resourceMarker

        self.boardLayer = BoardLayer(player: humanPlayer)
        self.boardLayer.populate(with: self.game)
        self.boardLayer.zPosition = Globals.ZLevels.caldera

        self.riverLayer = RiverLayer(player: humanPlayer)
        self.riverLayer.populate(with: self.game)
        
        self.unitLayer = UnitLayer(player: humanPlayer)
        self.unitLayer.populate(with: self.game)
        self.unitLayer.zPosition = Globals.ZLevels.unit
        
        self.cityLayer = CityLayer(player: humanPlayer)
        self.cityLayer.populate(with: self.game)
        self.cityLayer.zPosition = Globals.ZLevels.city
        
        self.improvementLayer = ImprovementLayer(player: humanPlayer)
        self.improvementLayer.populate(with: self.game)
        self.improvementLayer.zPosition = Globals.ZLevels.improvement

        self.yieldLayer = YieldLayer(player: humanPlayer)
        self.yieldLayer.populate(with: self.game)
        self.yieldLayer.zPosition = Globals.ZLevels.yields
        
        self.waterLayer = WaterLayer(player: humanPlayer)
        self.waterLayer.populate(with: self.game)
        self.waterLayer.zPosition = Globals.ZLevels.water
        
        self.tooltipLayer = TooltipLayer(player: humanPlayer)
        self.tooltipLayer.populate(with: self.game)
        self.tooltipLayer.zPosition = Globals.ZLevels.tooltips*/
        
        super.init()
        self.zPosition = 0

        self.addChild(self.terrainLayer)
        self.addChild(self.featureLayer)
        /*self.addChild(self.resourceLayer)
        self.addChild(self.resourceMarkerLayer)
        self.addChild(self.boardLayer)
        self.addChild(self.riverLayer)
        self.addChild(self.unitLayer)
        self.addChild(self.cityLayer)
        self.addChild(self.improvementLayer)
        self.addChild(self.borderLayer)
        self.addChild(self.tooltipLayer)*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods
    
    func showYields() {
        
        // self.addChild(self.yieldLayer)
    }
    
    func hideYields() {
        
        // self.yieldLayer.removeFromParent()
    }
    
    func showResourceMarker() {
        
        // self.addChild(self.resourceMarkerLayer)
    }
    
    func hideResourceMarker() {
        
        // self.resourceMarkerLayer.removeFromParent()
    }
    
    func showWater() {
        
        // self.addChild(self.waterLayer)
    }
    
    func hideWater() {
        
        // self.waterLayer.removeFromParent()
    }

    func updateLayout() {
        
    }
    
    func update(tile: AbstractTile?) {
        
        self.terrainLayer.update(tile: tile)
        //self.borderLayer.update(tile: tile)
        self.featureLayer.update(tile: tile)
        /*self.resourceLayer.update(tile: tile)
        self.resourceMarkerLayer.update(tile: tile)
        self.riverLayer.update(tile: tile)
        self.improvementLayer.update(tile: tile)
        self.boardLayer.update(tile: tile)
        
        self.yieldLayer.update(tile: tile)
        self.waterLayer.update(tile: tile)*/
    }
}

// resize https://www.hackingwithswift.com/forums/swiftui/swiftui-spritekit-macos-catalina-10-15/2662
struct SKMapView : NSViewRepresentable {
    
    @Binding
    var game: GameModel?
    
    //let proxy: GeometryProxy
    
    class Coordinator: NSObject {
        var gameScene: GameScene?
        
        /*func resizeScene(proxy: GeometryProxy) {
            gameScene?.size = proxy.size
        }*/
    }
    
    func makeCoordinator() -> Coordinator {
        // add bindings here
        return Coordinator()
    }
    
    func makeNSView(context: Context) -> SKView {
        
        let view = SKView(frame: .zero)
        view.preferredFramesPerSecond = 60
        
        #if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        #endif
        
        // init SpriteKit Scene
        let gameScene = GameScene(size: .zero) // SKScene(size: self.size)
        //gameScene.size = proxy.size
        gameScene.scaleMode = .resizeFill
        gameScene.backgroundColor = NSColor.clear
        
        context.coordinator.gameScene = gameScene
        
        return view
    }
 
    func updateNSView(_ view: SKView, context: Context) {

        //print("updated new game: \(self.game)")
        if self.game != nil {
            //context.coordinator.resizeScene(proxy: proxy)
            
            context.coordinator.gameScene?.viewModel = GameSceneViewModel(with: game)
        
            view.presentScene(context.coordinator.gameScene)
            view.ignoresSiblingOrder = false
            
            context.coordinator.gameScene?.updateLayout()
        }
    }
}

//#if DEBUG
/*struct SKMapView_Previews : PreviewProvider {
    
    static var previews: some View {
        SKMapView(game: DemoGameModel(), size: CGSize(width: 200, height: 200))
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.sizeThatFits)
            .background(Color.red)
    }
}*/
//#endif
