//
//  ImageCache.swift
//  SmartColony
//
//  Created by Michael Rommel on 19.01.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import UIKit

public class ImageCache {

    private var dict: [String: UIImage] = [:]

    public static let shared = ImageCache()

    private init() {
        print("ImageCache initialized")
    }

    public func exists(key: String) -> Bool {

        return self.dict[key] != nil
    }

    public func add(image: UIImage?, for key: String) {

        guard image != nil else {
            print("Could not load \(key)")
            return
        }

        self.dict[key] = image
    }

    public func image(for key: String) -> UIImage {

        if let image = self.dict[key] {
            return image
        }

        fatalError("no image with key: \(key) in cache")
        /*
         convert sepimage-0.png sepimage-1.png  -background transparent -layers flatten imagecopy.png
         
         convert feature_ice-to-water-ne@3x.png feature_ice-to-water-s@3x.png feature_ice-to-water-nw@3x.png -background transparent -layers flatten feature_ice-to-water-ne-s-nw@3x.png
         convert feature_ice-to-water-ne@2x.png feature_ice-to-water-s@2x.png feature_ice-to-water-nw@2x.png -background transparent -layers flatten feature_ice-to-water-ne-s-nw@2x.png
         convert feature_ice-to-water-ne@1x.png feature_ice-to-water-s@1x.png feature_ice-to-water-nw@1x.png -background transparent -layers flatten feature_ice-to-water-ne-s-nw@1x.png
         
         */
    }
}
