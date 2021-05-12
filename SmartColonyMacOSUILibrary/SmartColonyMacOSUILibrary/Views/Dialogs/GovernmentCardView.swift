//
//  GovernmentCardView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 11.05.21.
//

import SwiftUI
import SmartAssets

struct GovernmentCardView: View {
    
    @ObservedObject
    var viewModel: GovernmentCardViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(nsImage: self.viewModel.ambient())
                .resizable()
                .frame(width: 300, height: 100, alignment: .topLeading)
                .padding(.top, 30)
            
            Image(nsImage: self.viewModel.background())
                .resizable()
                .frame(width: 300, height: 200, alignment: .topLeading)
            
            VStack(alignment: .center) {
            
                Text(self.viewModel.title())
                    .font(.headline)
                    
                Text(self.viewModel.bonus1Summary())
                    .font(.footnote)
                    .padding(.top, 85)
                
                Text(self.viewModel.bonus2Summary())
                    .font(.footnote)
                    .padding(.top, 15)
            }
            .padding(.top, 13)
            .padding(.leading, 33)
            .padding(.trailing, 33)
        }
        .frame(width: 300, height: 200, alignment: .topLeading)
    }
}

#if DEBUG
struct GovernmentCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = GovernmentCardViewModel(governmentType: .chiefdom, state: .active)
        
        GovernmentCardView(viewModel: viewModel)
    }
}
#endif
