//
//  DialogConfiguration.swift
//  Colony
//
//  Created by Michael Rommel on 12.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import XMLParsing
import SpriteKit

enum DialogAnchor: String, Codable {
    case center = "center"
    case left = "left"
    case right = "right"
    case top = "top"
    case bottom = "bottom"
}

enum DialogItemType: String, Codable {
    case button = "button"
    case image = "image"
    case label = "label"
}

enum DialogResultType: String, Codable {
    case none
    case okay = "OKAY"
    case cancel = "CANCEL"
}

struct DialogItem: Codable {
    
    var identifier: String
    
    var type: DialogItemType
    
    var title: String
    var result: DialogResultType
    
    var offsetx: Int = 0
    var offsety: Int = 0
    var anchorx: DialogAnchor
    var anchory: DialogAnchor
    
    var width: Int
    var height: Int
    
    var image: String
    
    init(identifier: String, type: DialogItemType, title: String, result: DialogResultType, offsetx: Int, offsety: Int, anchorx: DialogAnchor, anchory: DialogAnchor, width: Int, height: Int, image: String) {
        
        self.identifier = identifier
        self.type = type
        self.title = title
        self.result = result
        self.offsetx = offsetx
        self.offsety = offsety
        self.anchorx = anchorx
        self.anchory = anchory
        self.width = width
        self.height = height
        self.image = image
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let identifier = try values.decode(String.self, forKey: .identifier)
        let type = try values.decode(DialogItemType.self, forKey: .type)
        let title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        let result = try values.decodeIfPresent(DialogResultType.self, forKey: .result) ?? .none
        let offsetx = try values.decodeIfPresent(Int.self, forKey: .offsetx) ?? 0
        let offsety = try values.decodeIfPresent(Int.self, forKey: .offsety) ?? 0
        let anchorx = try values.decode(DialogAnchor.self, forKey: .anchorx)
        let anchory = try values.decode(DialogAnchor.self, forKey: .anchory)
        let width = try values.decode(Int.self, forKey: .width)
        let height = try values.decode(Int.self, forKey: .height)
        
        let image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        
        self.init(identifier: identifier, type: type, title: title, result: result, offsetx: offsetx, offsety: offsety, anchorx: anchorx, anchory: anchory, width: width, height: height, image: image)
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

struct DialogConfiguration: Decodable {
    
    var offsetx: Int = 0
    var offsety: Int = 0
    var anchorx: DialogAnchor
    var anchory: DialogAnchor
    
    var width: Int
    var height: Int
    var background: String
    
    struct Items: Codable {
        var item: [DialogItem] = []
    }
    var items: Items = Items()
    
    init(offsetx: Int, offsety: Int, anchorx: DialogAnchor, anchory: DialogAnchor, width: Int, height: Int, background: String) {
        
        self.offsetx = offsetx
        self.offsety = offsety
        self.anchorx = anchorx
        self.anchory = anchory
        self.width = width
        self.height = height
        self.background = background
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let offsetx = try values.decodeIfPresent(Int.self, forKey: .offsetx) ?? 0
        let offsety = try values.decodeIfPresent(Int.self, forKey: .offsety) ?? 0
        let anchorx = try values.decode(DialogAnchor.self, forKey: .anchorx)
        let anchory = try values.decode(DialogAnchor.self, forKey: .anchory)
        let width = try values.decode(Int.self, forKey: .width)
        let height = try values.decode(Int.self, forKey: .height)
        let background = try values.decode(String.self, forKey: .background)
        
        self.init(offsetx: offsetx, offsety: offsety, anchorx: anchorx, anchory: anchory, width: width, height: height, background: background)
        
        self.items = try values.decode(Items.self, forKey: .items)
    }
    
    enum CodingKeys: String, CodingKey {
        case type, offsetx, offsety, anchorx, anchory, width, height, background, items
    }
    
    var positionx: CGFloat {
        
        var posx: CGFloat
        let screenSize: CGRect = UIScreen.main.bounds
        
        switch self.anchorx {
        case .left:
            posx = 0.0
            break
        case .center:
            posx = screenSize.width / 2.0
            break
        case .right:
            posx = screenSize.width
            break
        default:
            fatalError("Invalid value for anchorx: \(self.anchorx)")
        }
        
        posx = posx + CGFloat(self.offsetx)
        
        return posx
    }
    
    var positiony: CGFloat {
        
        var posy: CGFloat
        let screenSize: CGRect = UIScreen.main.bounds
        
        switch self.anchory {
        case .top:
            posy = 0.0
            break
        case .center:
            posy = screenSize.height / 2.0
            break
        case .bottom:
            posy = screenSize.height
            break
        default:
            fatalError("Invalid value for anchorx: \(self.anchory)")
        }
        
        posy = posy + CGFloat(self.offsety)
        
        return posy
    }
    
    var position: CGPoint {
        return CGPoint(x: self.positionx, y: self.positiony)
    }
    
    var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
}
