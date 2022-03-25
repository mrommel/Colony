//
//  CityObject.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

extension NSBezierPath {

    public var cgPath: CGPath {

        let path = CGMutablePath()

        var points = [CGPoint](repeating: .zero, count: 3)

        for index in 0 ..< elementCount {
            let type = element(at: index, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                continue
            }
        }

        return path
    }
}

class CityObject {

    weak var city: AbstractCity?
    weak var gameModel: GameModel?

    let identifier: String

    // internal UI elements
    private var sprite: SKSpriteNode

    private var strengthBackground: SKShapeNode?
    private var strengthIconNode: SKSpriteNode?
    private var strengthLabel: SKLabelNode?
    private var strengthProgress: ProgressBarNode?

    private var capitalNode: SKSpriteNode?
    private var nameLabel: SKLabelNode?
    private var bannerBackground: SKShapeNode?
    private var sizeLabel: SKLabelNode?
    private var growthProgressNode: SKSpriteNode?
    private var governorNode: SKSpriteNode?
    private var productionProgressNode: SKSpriteNode?
    private var productionProgressLabel: SKLabelNode?
    private var productionNode: SKSpriteNode?

    init(city: AbstractCity?, in gameModel: GameModel?) {

        self.identifier = UUID.init().uuidString
        self.city = city
        self.gameModel = gameModel

        guard let city = self.city else {
            fatalError("cant get city")
        }

        self.sprite = SKSpriteNode(
            texture: SKTexture(image: ImageCache.shared.image(for: "city-ancient-small-noWalls")),
            size: CityLayer.kTextureSize
        )
        self.sprite.position = HexPoint.toScreen(hex: city.location)
        self.sprite.zPosition = Globals.ZLevels.city
        self.sprite.anchorPoint = CGPoint.lowerLeft
    }

    func addTo(node parent: SKNode) {

        parent.addChild(self.sprite)
    }

    func updateCityBanner() {

        self.hideCityBanner()
        self.showCityBanner()
    }

