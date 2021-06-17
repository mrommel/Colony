//
//  HexagonViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol HexagonViewModelDelegate: AnyObject {
    
    func clicked(on point: HexPoint)
}

class HexagonViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var showCitizenIcons: Bool

    private let point: HexPoint
    private let tileColor: NSColor
    private let mountainsTextureName: String?
    private let hillsTextureName: String?
    private let forestTextureName: String?
    private let cityTextureName: String?
    private let tileActionTextureName: String?
    
    weak var delegate: HexagonViewModelDelegate?
    
    init(at point: HexPoint,
         tileColor: NSColor,
         mountains: String?,
         hills: String?,
         forest: String?,
         city: String?,
         tileAction: String?,
         showCitizenIcons: Bool) {
        
        self.point = point
        self.tileColor = tileColor
        self.mountainsTextureName = mountains
        self.hillsTextureName = hills
        self.forestTextureName = forest
        self.cityTextureName = city
        self.tileActionTextureName = tileAction
        
        self.showCitizenIcons = showCitizenIcons
    }
    
    func color() -> NSColor {
        
        return self.tileColor
    }
    
    func offset() -> CGSize {
        
        let screenPoint = HexPoint.toScreen(hex: self.point)
        return CGSize(fromPoint: CGPoint(x: screenPoint.x, y: -screenPoint.y))
    }
    
    func showMountains() -> Bool {
        
        return self.mountainsTextureName != nil
    }
    
    func mountainsImage() -> NSImage {
        
        guard let texture = self.mountainsTextureName else {
            return NSImage()
        }
        
        return ImageCache.shared.image(for: texture)
    }
    
    func showHills() -> Bool {
        
        return self.hillsTextureName != nil
    }
    
    func hillsImage() -> NSImage {
        
        guard let texture = self.hillsTextureName else {
            return NSImage()
        }
        
        return ImageCache.shared.image(for: texture)
    }
    
    func showForest() -> Bool {
        
        return self.forestTextureName != nil
    }
    
    func forestImage() -> NSImage {
        
        guard let texture = self.forestTextureName else {
            return NSImage()
        }
        
        return ImageCache.shared.image(for: texture)
    }
    
    func showCity() -> Bool {
        
        return self.cityTextureName != nil
    }
    
    func cityImage() -> NSImage {
        
        guard let texture = self.cityTextureName else {
            return NSImage()
        }
        
        return ImageCache.shared.image(for: texture)
    }
    
    func actionImage() -> NSImage {
        
        guard let texture = self.tileActionTextureName else {
            return NSImage()
        }
        
        return ImageCache.shared.image(for: texture)
    }
    
    func clicked() {
        
        self.delegate?.clicked(on: self.point)
    }
}

extension HexagonViewModel: Hashable {
    
    static func == (lhs: HexagonViewModel, rhs: HexagonViewModel) -> Bool {
        
        return lhs.point == rhs.point
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.point)
    }
}
