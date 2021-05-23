//
//  YieldValueViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class YieldValueViewModel: ObservableObject {
    
    let yieldType: YieldType
    
    @Published
    var value: Double {
        didSet {
            self.valueText = String(format: "%.1f", self.value)
        }
    }
    
    @Published
    var valueText: String
    
    @Published
    var withBackground: Bool
    
    init(yieldType: YieldType, value: Double, withBackground: Bool = true) {
        
        self.yieldType = yieldType
        self.value = value
        self.withBackground = withBackground
        
        self.valueText = String(format: "%.1f", value)
    }
    
    func iconImage() -> NSImage {
        
        return ImageCache.shared.image(for: self.yieldType.iconTexture())
    }
    
    func fontColor() -> NSColor {
        
        if self.withBackground {
            return self.yieldType.fontColor()
        } else {
            //return self.yieldType.fontColor().lighter(componentDelta: 0.2)
            return .white
        }
    }
    
    func backgroundImage() -> NSImage {
        
        if self.withBackground {
            return ImageCache.shared.image(for: self.yieldType.backgroundTexture())
        } else {
            return NSImage(size: NSSize(width: 20, height: 20))
        }
    }
}

extension YieldValueViewModel: Hashable {
    
    static func == (lhs: YieldValueViewModel, rhs: YieldValueViewModel) -> Bool {
        
        return lhs.yieldType == rhs.yieldType
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.yieldType)
    }
}
