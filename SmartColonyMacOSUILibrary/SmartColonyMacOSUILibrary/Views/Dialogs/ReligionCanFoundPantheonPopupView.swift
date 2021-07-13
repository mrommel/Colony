//
//  ReligionCanFoundPantheonPopupView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.07.21.
//

import SwiftUI

struct ReligionCanFoundPantheonPopupView: View {
    
    @ObservedObject
    var viewModel: ReligionCanFoundPantheonPopupViewModel
    
    private var gridItemLayout = [GridItem(.fixed(250)), GridItem(.fixed(250))]
    
    public init(viewModel: ReligionCanFoundPantheonPopupViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Group {
            VStack(spacing: 10) {
                Text("Select Pantheon")
                    .font(.title2)
                    .bold()
                    .padding()
                
                ScrollView(.horizontal, showsIndicators: true, content: {
                    
                    LazyHGrid(rows: gridItemLayout, spacing: 20) {
                        
                        ForEach(self.viewModel.pantheonViewModels) { pantheonViewModel in

                            PantheonView(viewModel: pantheonViewModel)
                                .padding(0)
                                .onTapGesture {
                                    pantheonViewModel.selectPantheon()
                                }
                        }
                    }
                })
                
                Button(action: {
                    self.viewModel.closeDialog()
                }, label: {
                    Text("Okay")
                })
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 700, height: 550, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}

#if DEBUG
struct ReligionCanFoundPantheonPopupView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)

        ReligionCanFoundPantheonPopupView(viewModel: ReligionCanFoundPantheonPopupViewModel())
    }
}
#endif
