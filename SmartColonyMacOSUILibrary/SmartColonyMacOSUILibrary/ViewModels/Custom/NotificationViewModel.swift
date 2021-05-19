//
//  NotificationViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SmartAILibrary
import Cocoa

protocol NotificationViewModelDelegate: AnyObject {
    
    func clicked(type: NotificationType, location: HexPoint)
}

class NotificationViewModel: ObservableObject {
    
    let type: NotificationType
    let location: HexPoint
    
    weak var delegate: NotificationViewModelDelegate?
    
    init(type: NotificationType, location: HexPoint) {
        
        self.type = type
        self.location = location
    }
    
    func title() -> String {
        
        return self.type.iconTexture()
    }
    
    func icon() -> NSImage {
        
        return ImageCache.shared.image(for: self.type.iconTexture())
    }
    
    func background() -> NSImage {
        
        return ImageCache.shared.image(for: "notification-bagde")
    }
    
    func click() {
        
        self.delegate?.clicked(type: self.type, location: self.location)
    }
}

extension NotificationViewModel: Hashable {
    
    static func == (lhs: NotificationViewModel, rhs: NotificationViewModel) -> Bool {
        
        return lhs.type == rhs.type
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.type)
    }
}
