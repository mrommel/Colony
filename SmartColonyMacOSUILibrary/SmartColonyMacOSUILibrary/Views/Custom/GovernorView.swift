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

        ZStack {

            RoundedRectangle(cornerRadius: self.cornerRadius)
                .strokeBorder(Color(Globals.Colors.dialogBorder), lineWidth: 1)
                .frame(width: self.cardWidth, height: self.cardHeight)
                .background(Color(self.viewModel.appointed ? Globals.Colors.dialogBackground : .black))

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

                Text("Abilities")
                    .font(.system(size: 8))

                LazyVStack(spacing: 1) {

                    ForEach(self.viewModel.governorAbilityViewModels, id: \.self) { governorAbilityViewModel in

                        GovernorAbilityView(viewModel: governorAbilityViewModel)
                    }
                }

                Spacer()
                    .frame(minHeight: 0, maxHeight: 50)

                self.assignmentView

                self.buttonView
            }
            .frame(width: self.cardWidth, height: self.cardHeight - 8, alignment: .center)
            .padding(.bottom, 8)
        }
        .frame(width: self.cardWidth, height: self.cardHeight, alignment: .center)
        .cornerRadius(self.cornerRadius)
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
                            Text("Established in:")
                                .font(.system(size: 7))

                            Text(self.viewModel.assignedCity)
                                .font(.system(size: 7))
                        }
                    } else {
                        Text("Needs Assignment")
                            .font(.system(size: 7))
                    }
                } else {
                    Text("Candidate")
                        .font(.system(size: 7))
                }
            }
        )
    }

    private var buttonView: AnyView {

        AnyView(
            Group {
                if self.viewModel.appointed {
                    Button("Promote",
                           action: {
                            self.viewModel.clickedPromote()
                           }
                    )
                    .buttonStyle(DialogButtonStyle())
                    .disabled(self.viewModel.hasTitles == false)

                    if self.viewModel.assigned {
                        Button("Reassign",
                               action: {
                                self.viewModel.clickedReassign()
                               }
                        )
                        .buttonStyle(DialogButtonStyle(state: .highlighted))
                        .disabled(self.viewModel.hasTitles == false)
                    } else {
                        Button("Assign",
                               action: {
                                self.viewModel.clickedAssign()
                               }
                        )
                        .buttonStyle(DialogButtonStyle(state: .highlighted))
                        .disabled(self.viewModel.hasTitles == false)
                    }
                } else {
                    Button("View promotions",
                           action: {
                            self.viewModel.clickedViewPromotions()
                           }
                    )
                    .buttonStyle(DialogButtonStyle())

                    Button("Appoint",
                           action: {
                            self.viewModel.clickedAppoint()
                           }
                    )
                    .buttonStyle(DialogButtonStyle(state: .highlighted))
                    .disabled(self.viewModel.hasTitles == false)
                }
            }
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
