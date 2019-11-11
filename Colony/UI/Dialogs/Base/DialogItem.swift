//
//  DialogItem.swift
//  Colony
//
//  Created by Michael Rommel on 22.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

struct DialogItem: Codable {
    
    var identifier: String
    
    var type: DialogItemType
    
    var title: String
    var fontSize: CGFloat
    var result: DialogResultType
    
    var offsetx: Int = 0
    var offsety: Int = 0
    var anchorx: DialogAnchor
    var anchory: DialogAnchor
    
    var width: Int
    var height: Int
    
    var image: String?
    
    struct DropdownItems: Codable {
        var item: [String] = []
    }
    var selectedIndex: Int? = 0
    var items: DropdownItems? = DropdownItems()
    
    init(identifier: String, type: DialogItemType, title: String, fontSize: CGFloat, result: DialogResultType, offsetx: Int, offsety: Int, anchorx: DialogAnchor, anchory: DialogAnchor, width: Int, height: Int, image: String?, selectedIndex: Int?, items: DropdownItems?) {
        
        self.identifier = identifier
        self.type = type
        self.title = title
        self.fontSize = fontSize
        self.result = result
        self.offsetx = offsetx
        self.offsety = offsety
        self.anchorx = anchorx
        self.anchory = anchory
        self.width = width
        self.height = height
        self.image = image
        self.selectedIndex = selectedIndex
        self.items = items
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier = try values.decode(String.self, forKey: .identifier)
        let type = try values.decode(DialogItemType.self, forKey: .type)
        let title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        let fontSize = try values.decodeIfPresent(CGFloat.self, forKey: .fontSize) ?? 18
        let result = try values.decodeIfPresent(DialogResultType.self, forKey: .result) ?? .none
        let offsetx = try values.decodeIfPresent(Int.self, forKey: .offsetx) ?? 0
        let offsety = try values.decodeIfPresent(Int.self, forKey: .offsety) ?? 0
        let anchorx = try values.decode(DialogAnchor.self, forKey: .anchorx)
        let anchory = try values.decode(DialogAnchor.self, forKey: .anchory)
        let width = try values.decode(Int.self, forKey: .width)
        let height = try values.decode(Int.self, forKey: .height)
        
        let image = try values.decodeIfPresent(String.self, forKey: .image) ?? nil
        
        let selectedIndex = try values.decodeIfPresent(Int.self, forKey: .selectedIndex) ?? nil
        let items: DropdownItems? = try values.decodeIfPresent(DropdownItems.self, forKey: .items) ?? nil
        
        self.init(identifier: identifier, type: type, title: title, fontSize: fontSize, result: result, offsetx: offsetx, offsety: offsety, anchorx: anchorx, anchory: anchory, width: width, height: height, image: image, selectedIndex: selectedIndex, items: items)
    }
    
    func positionxIn(parent: CGSize) -> CGFloat {
        
        var posx: CGFloat
        
        switch self.anchorx {
        case .left:
            posx = 0.0
            break
        case .center:
            posx = parent.width / 2.0
            break
        case .right:
            posx = parent.width
            break
        default:
            fatalError("Invalid value for anchorx: \(self.anchorx)")
        }
        
        posx = posx + CGFloat(self.offsetx)
        
        return posx
    }
    
    func positionyIn(parent: CGSize) -> CGFloat {
        
        var posy: CGFloat
        
        switch self.anchory {
        case .top:
            posy = 0.0
            break
        case .center:
            posy = parent.height / 2.0
            break
        case .bottom:
            posy = parent.height
            break
        default:
            fatalError("Invalid value for anchorx: \(self.anchory)")
        }
        
        posy = posy + CGFloat(self.offsety)
        
        return posy
    }
    
    func positionIn(parent: CGSize) -> CGPoint {
        return CGPoint(x: self.positionxIn(parent: parent), y: self.positionyIn(parent: parent))
    }
    
    var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
}
