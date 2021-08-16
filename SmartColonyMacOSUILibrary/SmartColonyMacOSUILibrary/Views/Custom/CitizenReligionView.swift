//
//  CitizenReligionView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.05.21.
//

import SwiftUI

struct CitizenReligionView: View {

    @ObservedObject
    var viewModel: CitizenReligionViewModel

    var body: some View {

        HStack(alignment: .center, spacing: 10) {
            Text("\(self.viewModel.religionCitizenNumber)")

            Text(self.viewModel.religionCitizenName)
                .padding(.all, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                )
        }
        .padding(.all, 8)
        .frame(width: 250, height: 70, alignment: .leading)
        .background(Color.red.opacity(0.4))
    }
}

#if DEBUG
struct CitizenReligionView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        CitizenReligionView(viewModel: CitizenReligionViewModel(religionType: .buddhism, amount: 2))

        CitizenReligionView(viewModel: CitizenReligionViewModel(religionType: .confucianism, amount: 1))
    }
}
#endif
