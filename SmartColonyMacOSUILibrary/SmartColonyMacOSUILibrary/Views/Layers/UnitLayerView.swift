//
//  UnitLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI

public struct UnitLayerView: View {
    
    @ObservedObject
    var viewModel: UnitLayerViewModel
    
    init(viewModel: UnitLayerViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        ForEach(self.viewModel.units) { unit in

            ZStack {
                Image(nsImage: ImageCache.shared.image(for: unit.assets()[0]))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 144, height: 144, alignment: .center)
                
                Text(unit.name)
            }
            .frame(width: 144, height: 144, alignment: .center)
            .padding(.leading, unit.location.x)
            .padding(.top, unit.location.y)
            
            /*AnimatedImage(unit.assets(), interval: 0.5)
                .padding(.leading, unit.location.x)
                .padding(.top, unit.location.y)*/
                
            /*Text(unit.name)
                .padding(.leading, unit.location.x)
                .padding(.top, unit.location.y)*/
        }
    }
}
