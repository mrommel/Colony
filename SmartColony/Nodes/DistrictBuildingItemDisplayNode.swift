//
//  DistrictDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 20.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

protocol DistrictBuildingItemDisplayNodeDelegate: class {

    func clicked(on districtType: DistrictType)
}

class DistrictBuildingItemDisplayNode: BaseBuildingItemDisplayNode {

    let districtType: DistrictType

    // callback
    weak var delegate: DistrictBuildingItemDisplayNodeDelegate?

    init(districtType: DistrictType, active: Bool, size: CGSize) {

        self.districtType = districtType

        super.init(textureName: active ? "grid9_button_district_active" : "grid9_button_district",
                   iconTexture: SKTexture(imageNamed: self.districtType.iconTexture()),
                   name: districtType.name(),
                   nameColor: active ? .white : SKColor(hex: "#16344f"),
                   cost: Double(districtType.productionCost()),
                   showCosts: active,
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
                    self.delegate?.clicked(on: self.districtType)
                }
            }
        }
    }
}
