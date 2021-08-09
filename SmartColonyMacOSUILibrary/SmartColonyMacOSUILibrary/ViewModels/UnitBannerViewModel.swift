//
//  UnitBannerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 09.08.21.
//

import SwiftUI

class UnitBannerViewModel: ObservableObject {
    
    @Published
    var name: String
    
    @Published
    var showBanner: Bool = false
    
    init(name: String = "") {
        
        self.name = name
    }
}
