//
//  YieldValueViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

enum YieldValueDisplayType {
    
    case onlyValue
    case onlyDelta
    case valueAndDelta
}

class YieldValueViewModel: ObservableObject {
    
    let yieldType: YieldType

    var value: Double {
        didSet {
            self.updateText()
        }
    }
    
    var delta: Double {
        didSet {
            self.updateText()
        }
    }
    
    @Published
    var valueText: String
    
    var withBackground: Bool
    
    var type: YieldValueDisplayType
    
    init(yieldType: YieldType, initial value: Double, type: YieldValueDisplayType, withBackground: Bool = true) {
        
        self.yieldType = yieldType
        self.value = value
        self.delta = 0.0
        self.withBackground = withBackground
        self.type = type
        
        self.valueText = ""
    }
    
    func iconImage() -> NSImage {
        
        return ImageCache.shared.image(for: self.yieldType.iconTexture())
    }
    
    private func updateText() {
        
        switch self.type {
        
        case .onlyValue:
            self.valueText = String(format: "%.1f", self.value)
        case .onlyDelta:
            var delText = String(format: "%.1f", self.delta)
            
            if self.delta > 0.0 {
                delText = "+" + delText
            }
            
            self.valueText = delText
        case .valueAndDelta:
            let valText = String(format: "%.1f", self.value)
            var delText = String(format: "%.1f", self.delta)
            
            if self.delta > 0.0 {
                delText = "+" + delText
            }
            
            self.valueText = "\(valText) \(delText)"
        }
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