    func showCityBanner() {

        guard let city = self.city as? City else {
            fatalError("cant get unit")
        }

        guard let player = city.player else {
            fatalError("cant get player")
        }

        self.sprite.texture = SKTexture(image: ImageCache.shared.image(for: city.iconTexture()))

        // strength banner
        let strengthBannerWidth = 16
        let extraHealthPointsWidth = city.healthPoints() < city.maxHealthPoints() ? 20 : 0

        self.strengthBackground = SKShapeNode()
        let strengthRect: CGRect = CGRect(x: -12 * 4, y: 0, width: (strengthBannerWidth + extraHealthPointsWidth) * 4, height: 24)
        self.strengthBackground?.path = NSBezierPath(roundedRect: strengthRect, xRadius: 16, yRadius: 16).cgPath
        self.strengthBackground?.position = CGPoint(x: 24, y: 46)
        self.strengthBackground?.fillColor = NSColor.black.withAlphaComponent(0.5)
        self.strengthBackground?.strokeColor = NSColor.black
        self.strengthBackground?.lineWidth = 4
        self.strengthBackground?.zPosition = Globals.ZLevels.cityName - 0.1
        self.strengthBackground?.setScale(0.25)

        if let strengthBackground = self.strengthBackground {
            self.sprite.addChild(strengthBackground)
        }

        let strengthTexture: SKTexture = SKTexture(image: Globals.Icons.strength)
        self.strengthIconNode = SKSpriteNode(texture: strengthTexture, color: .black, size: CGSize(width: 6, height: 6))
        self.strengthIconNode?.position = CGPoint(x: 24 - 5, y: 46)
        self.strengthIconNode?.zPosition = Globals.ZLevels.cityName
        self.strengthIconNode?.anchorPoint = .lowerRight

        if let strengthIconNode = self.strengthIconNode {
            self.sprite.addChild(strengthIconNode)
        }

        self.strengthLabel = SKLabelNode(text: "\(city.combatStrength(against: nil, in: self.gameModel))")
        self.strengthLabel?.fontSize = 6 * 4
        self.strengthLabel?.position = CGPoint(x: 24 - 2, y: 47)
        self.strengthLabel?.zPosition = Globals.ZLevels.cityName
        self.strengthLabel?.fontColor = .white
        self.strengthLabel?.preferredMaxLayoutWidth = 12 * 4
        self.strengthLabel?.setScale(0.25)

        if let strengthLabel = self.strengthLabel {
            self.sprite.addChild(strengthLabel)
        }

        if city.healthPoints() < city.maxHealthPoints() {
            self.strengthProgress = ProgressBarNode(size: CGSize(width: extraHealthPointsWidth * 4, height: 8))
            self.strengthProgress?.position = CGPoint(x: 24 + 12, y: 49)
            self.strengthProgress?.zPosition = Globals.ZLevels.cityName
            self.strengthProgress?.setScale(0.25)
            self.strengthProgress?.set(progress: CGFloat(city.healthPoints()) / CGFloat(city.maxHealthPoints()))

            if let strengthProgress = self.strengthProgress {
                self.sprite.addChild(strengthProgress)
            }
        }

        // city banner
        let cityName = city.name.localized()
        let nameLabelWidth: CGFloat = CGFloat(cityName.count) * 4.2
        let leftExtra: CGFloat = 10.0 // city.isCapital() ? 10.0 : 0
        let rightExtra: CGFloat = 10.0 // city.governor() != nil ? 10.0 : 0
        let bannerBackgroundWidth = leftExtra + nameLabelWidth + rightExtra + 18.0

        let sizeOffset: CGFloat = 24 - bannerBackgroundWidth / 2 + 4
        let growthOffset: CGFloat = 24 - nameLabelWidth / 2 - leftExtra + 3
        let capitalOffset: CGFloat = 24 - nameLabelWidth / 2 + 3
        let nameOffset: CGFloat = 24 // 48 / 2 == center
        let governorOffset: CGFloat = 24 + nameLabelWidth / 2 - 3
        let productionProgressOffset: CGFloat = 24 + nameLabelWidth / 2 + rightExtra - 4
        let productionOffset: CGFloat = 24 + nameLabelWidth / 2 + rightExtra - 1

        self.bannerBackground = SKShapeNode()
        let rect: CGRect = CGRect(x: -bannerBackgroundWidth / 2 * 4, y: 0, width: bannerBackgroundWidth * 4, height: 40)
        self.bannerBackground?.path = NSBezierPath(roundedRect: rect, xRadius: 20, yRadius: 20).cgPath
        self.bannerBackground?.position = CGPoint(x: 24, y: 35)
        self.bannerBackground?.fillColor = player.leader.civilization().main
        self.bannerBackground?.strokeColor = player.leader.civilization().accent
        self.bannerBackground?.lineWidth = 4
        self.bannerBackground?.zPosition = Globals.ZLevels.cityName - 0.1
        self.bannerBackground?.setScale(0.25)

        if let nameBackground = self.bannerBackground {
            self.sprite.addChild(nameBackground)
        }

        self.sizeLabel = SKLabelNode(text: "\(city.population())")
        self.sizeLabel?.fontSize = 8
        self.sizeLabel?.position = CGPoint(x: sizeOffset, y: 36)
        self.sizeLabel?.zPosition = Globals.ZLevels.cityName
        self.sizeLabel?.fontColor = player.leader.civilization().accent
        self.sizeLabel?.preferredMaxLayoutWidth = 12

        if let sizeLabel = self.sizeLabel {
            self.sprite.addChild(sizeLabel)
        }

        var growthProgress: Int = 0
        if city.maxGrowthInTurns() > 0 {
            growthProgress = 100 - Int(Double(city.growthInTurns() * 100) / Double(city.maxGrowthInTurns())) / 5 * 5
        }
        let growthProgressTextureName = "linear-progress-\(growthProgress)"
        let growthProgressImage = ImageCache.shared.image(for: growthProgressTextureName)
        let growthProgressTexture = SKTexture(image: growthProgressImage)

        self.growthProgressNode = SKSpriteNode(texture: growthProgressTexture, color: .black, size: CGSize(width: 2, height: 10))
        self.growthProgressNode?.position = CGPoint(x: growthOffset, y: 35)
        self.growthProgressNode?.zPosition = Globals.ZLevels.cityName
        self.growthProgressNode?.anchorPoint = .lowerRight

        if let growthProgressNode = self.growthProgressNode {
            self.sprite.addChild(growthProgressNode)
        }

        if city.isCapital() {

            let governorTexture: SKTexture = SKTexture(image: Globals.Icons.capital)
            self.capitalNode = SKSpriteNode(texture: governorTexture, color: .black, size: CGSize(width: 8, height: 8))
            self.capitalNode?.position = CGPoint(x: capitalOffset, y: 36)
            self.capitalNode?.zPosition = Globals.ZLevels.cityName
            self.capitalNode?.anchorPoint = .lowerRight

            if let capitalNode = self.capitalNode {
                self.sprite.addChild(capitalNode)
            }
        }

        self.nameLabel = SKLabelNode(text: cityName)
        self.nameLabel?.fontSize = 8
        self.nameLabel?.position = CGPoint(x: nameOffset, y: 36)
        self.nameLabel?.zPosition = Globals.ZLevels.cityName
        self.nameLabel?.fontColor = player.leader.civilization().accent
        self.nameLabel?.preferredMaxLayoutWidth = 30

        self.nameLabel?.fitToWidth(maxWidth: CGFloat(nameLabelWidth))

        if let nameLabel = self.nameLabel {
            self.sprite.addChild(nameLabel)
        }

        // governor
        if let governor = city.governorType() {

            let governorImage = ImageCache.shared.image(for: governor.portraitTexture())
            let governorTexture: SKTexture = SKTexture(image: governorImage)
            self.governorNode = SKSpriteNode(texture: governorTexture, color: .black, size: CGSize(width: 8, height: 8))
            self.governorNode?.position = CGPoint(x: governorOffset, y: 36)
            self.governorNode?.zPosition = Globals.ZLevels.cityName
            self.governorNode?.anchorPoint = .lowerLeft

            if let governorNode = self.governorNode {
                self.sprite.addChild(governorNode)
            }
        }

        // show production only for human cities
        if city.isHuman() {
            var texture: SKTexture = SKTexture(image: Globals.Icons.questionmark)
            var productionProgress: Int = 0
            var productionTurns: Int = -1
            let productionPerTurn = city.productionPerTurn(in: gameModel)

            if let item = city.currentBuildableItem() {
                switch item.type {

                case .unit:
                    if let unitType = item.unitType {
                        let unitTypeImage = ImageCache.shared.image(for: unitType.typeTexture())
                        texture = SKTexture(image: unitTypeImage)
                        productionProgress = Int((item.production * 100.0) / Double(unitType.productionCost())) / 5 * 5

                        let productionLeft: Int = unitType.productionCost() - Int(item.production)
                        productionTurns = productionPerTurn > 0.0 ? Int(ceil(Double(productionLeft) / productionPerTurn)) : 100
                    }
                case .building:
                    if let buildingType = item.buildingType {
                        let buildingTypeImage = ImageCache.shared.image(for: buildingType.iconTexture())
                        texture = SKTexture(image: buildingTypeImage)
                        productionProgress = Int((item.production * 100.0) / Double(buildingType.productionCost())) / 5 * 5

                        let productionLeft: Int = buildingType.productionCost() - Int(item.production)
                        productionTurns = productionPerTurn > 0.0 ? Int(ceil(Double(productionLeft) / productionPerTurn)) : 100
                    }
                case .wonder:
                    if let wonderType = item.wonderType {
                        let wonderTypeImage = ImageCache.shared.image(for: wonderType.iconTexture())
                        texture = SKTexture(image: wonderTypeImage)
                        productionProgress = Int((item.production * 100.0) / Double(wonderType.productionCost())) / 5 * 5

                        let productionLeft: Int = wonderType.productionCost() - Int(item.production)
                        productionTurns = productionPerTurn > 0.0 ? Int(ceil(Double(productionLeft) / productionPerTurn)) : 100
                    }
                case .district:
                    if let districtType = item.districtType {
                        let districtTypeImage = ImageCache.shared.image(for: districtType.iconTexture())
                        texture = SKTexture(image: districtTypeImage)
                        productionProgress = Int((item.production * 100.0) / Double(districtType.productionCost())) / 5 * 5

                        let productionLeft: Int = districtType.productionCost() - Int(item.production)
                        productionTurns = productionPerTurn > 0.0 ? Int(ceil(Double(productionLeft) / productionPerTurn)) : 100
                    }
                case .project:
                    /*if let projectType = item.projectType {
                    textureName = projectType.iconTexture()
                }*/
                    break
                }
            }

            let productionProgressTextureName = "linear-progress-\(productionProgress)"
            let productionProgressImage = ImageCache.shared.image(for: productionProgressTextureName)
            let productionProgressTexture = SKTexture(image: productionProgressImage)

            self.productionProgressNode = SKSpriteNode(texture: productionProgressTexture, color: .black, size: CGSize(width: 2, height: 10))
            self.productionProgressNode?.position = CGPoint(x: productionProgressOffset, y: 35)
            self.productionProgressNode?.zPosition = Globals.ZLevels.cityName
            self.productionProgressNode?.anchorPoint = .lowerLeft

            if let productionProgressNode = self.productionProgressNode {
                self.sprite.addChild(productionProgressNode)
            }

            if productionTurns > -1 {
                self.productionProgressLabel = SKLabelNode(text: "\(productionTurns)")
                self.productionProgressLabel?.position = CGPoint(x: productionProgressOffset - 0, y: 35)
                self.productionProgressLabel?.zPosition = Globals.ZLevels.cityName
                self.productionProgressLabel?.fontSize = 8
                self.productionProgressLabel?.fontColor = .white
                self.productionProgressLabel?.preferredMaxLayoutWidth = 60
                self.productionProgressLabel?.horizontalAlignmentMode = .right
                self.productionProgressLabel?.setScale(0.5)

                if let productionProgressLabel = self.productionProgressLabel {
                    self.sprite.addChild(productionProgressLabel)
                }
            }

            self.productionNode = SKSpriteNode(texture: texture, color: .black, size: CGSize(width: 8, height: 8))
            self.productionNode?.position = CGPoint(x: productionOffset, y: 36)
            self.productionNode?.zPosition = Globals.ZLevels.cityName
            self.productionNode?.anchorPoint = .lowerLeft

            if let productionNode = self.productionNode {
                self.sprite.addChild(productionNode)
            }
        }
    }

    func hideCityBanner() {

        if self.nameLabel != nil {

            self.strengthBackground?.removeFromParent()
            self.strengthBackground = nil
            self.strengthIconNode?.removeFromParent()
            self.strengthIconNode = nil
            self.strengthLabel?.removeFromParent()
            self.strengthLabel = nil
            self.strengthProgress?.removeFromParent()
            self.strengthProgress = nil

            self.bannerBackground?.removeFromParent()
            self.bannerBackground = nil
            self.sizeLabel?.removeFromParent()
            self.sizeLabel = nil
            self.capitalNode?.removeFromParent()
            self.capitalNode = nil
            self.growthProgressNode?.removeFromParent()
            self.growthProgressNode = nil
            self.nameLabel?.removeFromParent()
            self.nameLabel = nil
            self.governorNode?.removeFromParent()
            self.governorNode = nil
            self.productionProgressNode?.removeFromParent()
            self.productionProgressNode = nil
            self.productionProgressLabel?.removeFromParent()
            self.productionProgressLabel = nil
            self.productionNode?.removeFromParent()
            self.productionNode = nil

            self.sprite.removeAllChildren()
        }
    }
}
