//
//  MapOverviewView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI

struct MapOverviewView: View {
    
    var body: some View {
        ZStack {
            Text("MapOverview")
            
            Rectangle()
                .fill(Color.red)
                .frame(width: 200, height: 100, alignment: .center)
                
        }
        .frame(width: 200, height: 100, alignment: .center)
    }
}
