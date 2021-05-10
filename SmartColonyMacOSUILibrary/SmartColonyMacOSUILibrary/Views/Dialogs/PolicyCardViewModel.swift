//
//  PolicyCardViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 10.05.21.
//

import Cocoa
import SmartAILibrary
import SmartAssets

enum PolicyCardState {

    case selected
    case active
    case disabled
    
    case none
    
    func textureName() -> String {
        
        switch self {

        case .none: return "checkbox-none"
            
        case .selected: return "checkbox-checked"
        case .active: return "checkbox-unchecked"
        case .disabled: return "checkbox-disabled"
        }
    }
}

class PolicyCardViewModel: ObservableObject {
    
    // variables
    let policyCardType: PolicyCardType
    var state: PolicyCardState
    
    @Published
    var selected: Bool {
        didSet {
            
            if self.state == .disabled && self.selected {
                self.selected = false
            }
        }
    }
    
    init(policyCardType: PolicyCardType, state: PolicyCardState) {

        self.policyCardType = policyCardType
        self.state = state
        
        self.selected = self.state == .selected
    }
    
    func title() -> String {
        
        return self.policyCardType.name()
    }
    
    func summary() -> String {
        
        /*let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let bonusTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.white,
            .backgroundColor: NSColor.black.withAlphaComponent(0.5),
            .font: NSFont.boldSystemFont(ofSize: 7),
            .paragraphStyle: paragraphStyle
        ]
        
        let bonusTextAttributed = NSAttributedString(string: self.policyCardType.bonus().replaceIcons(),
                                                     attributes: bonusTextAttributes)
        
        return bonusTextAttributed*/
        return self.policyCardType.bonus().replaceIcons()
    }
    
    func background() -> NSImage {
        
        return ImageCache.shared.image(for: self.policyCardType.iconTexture())
    }
}
