//
//  UnitDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 21.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

protocol UnitBuildingItemDisplayNodeDelegate: class {

    func clicked(on unitType: UnitType)
}

class UnitBuildingItemDisplayNode: BaseBuildingItemDisplayNode {

    // variables
    let unitType: UnitType

    // callback
    weak var delegate: UnitBuildingItemDisplayNodeDelegate?

    // MARK: constructors

    init(unitType: UnitType, size: CGSize) {

        self.unitType = unitType

        super.init(textureName: "grid9_button_active",
                   iconTexture: unitType.iconTexture(),
                   name: unitType.name(),
                   nameColor: .white,
                   cost: Double(unitType.productionCost()),
                   showCosts: true, // fixme
                   size: size)

        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: touch handlers

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        // propergate to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesBegan(touches, with: event)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        // propergate to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesMoved(touches, with: event)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)

            // propergate to scrollview
            if let scrollView = self.parent?.parent as? ScrollNode {

                if scrollView.backgroundNode!.contains(location) {

                    if self.backgroundNode!.contains(location) {
                        self.delegate?.clicked(on: self.unitType)
                    }
                }
            }
        }
    }
}
