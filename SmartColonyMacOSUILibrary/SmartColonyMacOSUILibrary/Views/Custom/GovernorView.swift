//
//  GovernorView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.09.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class GovernorAbilityViewModel: ObservableObject {

    let id: UUID = UUID()

    @Published
    var text: String

    init(text: String) {

        self.text = text
    }
}

extension GovernorAbilityViewModel: Hashable {

    static func == (lhs: GovernorAbilityViewModel, rhs: GovernorAbilityViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}

struct GovernorAbilityView: View {

    let viewModel: GovernorAbilityViewModel

    init(viewModel: GovernorAbilityViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(spacing: 4) {

            Image(nsImage: ImageCache.shared.image(for: "promotion-default"))
                .resizable()
                .frame(width: 10, height: 10, alignment: .leading)

            Text(self.viewModel.text)
                .font(.system(size: 6))
                .frame(width: 70, height: 10, alignment: .leading)
        }
    }
}

struct GovernorView: View {

    @ObservedObject
    var viewModel: GovernorViewModel

    private let cornerRadius: CGFloat = 5
    private let cardWidth: CGFloat = 100
    private let cardHeight: CGFloat = 300

    public init(viewModel: GovernorViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        ZStack {

            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(Color(Globals.Colors.dialogBorder), lineWidth: 1)
                .frame(width: self.cardWidth, height: self.cardHeight)
                .background(Color(Globals.Colors.dialogBackground))

            VStack(alignment: .center, spacing: 4) {

                Image(nsImage: self.viewModel.image())
                    .resizable()
                    .frame(width: 70, height: 70, alignment: .center)
                    .background(Color.gray)
                    .padding(.top, 8)

                Text(self.viewModel.name)

                Text(self.viewModel.title)
                    .font(.system(size: 6))

                Divider()
                    .background(Color(Globals.Colors.dialogBorder))
                    .padding(.horizontal, 6)

                Text("Abilities")
                    .font(.system(size: 6))

                LazyVStack(spacing: 4) {

                    ForEach(self.viewModel.governorAbilityViewModels, id: \.self) { governorAbilityViewModel in

                        GovernorAbilityView(viewModel: governorAbilityViewModel)
                    }
                }

                Spacer()

                self.buttonView
            }
            .frame(width: self.cardWidth, height: self.cardHeight - 8, alignment: .center)
            .padding(.bottom, 8)
        }
        .frame(width: self.cardWidth, height: self.cardHeight, alignment: .center)
        .cornerRadius(cornerRadius)
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

                    if self.viewModel.assigned {
                        Button("Reassign",
                               action: {
                                self.viewModel.clickedReassign()
                               }
                        )
                        .buttonStyle(DialogButtonStyle(state: .highlighted))
                    } else {
                        Button("Assign",
                               action: {
                                self.viewModel.clickedAssign()
                               }
                        )
                        .buttonStyle(DialogButtonStyle(state: .highlighted))
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

        let governorReyna = Governor(type: .reyna)
        let viewModelReyna = GovernorViewModel(governor: governorReyna, appointed: true, assigned: true)

        GovernorView(viewModel: viewModelReyna)

        let governorAmani = Governor(type: .amani)
        let viewModelAmani = GovernorViewModel(governor: governorAmani, appointed: false, assigned: false)

        GovernorView(viewModel: viewModelAmani)
    }
}
#endif
