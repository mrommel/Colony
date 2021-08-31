//
//  SelectPromotionDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 31.08.21.
//

import SwiftUI

struct SelectPromotionDialogView: View {

    @ObservedObject
    var viewModel: SelectPromotionDialogViewModel

    var body: some View {
        Group {
            VStack(spacing: 10) {
                HStack {

                    Spacer()

                    Text("Select promotion")
                        .font(.title2)
                        .bold()
                        .padding(.top, 14)

                    Spacer()
                }

                ScrollView(.vertical, showsIndicators: true, content: {

                    LazyVStack(spacing: 10) {

                        ForEach(self.viewModel.promotionViewModels, id: \.self) { promotionViewModel in

                            PromotionView(viewModel: promotionViewModel)
                                .padding(.top, 8)
                        }
                    }
                })
                .frame(width: 340, height: 300, alignment: .center)
                .border(Color.gray)

                Button(action: {
                    self.viewModel.closeDialog()
                }, label: {
                    Text("Okay")
                })
                .buttonStyle(DialogButtonStyle())
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 400, height: 450, alignment: .top)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-dialog"))
                .resizable(capInsets: EdgeInsets(all: 45))
        )
    }
}
