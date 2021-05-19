//
//  NotificationsView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SwiftUI

struct NotificationsView: View {
    
    @ObservedObject
    public var viewModel: NotificationsViewModel
    
    private var gridItemLayout = [GridItem(.fixed(61))]
   
    public init(viewModel: NotificationsViewModel) {
        
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        HStack(alignment: .top, spacing: 10) {
            
            VStack(alignment: .trailing, spacing: 0 ) {

                Spacer()
                
                Image(nsImage: ImageCache.shared.image(for: "notification-top"))
                    .frame(width: 61, height: 31, alignment: .center)
                    
                ForEach(self.viewModel.notificationViewModels, id: \.self) { notificationViewModel in

                    NotificationView(viewModel: notificationViewModel)
                }
                
                Image(nsImage: ImageCache.shared.image(for: "notification-bottom"))
                    .resizable()
                    .frame(width: 61, height: 120, alignment: .center)
            }
            
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

#if DEBUG
struct NotificationsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = NotificationsViewModel(types: [NotificationInfo(type: .cityGrowth, location: .invalid), NotificationInfo(type: .generic, location: .invalid)])
        
        NotificationsView(viewModel: viewModel)
    }
}
#endif
