//
//  GoodyHutRewardPopupView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

struct GoodyHutRewardPopupView: View {
    
    @ObservedObject
    var viewModel: GoodyHutRewardPopupViewModel
    
    public init(viewModel: GoodyHutRewardPopupViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Group {
            VStack(spacing: 0) {
                
                Text(self.viewModel.title)
                    .font(.title2)
                    .bold()
                    .padding(.top, 13)
                    .padding(.bottom, 10)
                
                VStack(spacing: 10) {
                    
                    Text(self.viewModel.text)
                        .padding(.bottom, 10)
                    
                    Button(action: {
                        self.viewModel.closePopup()
                    }, label: {
                        Text("Close")
                    })
                    .padding(.bottom, 8)
                }
                .frame(width: 262, height: 114, alignment: .center)
                .background(Color(Globals.Colors.dialogBackground))
            }
            .padding(.bottom, 43)
            .padding(.leading, 19)
            .padding(.trailing, 19)
            
        }
        .frame(width: 300, height: 200, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}

#if DEBUG
struct GoodyHutRewardPopupView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        //let game = DemoGameModel()
        //let environment = GameEnvironment(game: game)
        let viewModel = GoodyHutRewardPopupViewModel(goodyHutType: .additionalPopulation, location: HexPoint.zero)

        GoodyHutRewardPopupView(viewModel: viewModel)
            //.environment(\.gameEnvironment, environment)
    }
}
#endif
