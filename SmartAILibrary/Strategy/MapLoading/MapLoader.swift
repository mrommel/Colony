//
//  MapLoader.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 02.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class MapLoader {

    public init() {
        
    }
    
    public func load(from url: URL?) -> MapModel? {
    
        if let mapUrl = url {
        
            do {
                let jsonData = try Data(contentsOf: mapUrl, options: .mappedIfSafe)
                
                return try JSONDecoder().decode(MapModel.self, from: jsonData)
            } catch {
                print("Error reading \(error)")
            }
        }
        
        return nil
    }
}
