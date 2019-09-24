//
//  MapItem.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class MapItem: Decodable {
    
    // MARK: properties
    
    let position: HexPoint
    
    // MARK: coding keys
    
    enum CodingKeys: String, CodingKey {

        case position
    }
    
    init(at position: HexPoint) {
        
        self.position = position
    }
    
    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.position = try values.decode(HexPoint.self, forKey: .position)
    }
}

extension MapItem: Encodable {
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.position, forKey: .position)
    }
}

