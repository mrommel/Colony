//
//  MapOverviewView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

public struct MapOverviewView: View {
    
    @ObservedObject
    var viewModel: MapOverviewViewModel
    
    public var body: some View {
        
        ZStack {
            
            self.viewModel.image
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100, alignment: .center)
            
            Text("MapOverview")
        }
        .frame(width: 200, height: 100, alignment: .center)
    }
}
