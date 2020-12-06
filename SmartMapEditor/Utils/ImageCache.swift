//
//  ImageCache.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 01.12.20.
//

import Cocoa

class ImageCache {
    
    private var dict: [String: NSImage] = [:]
    
    init() {
        
    }
    
    func exists(key: String) -> Bool {
        
        return self.dict[key] != nil
    }
    
    func add(image: NSImage?, for key: String) {
 
        self.dict[key] = image
    }
    
    func image(for key: String) -> NSImage {
        
        if let image = self.dict[key] {
            return image
        }
        
        fatalError("no image with key: \(key) in cache")
        // feature_ice-to-water-se-sw
        // feature_ice-to-water-se-sw
    }
}
