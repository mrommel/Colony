//
//  NotificationViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SmartAILibrary
import Cocoa

protocol NotificationViewModelDelegate: AnyObject {
    
    func clicked(type: NotificationType)
}

class NotificationViewModel: ObservableObject {
    
    let type: NotificationType
    
    weak var delegate: NotificationViewModelDelegate?
    
    init(type: NotificationType) {
        
        self.type = type
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
        
        self.delegate?.clicked(type: self.type)
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
