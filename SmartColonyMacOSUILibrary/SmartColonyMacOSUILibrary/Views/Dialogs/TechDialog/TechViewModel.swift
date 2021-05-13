//
//  TechViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI
import SmartAILibrary

class TechViewModel: ObservableObject {
    
    @Published
    var title: String
    
    init(techType: TechType, progress: Double) {
        self.title = techType.name()
    }
}
