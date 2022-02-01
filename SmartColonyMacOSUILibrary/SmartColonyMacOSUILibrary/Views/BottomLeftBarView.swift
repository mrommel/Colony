//
//  BottomMenuView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI
import SmartAssets

public struct BottomLeftBarView: View {

    @ObservedObject
    public var viewModel: BottomLeftBarViewModel

    @State
    var showCommandsBody: Bool = false

    public var body: some View {
        HStack(alignment: .bottom) {

            VStack(alignment: .leading, spacing: 10) {

                Spacer(minLength: 10)

                ZStack(alignment: .bottomLeading) {

                    Image("black_circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                        .padding(.top, 10)
                        .padding(.leading, 3)

                    AnimatedImageView(viewModel: self.viewModel.buttonViewModel)
                        .frame(width: 83, height: 83)
                        .offset(x: 6, y: -7)
                        .onTapGesture {
                            self.viewModel.buttonClicked()
                        }

                    ZStack(alignment: .bottomLeading) {

                        Image(nsImage: self.viewModel.typeBackgroundImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)

                        Image(nsImage: self.viewModel.typeTemplateImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                    }
                    .frame(width: 16, height: 16)
                    .clipShape(Circle())
                    .offset(x: 5, y: -5)

                    Image(nsImage: ImageCache.shared.image(for: "unit-canvas"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 111, height: 112)
                        .allowsHitTesting(false)

                    HStack(alignment: .center, spacing: 2) {

                        Image(nsImage: self.viewModel.nextAgeImage())
                            .resizable()
                            .frame(width: 10, height: 10)
                            .padding(.leading, 4)

                        Text(self.viewModel.nextAgeProgress())
                            .font(.caption)
                            .padding(.trailing, 4)
                    }
                    .background(Color.black)
                    .border(Color.white, width: 1, cornerRadius: 6)
                    .offset(x: 25, y: 0)
                }
            }

            Spacer(minLength: 10)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

#if DEBUG
struct BottomLeftBarView_Previews: PreviewProvider {

    static var previews: some View {

        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = BottomLeftBarViewModel()
        BottomLeftBarView(viewModel: viewModel)
    }
}
#endif
