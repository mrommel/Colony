//
//  EnvoyEffectView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 05.03.22.
//

import SwiftUI
import SmartAssets

struct EnvoyEffectView: View {

    @ObservedObject
    var viewModel: EnvoyEffectViewModel

    public init(viewModel: EnvoyEffectViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(alignment: .top, spacing: 2) {

            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 42, height: 42)
                .padding(.leading, 8)

            VStack(spacing: 2) {
                Text(self.viewModel.title)
                    .foregroundColor(Color(self.viewModel.titleColor))
                    .frame(width: 270, height: 24, alignment: .leading)

                Label(self.viewModel.name)
                    .frame(width: 270, alignment: .leading)
                    .frame(width: 270, height: nil, alignment: .leading)
            }
        }
        .frame(width: 330)
        .padding(.all, 4)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-row"))
                .resizable(capInsets: EdgeInsets(all: 15))
        )
    }
}

#if DEBUG
import SmartAILibrary

struct EnvoyEffectView_Previews: PreviewProvider {

    private static func viewModel(
        cityState: CityStateType,
        level: EnvoyEffectLevel) -> EnvoyEffectViewModel {

        let viewModel = EnvoyEffectViewModel(
            envoyEffect: EnvoyEffect(
                cityState: cityState,
                level: level
            )
        )

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel0 = EnvoyEffectView_Previews.viewModel(cityState: .amsterdam, level: .first)
        EnvoyEffectView(viewModel: viewModel0)

        let viewModel1 = EnvoyEffectView_Previews.viewModel(cityState: .amsterdam, level: .suzerain)
        EnvoyEffectView(viewModel: viewModel1)
    }
}
#endif
