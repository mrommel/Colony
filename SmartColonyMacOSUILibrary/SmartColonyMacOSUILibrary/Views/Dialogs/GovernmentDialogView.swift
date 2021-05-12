//
//  GovernmentDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 11.05.21.
//

import SwiftUI
import SmartAILibrary

struct GovernmentDialogView: View {
    
    @ObservedObject
    var viewModel: GovernmentDialogViewModel
    
    private var gridItemLayout = [GridItem(.fixed(300)), GridItem(.fixed(300))]

    public init(viewModel: GovernmentDialogViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            VStack(spacing: 10) {
                Text("Select Government")
                    .font(.title2)
                    .bold()
                    .padding()
                
                ScrollView(.vertical, showsIndicators: true, content: {
                    
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        
                        ForEach(self.viewModel.governmentCardViewModels, id: \.self) {

                            GovernmentCardView(viewModel: $0)
                                .background(Color.white.opacity(0.1))
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
        .frame(width: 700, height: 450, alignment: .top)
        .background(
            Image("grid9-dialog")
                .resizable(capInsets: EdgeInsets(all: 45)
            )
        )
    }
}
