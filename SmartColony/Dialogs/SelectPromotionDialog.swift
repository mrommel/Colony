//
//  SelectPromotionDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 11.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

class SelectPromotionDialogViewModel {

    let iconTexture: SKTexture
    let name: String
    let possiblePromotions: [UnitPromotionType]

    init(for unitRef: AbstractUnit?) {

        if let unit = unitRef {

            self.iconTexture = unit.type.iconTexture()
            self.name = unit.name()
            self.possiblePromotions = unit.possiblePromotions()
        } else {

            self.iconTexture = SKTexture(imageNamed: "unit_type_default")
            self.name = "???"
            self.possiblePromotions = []
        }
    }
}

class SelectPromotionDialog: Dialog {

    // variables
    var viewModel: SelectPromotionDialogViewModel

    // MARK: Constructors

    init(with viewModel: SelectPromotionDialogViewModel) {

        self.viewModel = viewModel

        let uiParser = UIParser()
        guard let selectPromotionDialogConfiguration = uiParser.parse(from: "SelectPromotionDialog") else {
            fatalError("cant load SelectPromotionDialog configuration")
        }

        super.init(from: selectPromotionDialogConfiguration)

        // fill
        self.set(image: self.viewModel.iconTexture, identifier: "current_unit_type_icon")
        self.set(text: self.viewModel.name, identifier: "current_unit_name")

        // promotions
        var dy = 0
        for possiblePromotion in self.viewModel.possiblePromotions {

            print("possiblePromotion: \(possiblePromotion)")
            let promotionDisplayNode = PromotionDisplayNode(promotionType: possiblePromotion, state: .possible)
            promotionDisplayNode.delegate = self
            promotionDisplayNode.zPosition = self.zPosition + 1.0
            promotionDisplayNode.position = CGPoint(x: -106, y: dy - 250)

            self.addChild(promotionDisplayNode)

            dy -= 110
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectPromotionDialog: PromotionDisplayNodeDelegate {

    func clicked(on promotionType: UnitPromotionType) {

        if let result = DialogResultType(promotionType: promotionType) {
            self.handleResult(with: result)
        } else {
            print("promotion: \(promotionType) not handled")
        }
    }
}
