//
//  EurekaCivicActivatedPopupView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

struct EurekaCivicActivatedPopupView: View {
    
    @ObservedObject
    var viewModel: EurekaCivicActivatedPopupViewModel
    
    public init(viewModel: EurekaCivicActivatedPopupViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Group {
            VStack(spacing: 0) {
                
                Text(self.viewModel.title)
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                VStack(alignment: .center, spacing: 10) {
                    
                    Text(self.viewModel.summaryText)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 10)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    
                    GroupBox {
                        HStack(alignment: .center) {
                            
                            Image(nsImage: self.viewModel.icon())
                            
                            Text(self.viewModel.descriptionText)
                                .font(.caption)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 10)
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                        }
                    }
                    
                    
                    Button(action: {
                        self.viewModel.closePopup()
                    }, label: {
                        Text("Close")
                    })
                    .padding(.bottom, 8)
                }
                .frame(width: 362, height: 174, alignment: .center)
                .background(Color(Globals.Colors.dialogBackground))
            }
            .padding(.bottom, 43)
            .padding(.leading, 19)
            .padding(.trailing, 19)
            
        }
        .frame(width: 400, height: 260, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}

#if DEBUG
struct EurekaCivicActivatedPopupView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = EurekaCivicActivatedPopupViewModel(civicType: .codeOfLaws)

        EurekaCivicActivatedPopupView(viewModel: viewModel)
    }
}
#endif
