//
//  BuildingView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary

struct BuildingView: View {
    
    @ObservedObject
    var viewModel: BuildingViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            
            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 24, height: 24, alignment: .topLeading)
                .padding(.leading, 16)
                .padding(.top, 9)
            
            Text(self.viewModel.title())
                .padding(.top, 9)
            
            Spacer()
            
            Text(self.viewModel.turnsText())
                .padding(.top, 9)
                .padding(.trailing, 16)
        }
        .frame(width: 300, height: 42, alignment: .topLeading)
        .background(
            Image(nsImage: self.viewModel.background())
                .resizable(capInsets: EdgeInsets(all: 15))
        )
    }
}

#if DEBUG
struct BuildingView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = BuildingViewModel(buildingType: .granary, turns: 6)
        
        BuildingView(viewModel: viewModel)
    }
}
#endif
