//
//  DialogItem.swift
//  SmartColony
//
//  Created by Michael Rommel on 22.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import CoreGraphics
import SmartAILibrary

struct DialogItemConfiguration: Codable {

    var identifier: String

    var type: DialogItemType

    var title: String
    var fontSize: CGFloat
    var textAlign: DialogTextAlign = .center // SKLabelHorizontalAlignmentMode = .center
    var result: DialogResultType

    var width: CGFloat
    var height: CGFloat

    var offsetx: CGFloat = 0.0
    var offsety: CGFloat = 0.0
    var anchorx: CGFloat = 0.0
    var anchory: CGFloat = 0.0

    var active: Bool = true

    // imageview specific fields
    var image: String?

    // dropdown specific fields
    struct DropdownItems: Codable {
        var item: [String] = []
    }
    var selectedIndex: Int? = 0
    var items: DropdownItems? = DropdownItems()

    // yield view specific fields
    var yieldType: YieldType = .none
    var techType: TechType = .mining
    var civicType: CivicType = .codeOfLaws

    enum CodingKeys: String, CodingKey {

        case identifier
        case type
        case title
        case fontSize
        case textAlign
        case result
        case offsetx
        case offsety
        case anchorx
        case anchory
        case width
        case height
        case active
        case image
        case selectedIndex
        case items
        case yieldType
        case techType
        case civicType
    }

    init(identifier: String, type: DialogItemType, title: String, fontSize: CGFloat, textAlign: DialogTextAlign, result: DialogResultType, offsetx: CGFloat, offsety: CGFloat, anchorx: CGFloat, anchory: CGFloat, width: CGFloat, height: CGFloat, active: Bool, image: String?, selectedIndex: Int?, items: DropdownItems?, yieldType: YieldType, techType: TechType, civicType: CivicType) {

        self.identifier = identifier
        self.type = type
        self.title = title
        self.fontSize = fontSize
        self.textAlign = textAlign
        self.result = result
        self.offsetx = offsetx
        self.offsety = offsety
        self.anchorx = anchorx
        self.anchory = anchory
        self.width = width
        self.height = height
        self.active = active
        self.image = image
        self.selectedIndex = selectedIndex
        self.items = items
        self.yieldType = yieldType
        self.techType = techType
        self.civicType = civicType
    }

    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        let identifier = try values.decode(String.self, forKey: .identifier)
        let type = try values.decode(DialogItemType.self, forKey: .type)
        let title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        let fontSize = try values.decodeIfPresent(CGFloat.self, forKey: .fontSize) ?? 18
        let textAlign = try values.decodeIfPresent(DialogTextAlign.self, forKey: .textAlign) ?? .center
        let result = try values.decodeIfPresent(DialogResultType.self, forKey: .result) ?? .none
        let offsetxValue = try values.decodeIfPresent(String.self, forKey: .offsetx) ?? "0"
        let offsetyValue = try values.decodeIfPresent(String.self, forKey: .offsety) ?? "0"
        let anchorxValue = try values.decode(DialogAnchor.self, forKey: .anchorx)
        let anchoryValue = try values.decode(DialogAnchor.self, forKey: .anchory)
        let widthValue = try values.decode(String.self, forKey: .width)
        let heightValue = try values.decode(String.self, forKey: .height)

        let bounds = UIScreen.main.bounds
        var width: CGFloat = bounds.size.width
        var height: CGFloat = bounds.size.height

        var offsetx: CGFloat = 0.0
        if offsetxValue.contains("%") {
            let parts = offsetxValue.split {$0 == "%"}.map(String.init)
            if parts.count == 1 {
                let percentageValue: String = String(parts[0])
                let percentage = Double(percentageValue)!
                offsetx = CGFloat(percentage * Double(width) / 100.0)
            }
        } else {
            offsetx = CGFloat(Double(offsetxValue)!)
        }

        var offsety: CGFloat = 0.0
        if offsetyValue.contains("%") {
            let parts = offsetyValue.split {$0 == "%"}.map(String.init)
            if parts.count == 1 {
                let percentageValue: String = String(parts[0])
                let percentage = Double(percentageValue)!
                offsety = CGFloat(percentage * Double(height) / 100.0)
            }
        } else {
            offsety = CGFloat(Double(offsetyValue)!)
        }

        if widthValue.contains("%") {
            let parts = widthValue.split {$0 == "%"}.map(String.init)
            if parts.count == 1 {
                let percentageValue: String = String(parts[0])
                let percentage = Double(percentageValue)!
                width = CGFloat(percentage * Double(width) / 100.0)
            }
        } else {
            width = CGFloat(Double(widthValue)!)
        }

        if heightValue.contains("%") {
            let parts = heightValue.split {$0 == "%"}.map(String.init)
            if parts.count == 1 {
                let percentageValue: String = String(parts[0])
                let percentage = Double(percentageValue)!
                height = CGFloat(percentage * Double(height) / 100.0)
            }
        } else {
            height = CGFloat(Double(heightValue)!)
        }

        var anchorx: CGFloat = 0.0
        switch anchorxValue {

        case .center:
            anchorx = 0.5
        case .left:
            anchorx = 0.0
        case .right:
            anchorx = 1.0
        default:
            fatalError("Invalid value for anchorx: \(anchorxValue)")
        }

        var anchory: CGFloat = 0.0
        switch anchoryValue {

        case .center:
            anchory = 0.5
        case .top:
            anchory = 1.0
        case .bottom:
            anchory = 0.0
        default:
            fatalError("Invalid value for anchorx: \(anchoryValue)")
        }

        let active = try values.decodeIfPresent(Bool.self, forKey: .active) ?? true

        let image = try values.decodeIfPresent(String.self, forKey: .image) ?? nil

        let selectedIndex = try values.decodeIfPresent(Int.self, forKey: .selectedIndex) ?? nil
        let items: DropdownItems? = try values.decodeIfPresent(DropdownItems.self, forKey: .items) ?? nil

        let yieldType = try values.decodeIfPresent(YieldType.self, forKey: .yieldType) ?? .none
        let techType = try values.decodeIfPresent(TechType.self, forKey: .techType) ?? .mining
        let civicType = try values.decodeIfPresent(CivicType.self, forKey: .civicType) ?? .codeOfLaws

        self.init(
            identifier: identifier,
            type: type,
            title: title,
            fontSize: fontSize,
            textAlign: textAlign,
            result: result,
            offsetx: offsetx,
            offsety: offsety,
            anchorx: anchorx,
            anchory: anchory,
            width: width,
            height: height,
            active: active,
            image: image,
            selectedIndex: selectedIndex,
            items: items,
            yieldType: yieldType,
            techType: techType,
            civicType: civicType
        )
    }

    func anchorPoint() -> CGPoint {

        return CGPoint(x: self.anchorx, y: self.anchory)
    }

    func position() -> CGPoint {

        return CGPoint(x: self.offsetx, y: self.offsety)
    }

    var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
}
