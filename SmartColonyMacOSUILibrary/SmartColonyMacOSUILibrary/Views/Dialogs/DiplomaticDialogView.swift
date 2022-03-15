//
//  DiplomaticDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

public struct DiplomaticDialogView: View {

    @ObservedObject
    var viewModel: DiplomaticDialogViewModel

    public init(viewModel: DiplomaticDialogViewModel) {

        self.viewModel = viewModel
    }

    public var body: some View {

        Group {
            VStack(spacing: 10) {
                Text("TXT_KEY_DIPLOMACY_DIALOG_TITLE".localized())
                    .font(.title2)
                    .bold()
                    .padding()

                self.headerView

                self.detailView
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 700, height: 550, alignment: .top)
        .dialogBackground()
    }

    private var headerView: some View {

        HStack(alignment: .top, spacing: 10) {

            Image(nsImage: self.viewModel.leaderImage())
                .resizable()
                .frame(width: 64, height: 64)
                .padding(.top, 8)
                .padding(.leading, 8)

            VStack(alignment: .leading, spacing: 10) {

                Text(self.viewModel.leaderName())
                    .font(.title2)

                Text(self.viewModel.civilizationName())

                Spacer()
            }
            .padding(.top, 8)
            .padding(.leading, 4)

            Spacer()
        }
        .frame(width: 300, height: 80)
        .border(Color.white)
    }

    private var detailView: some View {

        switch self.viewModel.state {

        case .intro:
            return AnyView(self.introView)

        default:
            return AnyView(self.blankDiscussionView)
        }
    }

    private var introView: some View {

        VStack(spacing: 10) {
            Text(self.viewModel.message)
                .font(.system(size: 12))
                .lineLimit(nil)

            Spacer()

            // replies
            LazyVStack(spacing: 4) {
                ForEach(self.viewModel.replyViewModels) { replyViewModel in

                    ReplyView(viewModel: replyViewModel)
                        .id("reply-\(replyViewModel.id)")
                }
            }
        }
    }

    private var blankDiscussionView: some View {

        VStack(spacing: 10) {
            Text(self.viewModel.discussionIntelReportTitle)

            LazyHStack(spacing: 4) {
                ForEach(IntelReportType.tabs) { intelReportType in

                    Image(nsImage: ImageCache.shared.image(for: intelReportType.buttonTexture()))
                        .resizable()
                        .hueRotation(Angle(degrees: intelReportType == self.viewModel.intelReportType ? 135 : 0))
                        .frame(width: 32, height: 32)
                        .onTapGesture {
                            self.viewModel.select(report: intelReportType)
                        }
                }
            }
            .frame(height: 32)

            self.intelReportView
                .border(Color.white)

            Spacer()

            Button(action: {
                self.viewModel.closeDialog()
            }, label: {
                Text("TXT_KEY_CLOSE".localized())
            })
            .buttonStyle(DialogButtonStyle())
        }
    }

    private var intelReportView: some View {

        switch self.viewModel.intelReportType {

        case .action:
            return AnyView(self.actionView)
        case .overview:
            return AnyView(self.intelReportOverviewView)
        case .gossip:
            return AnyView(self.intelReportGossipView)
        case .accessLevel:
            return AnyView(self.intelReportAccessLevelView)
        case .ownRelationship:
            return AnyView(self.intelReportOurRelationshipView)

        default:
            fatalError("wrong intel report type")
        }
    }

    private var actionView: some View {

        VStack(spacing: 10) {

            if self.viewModel.canDeclareFriendship {
                Button(action: {
                    self.viewModel.declareFriendshipClicked()
                }, label: {
                    Text("Declare Friendship")
                })
                    .buttonStyle(GameButtonStyle())
            }

            if self.viewModel.canSendDelegation {
                Button(action: {
                    self.viewModel.sendDelegationClicked()
                }, label: {
                    VStack(spacing: 2) {
                        Text("Send Delegation")

                        Label("Costs 25 [Gold] Gold")
                            .font(.footnote)
                    }
                })
                    .buttonStyle(GameButtonStyle())
            }

            if self.viewModel.canDenounce {
                Button(action: {
                    self.viewModel.denounceClicked()
                }, label: {
                    Text("Denounce")
                })
                    .buttonStyle(GameButtonStyle())
            }

            if self.viewModel.canDeclareWar {
                Button(action: {
                    self.viewModel.declareSurpriseWarClicked()
                }, label: {
                    VStack(spacing: 2) {
                        Text("Declare Surprise War")

                        Label("Warmonger penalty: heavy")
                            .font(.footnote)
                    }
                })
                    .buttonStyle(GameButtonStyle())
            }

            if self.viewModel.canMakeDeal {
                Button(action: {
                    self.viewModel.makeDealClicked()
                }, label: {
                    Text("Make Deal")
                })
                    .buttonStyle(GameButtonStyle())
            }
        }
        .frame(width: 360)
    }

    private var intelReportOverviewView: some View {

        VStack(spacing: 10) {

            LazyVStack(spacing: 4) {
                ForEach(IntelReportType.icons) { intelReportType in
                    HStack {
                        Image(nsImage: ImageCache.shared.image(for: intelReportType.iconTexture()))
                            .resizable()
                            .frame(width: 20, height: 20)

                        Text(intelReportType.title().localized())
                            .font(.body)
                            .frame(width: 150, alignment: .leading)

                        Label(self.viewModel.overview(for: intelReportType))
                            .frame(width: 150, alignment: .leading)
                            .frame(width: 150, height: nil, alignment: .leading)
                    }
                }
            }
        }
        .frame(width: 360)
    }

    private var intelReportGossipView: some View {

        VStack(spacing: 10) {

            Text("Gossip")
        }
        .frame(width: 360)
    }

    private var intelReportAccessLevelView: some View {

        VStack(spacing: 10) {

            Text("AccessLevel")
        }
        .frame(width: 360)
    }

    private var intelReportOurRelationshipView: some View {

        VStack(spacing: 10) {

            Slider(value: self.$viewModel.relationShipRating, in: 0...100)
                // .disabled(true)
                .accentColor(Color.green)
                .foregroundColor(Color.green)
                .frame(width: 300, alignment: .center)

            Text("Relationship")
                .font(.headline)
                .frame(width: 300, alignment: .trailing)

            HStack {
                Image(nsImage: self.viewModel.relationShipImage())
                    .resizable()
                    .frame(width: 24, height: 24)

                Text(self.viewModel.relationShipLabel)
            }
                .frame(width: 300, alignment: .trailing)

            Text("Reasons for current relationship")
                .font(.headline)

            LazyVStack(spacing: 4) {
                ForEach(self.viewModel.approachItemViewModels) { approachItemViewModel in
                    HStack {
                        Text(approachItemViewModel.valueText)
                            .foregroundColor(approachItemViewModel.value > 0 ? .green : .red)

                        Text(approachItemViewModel.text)
                    }
                }
            }

            /*
            // https://forums.civfanatics.com/resources/diplomatic-total.25707/
            Text("-5 First impression of you")
            Text("+3 We sent them a delegation")
            Text("-2 Moving forces near their cities")
            Text("-10 Favorable trades to them")*/

            Text("To raise your relationship you could:")
        }
        .frame(width: 360)
    }
}

#if DEBUG
struct DiplomaticDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let playerOne = Player(leader: .barbarossa, isHuman: true)
        let playerTwo = Player(leader: .cyrus, isHuman: false)

        let viewModel = DiplomaticDialogViewModel(for: playerOne, and: playerTwo, in: game)

        DiplomaticDialogView(viewModel: viewModel)
    }
}
#endif
