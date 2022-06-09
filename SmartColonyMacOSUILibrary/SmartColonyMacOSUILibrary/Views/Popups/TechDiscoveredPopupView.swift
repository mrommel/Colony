//
//  TechDiscoveredPopupView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct TechDiscoveredPopupView: View {

    @ObservedObject
    var viewModel: TechDiscoveredPopupViewModel

    public init(viewModel: TechDiscoveredPopupViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 0) {

                Text(self.viewModel.title)
                    .font(.title2)
                    .bold()
                    .padding(.top, 12)
                    .padding(.bottom, 10)

                VStack(alignment: .center, spacing: 6) {

                    Image(nsImage: self.viewModel.icon())
                        .resizable()
                        .frame(width: 48, height: 48, alignment: .topLeading)
                        .padding(.top, 6)

                    Text(self.viewModel.nameText)
                        .font(.headline)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 10)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)

                    Text("TXT_KEY_TECHS_DISCOVERED_UNLOCKED".localized())
                        .font(.caption)
                        .padding(.bottom, 0)

                    LazyHStack(spacing: 2) {

                        ForEach(self.viewModel.achievementViewModels, id: \.self) { achievementViewModel in

                            AchievementView(viewModel: achievementViewModel)
                                .id("tech-\(achievementViewModel.id)")
                                .frame(width: 32, height: 32)
                                .zIndex(51)
                        }
                    }
                    .padding(.top, 0)
                    .padding(.trailing, 0)
                    .padding(.leading, 0)

                    GroupBox {

                        Text(self.viewModel.quoteText)
                            .font(.caption)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.all, 4)
                    }

                    Spacer()

                    Button(action: {
                        self.viewModel.closePopup()
                    }, label: {
                        Text("TXT_KEY_CLOSE".localized())
                    })
                    .padding(.bottom, 8)
                }
                .frame(width: 362, height: 284, alignment: .center)
                .background(Color(Globals.Colors.dialogBackground))
            }
            .padding(.bottom, 43)
            .padding(.leading, 19)
            .padding(.trailing, 19)

        }
        .frame(width: 400, height: 370, alignment: .top)
        .dialogBackground()
    }
}

#if DEBUG
struct TechDiscoveredPopupView_Previews: PreviewProvider {

    static func viewModel() -> TechDiscoveredPopupViewModel {

        let viewModel = TechDiscoveredPopupViewModel()
        viewModel.update(for: .sailing)

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = TechDiscoveredPopupView_Previews.viewModel()
        TechDiscoveredPopupView(viewModel: viewModel)
    }
}
#endif
