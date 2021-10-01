//
//  GreatPersonView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 01.10.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct GreatPersonView: View {

    @ObservedObject
    var viewModel: GreatPersonViewModel

    private let cornerRadius: CGFloat = 5
    private let cardWidth: CGFloat = 100
    private let cardHeight: CGFloat = 300
    private let imageSize: CGFloat = 70

    public init(viewModel: GreatPersonViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        ZStack {

            RoundedRectangle(cornerRadius: self.cornerRadius)
                .strokeBorder(Color(Globals.Colors.dialogBorder), lineWidth: 1)
                .frame(width: self.cardWidth, height: self.cardHeight)
                .background(Color(Globals.Colors.dialogBackground))

            VStack(alignment: .center, spacing: 4) {

                ZStack {
                    Image(nsImage: self.viewModel.image())
                        .resizable()
                        .frame(width: self.imageSize, height: self.imageSize, alignment: .center)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                        .border(Color.black)

                    // self.imageInfoView
                }
                .frame(width: self.imageSize, height: self.imageSize, alignment: .center)
                .padding(.top, 8)

                Text(self.viewModel.name)

                Divider()
                    .background(Color(Globals.Colors.dialogBorder))
                    .padding(.horizontal, 6)

                Spacer()
                    .frame(minHeight: 0, maxHeight: 50)

                //self.assignmentView

                //self.buttonView
            }
            .frame(width: self.cardWidth, height: self.cardHeight - 8, alignment: .center)
            .padding(.bottom, 8)
        }
        .frame(width: self.cardWidth, height: self.cardHeight, alignment: .center)
        .cornerRadius(self.cornerRadius)
    }
}
