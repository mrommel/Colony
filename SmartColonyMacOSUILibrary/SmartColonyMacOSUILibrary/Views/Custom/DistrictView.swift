//
//  DistrictView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary

struct DistrictView: View {

    @ObservedObject
    var viewModel: DistrictViewModel

    var body: some View {

        HStack(alignment: .center, spacing: 10) {

            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 24, height: 24, alignment: .topLeading)
                .padding(.leading, 16)
                .padding(.top, 9)

            Text(self.viewModel.title())
                .foregroundColor(self.viewModel.fontColor())
                .padding(.top, 9)

            Spacer()

            Text(self.viewModel.turnsText())
                .padding(.top, 9)
                .padding(.trailing, 0)

            Image(nsImage: self.viewModel.turnsIcon())
                .resizable()
                .frame(width: 24, height: 24, alignment: .topLeading)
                .padding(.trailing, 16)
                .padding(.top, 9)
        }
        .frame(width: 300, height: 42, alignment: .topLeading)
        .background(
            Image(nsImage: self.viewModel.background())
                .resizable(capInsets: EdgeInsets(all: 15))
        )
        .onTapGesture {
            self.viewModel.clicked()
        }
        .tooltip(self.viewModel.toolTip)
    }
}

#if DEBUG
struct DistrictView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        DistrictView(viewModel: DistrictViewModel(districtType: .campus, at: HexPoint.invalid, turns: 6, active: true))

        DistrictView(viewModel: DistrictViewModel(districtType: .encampment, at: HexPoint.invalid, turns: 3, active: false))
    }
}
#endif
