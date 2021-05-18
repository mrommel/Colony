//
//  HeaderView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.05.21.
//

import SwiftUI

struct HeaderView: View {
    
    @ObservedObject
    public var viewModel: GameSceneViewModel
    
    public var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(alignment: .center, spacing: 0) {
                
                HeaderButtonView(viewModel: self.viewModel.scienceHeaderViewModel())
                
                HeaderButtonView(viewModel: self.viewModel.cultureHeaderViewModel())
                
                HeaderButtonView(viewModel: self.viewModel.governmentHeaderViewModel())
                
                HeaderButtonView(viewModel: self.viewModel.logHeaderViewModel())
                
                Image(nsImage: ImageCache.shared.image(for: "header-bar-left"))
                    .resizable()
                    .frame(width: 35, height: 47, alignment: .center)
                
                Spacer()
                
                Image(nsImage: ImageCache.shared.image(for: "header-bar-right"))
                    .resizable()
                    .frame(width: 35, height: 47, alignment: .center)
                
                // ranking
                HeaderButtonView(viewModel: self.viewModel.rankingHeaderViewModel())
                
                // trade routes
                HeaderButtonView(viewModel: self.viewModel.tradeRoutesHeaderViewModel())
            }
            .padding(.top, 24)
            
            TechProgressView(viewModel: self.viewModel.techProgressViewModel())
            
            CivicProgressView(viewModel: CivicProgressViewModel(civic: .codeOfLaws, progress: 24, boosted: false))
            
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

#if DEBUG
struct HeaderView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = GameSceneViewModel()
        
        HeaderView(viewModel: viewModel)
    }
}
#endif
