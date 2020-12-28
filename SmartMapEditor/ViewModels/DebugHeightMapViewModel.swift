//
//  DebugHeightMapViewModel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 23.12.20.
//

import Cocoa
import SmartAILibrary
import SwiftUI

class DebugHeightMapViewModel: ObservableObject {

    typealias ClosedHandler = () -> Void

    @Published
    var selectedOctavesIndex: Int = 4
    let octaves = ["1", "2", "4", "6", "8", "10", "12", "16", "32"]

    @Published
    var zoom: Double

    @Published
    var persistence: Double

    @Published
    var image: NSImage

    private let mapSize: MapSize
    var closed: ClosedHandler? = nil

    init(size: MapSize) {

        self.selectedOctavesIndex = 4 // "8"
        self.zoom = 1.0
        self.persistence = 1.0

        self.mapSize = size

        self.image = NSImage(size: NSSize(width: mapSize.width() * 4, height: mapSize.height() * 4))

        let heightMap: HeightMap = HeightMap(width: mapSize.width(), height: mapSize.height())
        heightMap.generate(withOctaves: Int(self.octaves[self.selectedOctavesIndex]) ?? 8, zoom: self.zoom, andPersistence: self.persistence)
        heightMap.normalize()

        self.renderImage(from: heightMap)
    }

    func octavesChanged(_ newValue: Int) {

        self.selectedOctavesIndex = newValue
    }

    func renderImage(from heightMap: HeightMap) {

        DispatchQueue.global(qos: .background).async {
            let pixelImage = PixelImage(from: heightMap)

            if let heightMapImage = pixelImage.image() {
                DispatchQueue.main.async {
                    self.image = heightMapImage
                }
            }
        }
    }

    func update() {

        print("selectedOctavesIndex => \(self.selectedOctavesIndex)")
        let octavesVal = Int(self.octaves[self.selectedOctavesIndex]) ?? 8

        print("update with \(octavesVal) octaves")

        let heightMap: HeightMap = HeightMap(width: mapSize.width(), height: mapSize.height())
        heightMap.generate(withOctaves: octavesVal, zoom: self.zoom, andPersistence: self.persistence)
        heightMap.normalize()

        self.renderImage(from: heightMap)
    }

    func cancel() {

        print("cancel")
        self.closed?()
    }
}
