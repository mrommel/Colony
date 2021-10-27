//
//  ResourceValueView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.10.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct ResourceValueView: View {

    @ObservedObject
    var viewModel: ResourceValueViewModel

    public var body: some View {

        HStack(alignment: .center, spacing: 4) {
            Image(nsImage: self.viewModel.iconImage())
                .resizable()
                .frame(width: 14, height: 14, alignment: .center)

            Text(self.viewModel.valueText)
                .foregroundColor(Color.white)
                .font(.caption)
        }
        .padding(.leading, 4)
        .padding(.trailing, 4)
        .padding(.top, 2)
        .padding(.bottom, 2)
    }
}

#if DEBUG
struct ResourceValueView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        ResourceValueView(viewModel: ResourceValueViewModel(resourceType: .salt, initial: 2))

        ResourceValueView(viewModel: ResourceValueViewModel(resourceType: .wheat, initial: 1, withBackground: false))

        ResourceValueView(viewModel: ResourceValueViewModel(resourceType: .whales, initial: 12))
    }
}
#endif
