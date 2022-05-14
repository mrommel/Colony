//
//  UnitCommandView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct UnitCommandView: View {

    @ObservedObject
    var viewModel: UnitCommandViewModel

    private let imageWidth: CGFloat = 32
    private let imageHeight: CGFloat = 32

    public init(viewModel: UnitCommandViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        TooltipContainerView(self.viewModel.toolTip(), side: .top) {
            Image(nsImage: self.viewModel.image())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: self.imageWidth, height: self.imageHeight)
                .onTapGesture {
                    self.viewModel.clicked()
                }
        }
    }
}

#if DEBUG
struct UnitCommandView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = UnitCommandViewModel()
        UnitCommandView(viewModel: viewModel)
    }
}
#endif
