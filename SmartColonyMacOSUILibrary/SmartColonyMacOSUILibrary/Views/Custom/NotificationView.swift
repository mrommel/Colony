//
//  NotificationView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SwiftUI

struct NotificationView: View {
    
    @ObservedObject
    public var viewModel: NotificationViewModel
    
    public init(viewModel: NotificationViewModel) {
        
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            Image(nsImage: self.viewModel.background())
                .resizable()
                .frame(width: 61, height: 65, alignment: .center)
            
            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 40, height: 40, alignment: .center)
                .padding(.top, 13.5)
                .padding(.leading, 14)
            
            Circle()
                .fill(Color.white.opacity(0.01))
                .frame(width: 40, height: 40)
                .padding(.top, 13.5)
                .padding(.leading, 14)
                .onTapGesture {
                    self.viewModel.click()
                }
        }
        .frame(width: 61, height: 65, alignment: .center)
    }
}

#if DEBUG
struct NotificationView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = NotificationViewModel(type: .cityGrowth, location: .zero)
        
        NotificationView(viewModel: viewModel)
    }
}
#endif
