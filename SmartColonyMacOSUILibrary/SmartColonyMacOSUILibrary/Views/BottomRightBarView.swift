//
//  BottomRightBarView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 07.04.21.
//

import SwiftUI

public struct BottomRightBarView: View {
    
    @ObservedObject
    public var viewModel: GameSceneViewModel
    
    public var body: some View {
        HStack {
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {

                Spacer()
                MapOverviewView(viewModel: self.viewModel.mapOverviewViewModel)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

/*struct BottomRightBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let viewModel = MapViewModel(game: <#Binding<GameModel?>#>)
        BottomRightBarView(viewModel: viewModel)
    }
}*/
