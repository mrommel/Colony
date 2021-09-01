//
//  Promotions.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 18.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum PromotionError: Error {

    case alreadyEarned
}

protocol AbstractPromotions: Codable {

    func postProcess(by unit: AbstractUnit?)

    // promotions
    func has(promotion: UnitPromotionType) -> Bool
    func earn(promotion: UnitPromotionType) throws

    func count() -> Int
    func gainedPromotions() -> [UnitPromotionType]
    func possiblePromotions() -> [UnitPromotionType]
}

class Promotions: AbstractPromotions {

    enum CodingKeys: CodingKey {

        case promotions
    }

    private var promotions: [UnitPromotionType]
    private var unit: AbstractUnit?

    init(unit: AbstractUnit?) {

        self.unit = unit
        self.promotions = []
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.promotions = try container.decode([UnitPromotionType].self, forKey: .promotions)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.promotions, forKey: .promotions)
    }

    func postProcess(by unit: AbstractUnit?) {

        self.unit = unit
    }

    func has(promotion: UnitPromotionType) -> Bool {

        return self.promotions.contains(promotion)
    }

    func earn(promotion: UnitPromotionType) throws {

        if self.has(promotion: promotion) {
            throw PromotionError.alreadyEarned
        }

        self.promotions.append(promotion)
    }

    func count() -> Int {

        return self.promotions.count
    }

    func gainedPromotions() -> [UnitPromotionType] {

        var promotionList: [UnitPromotionType] = []

        for promotion in UnitPromotionType.all {

            if self.has(promotion: promotion) {
                promotionList.append(promotion)
            }
        }

        return promotionList
    }

    func possiblePromotions() -> [UnitPromotionType] {

        guard let unit = self.unit else {
            fatalError("cant get unit")
        }

        var promotionList: [UnitPromotionType] = []

        for promotion in UnitPromotionType.all {

            if !unit.isOf(unitClass: promotion.unitClass()) {
                continue
            }

            if self.has(promotion: promotion) {
                continue
            }

            var valid = true
            for requiredPromotion in promotion.required() {
                if !self.has(promotion: requiredPromotion) {
                    valid = false
                }
            }

            if !valid {
                continue
            }

            promotionList.append(promotion)
        }

        return promotionList
    }
}
