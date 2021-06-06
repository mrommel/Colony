//
//  NotificationViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SmartAILibrary
import Cocoa

protocol NotificationViewModelDelegate: AnyObject {
    
    func clicked(on item: NotificationItem)
}

class NotificationViewModel: ObservableObject {
    
    @Published
    var title: String
    
    private let item: NotificationItem
    
    weak var delegate: NotificationViewModelDelegate?
    
    init(item: NotificationItem) {
        
        self.item = item
        self.title = item.type.iconTexture()
    }
    
    func icon() -> NSImage {
        
        return ImageCache.shared.image(for: self.item.type.iconTexture())
    }
    
    func background() -> NSImage {
        
        return ImageCache.shared.image(for: "notification-bagde")
    }
    
    func click() {
        
        self.delegate?.clicked(on: self.item)
    }
}

extension NotificationViewModel: Hashable {
    
    static func == (lhs: NotificationViewModel, rhs: NotificationViewModel) -> Bool {
        
        return lhs.item == rhs.item
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.item.type)
        hasher.combine(self.item.location)
    }
}
