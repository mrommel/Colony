//
//  GovernorView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.09.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct GovernorView: View {

    @ObservedObject
    var viewModel: GovernorViewModel

    private let cornerRadius: CGFloat = 5
    private let cardWidth: CGFloat = 100
    private let cardHeight: CGFloat = 300
    private let imageSize: CGFloat = 70

    public init(viewModel: GovernorViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack {

            VStack(alignment: .center, spacing: 4) {

                ZStack {
                    Image(nsImage: self.viewModel.image())
                        .resizable()
                        .frame(width: self.imageSize, height: self.imageSize, alignment: .center)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                        .border(Color.black)

                    self.imageInfoView
                }
                .frame(width: self.imageSize, height: self.imageSize, alignment: .center)
                .padding(.top, 8)

                Text(self.viewModel.name)

                Text(self.viewModel.title)
                    .font(.system(size: 7))

                Divider()
                    .background(Color(Globals.Colors.dialogBorder))
                    .padding(.horizontal, 6)

                Text("TXT_KEY_GOVERNOR_ABILITIES".localized())
                    .font(.system(size: 8))

                VStack(spacing: 1) {

                    ForEach(Array(self.viewModel.governorAbilityViewModels.enumerated()), id: \.element) { index, governorAbilityViewModel in

                        GovernorAbilityView(viewModel: governorAbilityViewModel)
                            .zIndex(400.0 - Double(index)) // needed for tooltip (from top to bottom smaller)
                    }
                }
                .zIndex(400)

                Spacer()
                    .frame(minHeight: 0, maxHeight: 50)

                self.assignmentView
                    .zIndex(0)

                self.buttonView
                    .zIndex(0)
            }
            .frame(width: self.cardWidth, height: self.cardHeight - 8, alignment: .center)
            .padding(.bottom, 8)
        }
        .frame(width: self.cardWidth, height: self.cardHeight, alignment: .center)
        // .cornerRadius(self.cornerRadius)
        .background(
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .strokeBorder(Color(Globals.Colors.dialogBorder), lineWidth: 1)
                .frame(width: self.cardWidth, height: self.cardHeight)
                .background(Color(self.viewModel.appointed ? Globals.Colors.dialogBackground : .black))
                .zIndex(0)
        )
        .zIndex(0)
    }

    private var imageInfoView: AnyView {

        AnyView(
            VStack {

                Spacer()

                HStack(alignment: .center, spacing: 2) {

                    Spacer()

                    Text("\(self.viewModel.loyalty)")
                        .font(.system(size: 9))

                    Image(nsImage: Globals.Icons.loyalty)
                        .resizable()
                        .frame(width: 8, height: 8, alignment: .center)

                    Spacer()

                    Text("\(self.viewModel.assignmentTime)")
                        .font(.system(size: 9))

                    Image(nsImage: Globals.Icons.turns)
                        .resizable()
                        .frame(width: 8, height: 8, alignment: .center)

                    Spacer()
                }
                .padding(.bottom, 2)
            }
        )
    }

    private var assignmentView: AnyView {

        AnyView(
            Group {
                if self.viewModel.appointed {
                    if self.viewModel.assigned {
                        VStack(alignment: .center, spacing: 0) {
                            Text("TXT_KEY_GOVERNOR_ESTABLISHED_IN".localized())
                                .font(.system(size: 7))
                                .zIndex(0)

                            Text(self.viewModel.assignedCity)
                                .font(.system(size: 7))
                                .zIndex(0)
                        }
                        .zIndex(0)
                    } else {
                        Text("TXT_KEY_GOVERNOR_NEEDS_ASSIGNMENT".localized())
                            .font(.system(size: 7))
                            .zIndex(0)
                    }
                } else {
                    Text("TXT_KEY_GOVERNOR_CANDIDATE".localized())
                        .font(.system(size: 7))
                        .zIndex(0)
                }
            }
                .zIndex(0)
        )
    }

    private var buttonView: AnyView {

        AnyView(
            Group {
                if self.viewModel.appointed {
                    Button("TXT_KEY_GOVERNOR_PROMOTE".localized(),
                           action: {
                            self.viewModel.clickedPromote()
                           }
                    )
                    .buttonStyle(DialogButtonStyle())
                    .disabled(self.viewModel.hasTitles == false)
                    .zIndex(0)

                    if self.viewModel.assigned {
                        Button(
                            "TXT_KEY_GOVERNOR_REASSIGN".localized(),
                            action: {
                                self.viewModel.clickedReassign()
                            }
                        )
                        .buttonStyle(DialogButtonStyle(state: .highlighted))
                        .zIndex(0)
                    } else {
                        Button(
                            "TXT_KEY_GOVERNOR_ASSIGN".localized(),
                            action: {
                                self.viewModel.clickedAssign()
                            }
                        )
                        .buttonStyle(DialogButtonStyle(state: .highlighted))
                        .zIndex(0)
                    }
                } else {
                    Button(
                        "TXT_KEY_GOVERNOR_VIEW_PROMOTIONS".localized(),
                        action: {
                            self.viewModel.clickedViewPromotions()
                           }
                    )
                    .buttonStyle(DialogButtonStyle())
                    .zIndex(0)

                    Button(
                        "TXT_KEY_GOVERNOR_APPOINT".localized(),
                        action: {
                            self.viewModel.clickedAppoint()
                        }
                    )
                    .buttonStyle(DialogButtonStyle(state: .highlighted))
                    .disabled(self.viewModel.hasTitles == false)
                    .zIndex(0)
                }
            }
                .zIndex(0)
        )
    }
}

#if DEBUG
struct GovernorsView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        HStack {

            let governorReyna = Governor(type: .reyna)
            let viewModelReyna = GovernorViewModel(governor: governorReyna, appointed: true, assigned: true, assignedCity: "Berlin", hasTitles: true)

            GovernorView(viewModel: viewModelReyna)

            let governorAmani = Governor(type: .amani)
            let viewModelAmani = GovernorViewModel(governor: governorAmani, appointed: false, assigned: false, assignedCity: "", hasTitles: false)

            GovernorView(viewModel: viewModelAmani)
        }
    }
}
#endif
