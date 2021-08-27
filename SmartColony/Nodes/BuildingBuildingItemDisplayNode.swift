//
//  BuildingDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 20.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

protocol BuildingBuildingItemDisplayNodeDelegate: class {

    func clicked(on buildingType: BuildingType)
}

class BuildingBuildingItemDisplayNode: BaseBuildingItemDisplayNode {

    // vairables
    let buildingType: BuildingType

    // callback
    weak var delegate: BuildingBuildingItemDisplayNodeDelegate?

    // MARK: constructors

    init(buildingType: BuildingType, size: CGSize) {

        self.buildingType = buildingType

        super.init(textureName: "grid9_button_active",
                   iconTexture: SKTexture(imageNamed: buildingType.iconTexture()),
                   name: buildingType.name(),
                   nameColor: .white,
                   cost: Double(buildingType.productionCost()),
                   showCosts: true,
                   size: size)

        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: touch handlers

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        // propagate back to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesBegan(touches, with: event)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        // propagate back to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesMoved(touches, with: event)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)

            // propagate back to scrollview
            if let scrollView = self.parent?.parent as? ScrollNode {

                if !scrollView.backgroundNode!.contains(location) {
                    return
                }

                if self.backgroundNode!.contains(location) {
                    self.delegate?.clicked(on: self.buildingType)
                }
            }
        }
    }
}
