//
//  UnitView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary

struct UnitView: View {

    @ObservedObject
    var viewModel: UnitViewModel

    var body: some View {

        HStack(alignment: .center, spacing: 8) {
            
            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 24, height: 24, alignment: .topLeading)
                .padding(.leading, 16)
                .padding(.top, 9)
            
            Text(self.viewModel.title())
                .padding(.top, 9)
            
            Spacer()
            
            Text(self.viewModel.turnsText())
                .padding(.top, 9)
                .padding(.trailing, 0)
            
            Image(nsImage: self.viewModel.costTypeIcon())
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
struct UnitView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = UnitViewModel(unitType: .archer, turns: 6)
        UnitView(viewModel: viewModel)

        let player = Player(leader: .alexander)
        let unit = SmartAILibrary.Unit(at: HexPoint.zero, type: .settler, owner: player)
        let viewModel2 = UnitViewModel(unit: unit)
        UnitView(viewModel: viewModel2)
    }
}
#endif
