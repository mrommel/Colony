//
//  PolicyCardView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 10.05.21.
//

import SwiftUI
import SmartAssets

struct PolicyCardView: View {

    @ObservedObject
    var viewModel: PolicyCardViewModel

    var body: some View {

        ZStack(alignment: .topLeading) {
            VStack {
                Text(self.viewModel.title())
                    .font(.headline)

                Label(text: self.viewModel.summary())
                    .font(.footnote)
                    .frame(width: 80)
                    .padding(.top, 1)
                    .background(Color.black.opacity(0.3))
            }
            .padding(.top, 10)
            .padding(.leading, 33)
            .padding(.trailing, 33)

            Toggle(isOn: self.$viewModel.selected) {
                Text("")
            }
            .disabled(self.viewModel.state == .disabled)
            .padding(.top, 2)
            .padding(.leading, 5)
        }
        .frame(width: 150, height: 150, alignment: .topLeading)
        .background(
            Image(nsImage: self.viewModel.background())
                .resizable()
        )
        .onTapGesture {
            self.viewModel.selected.toggle()
        }
    }
}

#if DEBUG
struct PolicyCardView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let agogeViewModel = PolicyCardViewModel(policyCardType: .agoge, state: .selected)
        PolicyCardView(viewModel: agogeViewModel)

        let chivalryViewModel = PolicyCardViewModel(policyCardType: .chivalry, state: .active)

        PolicyCardView(viewModel: chivalryViewModel)
    }
}
#endif
