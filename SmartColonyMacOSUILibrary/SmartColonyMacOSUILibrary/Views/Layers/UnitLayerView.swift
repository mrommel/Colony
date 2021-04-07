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
                //RoundedRectangle(cornerRadius: 15, style: .continuous)
                //    .fill(Color.red)
                
                AnimatedUnitView(
                    unit.type.idleAtlas?.textures ?? [],
                    templateImage: unit.type.idleAtlas?.textures.first,
                    interval: 0.5,
                    loop: true)
                    .frame(width: 72, height: 72, alignment: .center)
                
                Text(unit.name)
            }
            .frame(width: 144, height: 144, alignment: .center)
            .padding(.leading, unit.location.x)
            .padding(.top, unit.location.y)
        }
    }
}
