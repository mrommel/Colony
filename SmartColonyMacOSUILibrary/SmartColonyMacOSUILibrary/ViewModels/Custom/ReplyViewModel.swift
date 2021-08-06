//
//  ReplyViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.08.21.
//

import SwiftUI
import SmartAILibrary

protocol ReplyViewModelDelegate: AnyObject {
    
    func selected(reply: DiplomaticReplyMessage)
}

class ReplyViewModel: ObservableObject, Identifiable {
    
    let id: UUID = UUID()
    
    let reply: DiplomaticReplyMessage
    
    @Published
    var text: String = ""
    
    weak var delegate: ReplyViewModelDelegate? = nil
    
    init(reply: DiplomaticReplyMessage) {
        
        self.reply = reply
        
        self.text = self.reply.text()
    }
    
    func clicked() {
        
        self.delegate?.selected(reply: self.reply)
    }
}

extension ReplyViewModel: Hashable {
    
    static func == (lhs: ReplyViewModel, rhs: ReplyViewModel) -> Bool {
        
        return lhs.reply == rhs.reply
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.reply)
    }
}
