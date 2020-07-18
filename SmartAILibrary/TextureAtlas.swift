//
//  TextureAtlas.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 17.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

/*<action enum="attack" speed="203">
      <direction enum="south">
        <sprite n="arbalest_attack/000_Arbalest_attack.bmp" x="1" y="1" w="30" h="56" pX="0.466667" pY="0.767857"/>
        <sprite n="arbalest_attack/001_Arbalest_attack.bmp" x="33" y="1" w="28" h="58" pX="0.571429" pY="0.706897"/>
        <sprite n="arbalest_attack/002_Arbalest_attack.bmp" x="63" y="1" w="31" h="56" pX="0.677419" pY="0.678571"/>
        <sprite n="arbalest_attack/003_Arbalest_attack.bmp" x="96" y="1" w="31" h="55" pX="0.645161" pY="0.654545"/>
        <sprite n="arbalest_attack/004_Arbalest_attack.bmp" x="129" y="1" w="34" h="57" pX="0.647059" pY="0.666667"/>
        <sprite n="arbalest_attack/005_Arbalest_attack.bmp" x="165" y="1" w="33" h="57" pX="0.575758" pY="0.684211"/>
        <sprite n="arbalest_attack/006_Arbalest_attack.bmp" x="200" y="1" w="30" h="56" pX="0.5" pY="0.696429"/>
        <sprite n="arbalest_attack/007_Arbalest_attack.bmp" x="232" y="1" w="30" h="57" pX="0.533333" pY="0.701754"/>
        <sprite n="arbalest_attack/008_Arbalest_attack.bmp" x="264" y="1" w="28" h="56" pX="0.535714" pY="0.714286"/>
        <sprite n="arbalest_attack/009_Arbalest_attack.bmp" x="294" y="1" w="29" h="57" pX="0.517241" pY="0.736842"/>
        <sprite n="arbalest_attack/010_Arbalest_attack.bmp" x="325" y="1" w="30" h="56" pX="0.466667" pY="0.767857"/>
      </direction>

      <direction enum="south-west">
 
 ...
 */

public class TextureAtlasSprite: Decodable {
    
    enum CodingKeys: CodingKey {
        
        case n
        case x
        case y
        case w
        case h
        case pX
        case pY
    }
    
    public let name: String // n
    public let x: Int
    public let y: Int
    public let w: Int
    public let h: Int
    public let pX: Double
    public let pY: Double
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.name = try container.decode(String.self, forKey: .n)
        self.x = try container.decode(Int.self, forKey: .x)
        self.y = try container.decode(Int.self, forKey: .y)
        self.w = try container.decode(Int.self, forKey: .w)
        self.h = try container.decode(Int.self, forKey: .h)
        self.pX = try container.decode(Double.self, forKey: .pX)
        self.pY = try container.decode(Double.self, forKey: .pY)
    }
}

public class TextureAtlasDirection: Decodable {
    
    enum CodingKeys: String, CodingKey {
        
        case enumKey = "enum"
        case sprite
    }
    
    public let enumValue: String
    public let sprite: [TextureAtlasSprite]
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.enumValue = try container.decode(String.self, forKey: .enumKey)
        self.sprite = try container.decode([TextureAtlasSprite].self, forKey: .sprite)
    }
}

public class TextureAtlasAction: Decodable {
    
    enum CodingKeys: String, CodingKey {
        
        case enumKey = "enum"
        case speed
        case direction
    }
    
    public let enumValue: String
    public let speedValue: Int
    public let direction: [TextureAtlasDirection]
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.enumValue = try container.decode(String.self, forKey: .enumKey)
        self.speedValue = try container.decode(Int.self, forKey: .speed)
        self.direction = try container.decode([TextureAtlasDirection].self, forKey: .direction)
    }
}

public class TextureAtlasUnit: Decodable {
    
    enum CodingKeys: CodingKey {
        
        case id
        case action
    }
    
    public let id: String
    public let action: [TextureAtlasAction]
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.id = try container.decode(String.self, forKey: .id)
        self.action = try container.decode([TextureAtlasAction].self, forKey: .action)
    }
}

public class TextureAtlas: Decodable {
    
    enum CodingKeys: CodingKey {
        
        case unit
    }
    
    public var unit: TextureAtlasUnit
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.unit = try container.decode(TextureAtlasUnit.self, forKey: .unit)
    }
}
