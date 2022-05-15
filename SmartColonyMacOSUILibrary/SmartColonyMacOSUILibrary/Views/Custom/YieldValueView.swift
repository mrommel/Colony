//
//  YieldValueView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct YieldValueView: View {

    @ObservedObject
    var viewModel: YieldValueViewModel

    public var body: some View {

        TooltipContainerView(self.viewModel.tooltip, side: .trailingBottom) {
            HStack(alignment: .center, spacing: 4) {
                Image(nsImage: self.viewModel.iconImage())
                    .resizable()
                    .frame(width: 12, height: 12, alignment: .center)

                Text(self.viewModel.valueText)
                    .foregroundColor(Color(self.viewModel.fontColor()))
                    .font(.caption)
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
            .padding(.top, 4)
            .padding(.bottom, 4)
            .background(
                Image(nsImage: self.viewModel.backgroundImage())
                    .resizable(capInsets: EdgeInsets(all: 8))
            )
        }
    }
}

#if DEBUG
struct YieldValueView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        YieldValueView(viewModel: YieldValueViewModel(yieldType: .food, initial: 2.32, type: .onlyDelta))

        YieldValueView(viewModel: YieldValueViewModel(yieldType: .production, initial: 12.32, type: .onlyValue))

        YieldValueView(viewModel: YieldValueViewModel(yieldType: .science, initial: 12.32, type: .valueAndDelta, withBackground: false))
    }
}
#endif
