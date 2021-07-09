//
//  TopBarView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.05.21.
//

import SwiftUI

public struct TopBarView: View {
    
    @ObservedObject
    public var viewModel: TopBarViewModel
    
    public var body: some View {
        
        VStack(alignment: .trailing) {

            HStack(alignment: .top, spacing: 10) {

                YieldValueView(viewModel: self.viewModel.scienceYieldValueViewModel)
                
                YieldValueView(viewModel: self.viewModel.cultureYieldValueViewModel)
                
                YieldValueView(viewModel: self.viewModel.faithYieldValueViewModel)
                
                YieldValueView(viewModel: self.viewModel.goldYieldValueViewModel)
                
                Spacer()
                
                Text(self.viewModel.turnText())
                    .padding(.trailing, 3)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 24, maxHeight: 24, alignment: .topLeading)
            .background(
                Image(nsImage: ImageCache.shared.image(for: "top-bar"))
                    .resizable()
            )
            
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct TopBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = TopBarViewModel()
        
        TopBarView(viewModel: viewModel)
    }
}
