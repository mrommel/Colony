//
//  PantheonViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.05.21.
//

import SwiftUI
import SmartAILibrary

class PantheonViewModel: ObservableObject {
    
    @Published
    var pantheonName: String
    
    init(pantheonType: PantheonType) {
        
        self.pantheonName = pantheonType.name()
    }
}
