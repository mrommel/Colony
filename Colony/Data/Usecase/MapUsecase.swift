//
//  MapUsecase.swift
//  Colony
//
//  Created by Michael Rommel on 06.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class MapUsecase {

    func load(from url: URL?) -> HexagonTileMap? {
        
        if let mapUrl = url {
            
            do {
                let jsonData = try Data(contentsOf: mapUrl, options: .mappedIfSafe)
                
                return try JSONDecoder().decode(HexagonTileMap.self, from: jsonData)
            } catch {
                print("Error reading \(error)")
            }
        }
        
        return nil
    }
    
    func store(map: HexagonTileMap?, to fileName: String) {
        
        guard let map = map else {
            fatalError("Can't store nil map")
        }
        
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let mapPayload: Data = try encoder.encode(map)
            try mapPayload.write(to: filename!)
        } catch {
            fatalError("Can't store map: \(error)")
        }
    }
}
