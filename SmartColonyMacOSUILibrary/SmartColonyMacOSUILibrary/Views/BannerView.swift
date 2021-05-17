//
//  BannerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.05.21.
//

import SwiftUI

struct BannerView: View {
    
    @ObservedObject
    public var viewModel: GameSceneViewModel
    
    public var body: some View {
        
        VStack(alignment: .center) {

            Spacer()
            
            HStack(alignment: .center, spacing: 10) {
                
                Spacer()

                if self.viewModel.showBanner {
                    ZStack {
                        Text("Other players are taking their turns, please wait ...")
                    }
                    .background(
                        Image(nsImage: ImageCache.shared.image(for: "grid9-button-active"))
                            .resizable()
                        )
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct BannerView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = GameSceneViewModel()
        
        BannerView(viewModel: viewModel)
    }
}
