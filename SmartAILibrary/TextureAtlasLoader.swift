//
//  TextureAtlasLoader.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 17.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import XMLParsing

public class TextureAtlasLoader {
    
    public static func load(named atlasName: String, in bundle: Bundle = Bundle.main) -> TextureAtlas? {
        
        do {
            guard let atlasUrl = bundle.url(forResource: atlasName, withExtension: "xml") else {
                print("ERROR: cant get atlas named: '\(atlasName)'")
                return nil
            }
            let jsonData = try Data(contentsOf: atlasUrl, options: .mappedIfSafe)

            let atlas = try XMLDecoder().decode(TextureAtlas.self, from: jsonData)
            return atlas
        } catch {
            return nil
        }
    }
}
