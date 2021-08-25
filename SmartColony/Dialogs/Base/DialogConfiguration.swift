//
//  DialogConfiguration.swift
//  SmartColony
//
//  Created by Michael Rommel on 12.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import XMLCoder
import SpriteKit
import SmartAILibrary

protocol DialogConfigurationDelegate: class {
    
    func techProgress(of techType: TechType) -> Int
    func civicProgress(of civicType: CivicType) -> Int
}

class DialogConfiguration: Decodable {

    var offsetx: CGFloat = 0
    var offsety: CGFloat = 0
    var anchorx: CGFloat
    var anchory: CGFloat

    var width: CGFloat
    var height: CGFloat
    var background: String

    struct Items: Codable {
        var item: [DialogItemConfiguration] = []
    }
    var items: Items = Items()

    enum CodingKeys: String, CodingKey {
        case type, offsetx, offsety, anchorx, anchory, width, height, background, items
    }
    
    weak var delegate: DialogConfigurationDelegate?

    init(offsetx: CGFloat, offsety: CGFloat, anchorx: CGFloat, anchory: CGFloat, width: CGFloat, height: CGFloat, background: String) {

        self.offsetx = offsetx
        self.offsety = offsety
        self.anchorx = anchorx
        self.anchory = anchory
        self.width = width
        self.height = height
        self.background = background
    }

    required convenience init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let offsetxValue = try container.decodeIfPresent(String.self, forKey: .offsetx) ?? "0"
        let offsetyValue = try container.decodeIfPresent(String.self, forKey: .offsety) ?? "0"
        let anchorxValue = try container.decode(DialogAnchor.self, forKey: .anchorx)
        let anchoryValue = try container.decode(DialogAnchor.self, forKey: .anchory)
        let widthValue = try container.decode(String.self, forKey: .width)
        let heightValue = try container.decode(String.self, forKey: .height)
        let background = try container.decode(String.self, forKey: .background)

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

        self.init(offsetx: offsetx, offsety: offsety, anchorx: anchorx, anchory: anchory, width: width, height: height, background: background)

        self.items = try container.decode(Items.self, forKey: .items)
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
