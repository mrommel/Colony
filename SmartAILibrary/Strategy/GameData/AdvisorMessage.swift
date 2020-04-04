//
//  AdvisorMessage.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 06.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class AdvisorMessage {
    
    let advisor: AdvisorType
    let message: String
    let importance: Int
    
    init(advisor: AdvisorType, message: String, importance: Int = 1) {
        
        self.advisor = advisor
        self.message = message
        self.importance = importance
    }
}

extension AdvisorMessage: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        return "(Advisor advisor=\(self.advisor), message=\(self.message), importance=\(self.importance))"
    }
}
