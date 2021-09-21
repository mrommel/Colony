//
//  GovernorAbilityView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.09.21.
//

import SwiftUI

struct GovernorAbilityView: View {

    let viewModel: GovernorAbilityViewModel

    private let cornerRadius: CGFloat = 5

    init(viewModel: GovernorAbilityViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(spacing: 2) {

            Image(nsImage: self.viewModel.icon())
                .resizable()
                .frame(width: 10, height: 10, alignment: .leading)
                .padding(.leading, 2)

            Text(self.viewModel.text)
                .font(.system(size: 7))
                .frame(width: 70, height: 10, alignment: .leading)
        }
        .padding(.all, 1)
        .background(
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .strokeBorder(Color.black)
                .background(Color.gray.opacity(self.viewModel.enabled ? 0.2 : 0.8))
        )
        .cornerRadius(self.cornerRadius)
    }
}

#if DEBUG
struct GovernorAbilityView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModelEnabled = GovernorAbilityViewModel(text: "Ability", enabled: true)
        GovernorAbilityView(viewModel: viewModelEnabled)

        let viewModelDisabled = GovernorAbilityViewModel(text: "Ability long", enabled: false)
        GovernorAbilityView(viewModel: viewModelDisabled)
    }
}
#endif
