//
//  DialogConfiguration.swift
//  Colony
//
//  Created by Michael Rommel on 12.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import XMLCoder
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
    case textfield = "textfield"
    case progressbar = "progressbar"
    case dropdown = "dropdown"
}

enum DialogResultType: String, Codable {
    
    case none
    case okay = "OKAY"
    case cancel = "CANCEL"
    
    // map types
    case mapTypeEarth = "EARTH"
    case mapTypePangaea = "PANGAEA"
    case mapTypeContinents = "CONTINENTS"
    case mapTypeArchipelago = "ARCHIPELAGO"
    case mapTypeInlandsea = "INLANDSEA"
    case mapTypeRandom = "TYPERANDOM"
    
    // map sizes
    case mapSizeHuge = "HUGE"
    case mapSizeLarge = "LARGE"
    case mapSizeStandard = "STANDARD"
    case mapSizeSmall = "SMALL"
    case mapSizeTiny = "TINY"
    
    // map ages
    case mapAgeYoung = "AGE_YOUNG"
    case mapAgeNormal = "AGE_NORMAL"
    case mapAgeOld = "AGE_OLD"
    
    // map rainfall
    case mapRainfallWet = "RAINFALL_WET"
    case mapRainfallNormal = "RAINFALL_NORMAL"
    case mapRainfallDry = "RAINFALL_DRY"
    
    // map climate
    case mapClimateHot = "CLIMATE_HOT"
    case mapClimateTemperate = "CLIMATE_TEMPERATE"
    case mapClimateCold = "CLIMATE_COLD"
    
    // map climate
    case mapSeaLevelLow = "SEALEVEL_LOW"
    case mapSeaLevelNormal = "SEALEVEL_NORMAL"
    case mapSeaLevelHigh = "SEALEVEL_HIGH"
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
    
    enum CodingKeys: String, CodingKey {
        case type, offsetx, offsety, anchorx, anchory, width, height, background, items
    }
    
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
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let offsetx = try container.decodeIfPresent(Int.self, forKey: .offsetx) ?? 0
        let offsety = try container.decodeIfPresent(Int.self, forKey: .offsety) ?? 0
        let anchorx = try container.decode(DialogAnchor.self, forKey: .anchorx)
        let anchory = try container.decode(DialogAnchor.self, forKey: .anchory)
        let width = try container.decode(Int.self, forKey: .width)
        let height = try container.decode(Int.self, forKey: .height)
        let background = try container.decode(String.self, forKey: .background)
        
        self.init(offsetx: offsetx, offsety: offsety, anchorx: anchorx, anchory: anchory, width: width, height: height, background: background)
        
        self.items = try container.decode(Items.self, forKey: .items)
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
