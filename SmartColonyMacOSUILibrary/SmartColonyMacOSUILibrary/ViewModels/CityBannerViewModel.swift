//
//  CityBannerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.06.21.
//

import SwiftUI

class CityBannerViewModel: ObservableObject {
    
    @Published
    var name: String
    
    @Published
    var showBanner: Bool = false
    
    init(name: String = "") {
        
        self.name = name
    }
}
