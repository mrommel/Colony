//
//  ImageCache.swift
//  SmartAssets
//
//  Created by Michael Rommel on 06.09.21.
//

import Cocoa

#if os(macOS)
    import AppKit
    public typealias TypeImage = NSImage
#else
    import UIKit
    public typealias TypeImage = UIImage
#endif

public class ImageCache {

    private var dict: [String: TypeImage] = [:]

    public static let shared = ImageCache()

    private init() {
        print("ImageCache initialized")
    }

    public func exists(key: String) -> Bool {

        return self.dict[key] != nil
    }

    public func add(image: TypeImage?, for key: String) {

        guard image != nil else {
            print("Could not load \(key)")
            return
        }

        self.dict[key] = image
    }

    public func image(for key: String) -> TypeImage {

        if let image = self.dict[key] {
            return image
        }

        fatalError("no image with key: '\(key)' in cache")
    }
}
