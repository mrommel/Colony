//
//  SelectItemView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.09.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct SelectItemView: View {

    let viewModel: SelectItemViewModel

    init(viewModel: SelectItemViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(alignment: .top, spacing: 4) {
            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 32, height: 32, alignment: .center)

            VStack(alignment: .leading, spacing: 4) {
                Text(self.viewModel.title)
                    .font(.headline)

                Text(self.viewModel.subtitle)
                    .font(.footnote)
                    .padding(.top, 1)
            }
        }
        .padding(.all, 4)
        .frame(width: 250, alignment: .leading)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-button-clicked"))
                .resizable(capInsets: EdgeInsets(all: 15))
                .hueRotation(Angle(degrees: 135))
        )
    }
}

#if DEBUG
struct SelectItemView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let selectableItem = SelectableItem(title: "Item title", subtitle: "Subtitle")
        let viewModel = SelectItemViewModel(item: selectableItem, index: 0)
        SelectItemView(viewModel: viewModel)

        // swiftlint:disable:next line_length
        let selectableItemMultiline = SelectableItem(title: "Item title", subtitle: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.")
        let viewModelMultiline = SelectItemViewModel(item: selectableItemMultiline, index: 0)
        SelectItemView(viewModel: viewModelMultiline)
    }
}
#endif
