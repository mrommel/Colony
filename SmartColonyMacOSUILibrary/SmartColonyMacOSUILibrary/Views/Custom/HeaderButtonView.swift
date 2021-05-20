//
//  HeaderButtonView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI

struct HeaderButtonView: View {
    
    @ObservedObject
    public var viewModel: HeaderButtonViewModel
    
    public init(viewModel: HeaderButtonViewModel) {
        
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 38, height: 38, alignment: .center)
                .padding(.top, 4)
                .padding(.leading, 9.5)
                .onTapGesture {
                    self.viewModel.clicked()
                }
        }
        .frame(width: 56, height: 47, alignment: .topLeading)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "header-bar-button"))
                .resizable()
            )
    }
}

#if DEBUG
struct HeaderButtonView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = HeaderButtonViewModel(type: .government)
        
        HeaderButtonView(viewModel: viewModel)
    }
}
#endif