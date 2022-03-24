//
//  DiplomaticDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.08.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct GossipView: View {

    let gossip: String

    public var body: some View {

        Text(self.gossip)
            .frame(width: 330)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                Image(nsImage: ImageCache.shared.image(for: "gossip-background"))
                    .resizable(capInsets: EdgeInsets(all: 32))
            )
    }
}

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

            ScrollView(.vertical, showsIndicators: true) {

                self.intelReportView

                Spacer()
            }
            .frame(width: 380, height: 200)
            .border(Color.white)

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
                    Text("TXT_KEY_DIPLOMACY_ACTION_DECLARE_FRIENDSHIP_TITLE".localized())
                })
                    .buttonStyle(GameButtonStyle())
            }

            if self.viewModel.canSendDelegation {
                Button(action: {
                    self.viewModel.sendDelegationClicked()
                }, label: {
                    VStack(spacing: 2) {
                        Text("TXT_KEY_DIPLOMACY_ACTION_DELEGATION_TITLE".localized())

                        Label("TXT_KEY_DIPLOMACY_ACTION_DELEGATION_SUMMARY".localized())
                            .font(.footnote)
                    }
                })
                    .buttonStyle(GameButtonStyle())
            }

            if self.viewModel.canDenounce {
                Button(action: {
                    self.viewModel.denounceClicked()
                }, label: {
                    Text("TXT_KEY_DIPLOMACY_ACTION_DENOUNCE_TITLE".localized())
                })
                    .buttonStyle(GameButtonStyle())
            }

            if self.viewModel.canDeclareWar {
                Button(action: {
                    self.viewModel.declareSurpriseWarClicked()
                }, label: {
                    VStack(spacing: 2) {
                        Text("TXT_KEY_DIPLOMACY_ACTION_DECLARE_WAR_TITLE".localized())

                        Label("TXT_KEY_DIPLOMACY_ACTION_DECLARE_WAR_SUMMARY".localized())
                            .font(.footnote)
                    }
                })
                    .buttonStyle(GameButtonStyle())
            }

            if self.viewModel.canMakeDeal {
                Button(action: {
                    self.viewModel.makeDealClicked()
                }, label: {
                    Text("TXT_KEY_DIPLOMACY_ACTION_MAKE_DEAL_TITLE".localized())
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

            Text("TXT_KEY_DIPLOMACY_GOSSIP_TITLE".localized())
                .font(.headline)
                .frame(width: 300, alignment: .trailing)

            DividerWithLabel("TXT_KEY_DIPLOMACY_GOSSIP_LAST_TURNS".localized())
                .padding(.bottom, 4)

            LazyVStack(spacing: 4) {
                ForEach(self.viewModel.lastGossipItems, id: \.self) { lastGossipText in

                    GossipView(gossip: lastGossipText)
                }
            }

            DividerWithLabel("TXT_KEY_DIPLOMACY_GOSSIP_OLDER".localized())
                .padding(.bottom, 4)

            LazyVStack(spacing: 4) {
                ForEach(self.viewModel.olderGossipItems, id: \.self) { olderGossipText in

                    GossipView(gossip: olderGossipText)
                }
            }
        }
        .frame(width: 360)
    }

    private var intelReportAccessLevelView: some View {

        VStack(spacing: 10) {

            Text("TXT_KEY_DIPLOMACY_ACCESS_LEVEL_TITLE".localized())
                .font(.headline)
                .frame(width: 300, alignment: .trailing)

            HStack {
                Image(nsImage: self.viewModel.accessLevelImage())
                    .resizable()
                    .frame(width: 24, height: 24)

                Text(self.viewModel.accessLevelLabel)
            }
                .frame(width: 300, alignment: .trailing)

            DividerWithLabel("TXT_KEY_DIPLOMACY_ACCESS_LEVEL_SHARED".localized())

            LazyVStack(spacing: 4) {
                ForEach(self.viewModel.sharedInformationTexts, id: \.self) { sharedInformationText in
                    Text(sharedInformationText)
                }
            }

            DividerWithLabel("TXT_KEY_DIPLOMACY_ACCESS_LEVEL_RAISE".localized())

            LazyVStack(spacing: 4) {
                ForEach(self.viewModel.raiseAccessLevelTexts, id: \.self) { raiseAccessLevelText in
                    Text(raiseAccessLevelText)
                }
            }
        }
        .frame(width: 360)
    }

    private var intelReportOurRelationshipView: some View {

        VStack(spacing: 10) {

            SegmentedProgressView(value: self.viewModel.relationShipRating, maximum: 100)
            //Slider(value: self.$viewModel.relationShipRating, in: 0...100)
                // .disabled(true)
                .accentColor(Color.green)
                .foregroundColor(Color.green)
                .frame(width: 300, alignment: .center)

            Text("TXT_KEY_DIPLOMACY_RELATIONSHIP_TITLE".localized())
                .font(.headline)
                .frame(width: 300, alignment: .trailing)

            HStack {
                Image(nsImage: self.viewModel.relationShipImage())
                    .resizable()
                    .frame(width: 24, height: 24)

                Text(self.viewModel.relationShipLabel)
            }
                .frame(width: 300, alignment: .trailing)

            Text("TXT_KEY_DIPLOMACY_RELATIONSHIP_REASONS".localized())
                .font(.headline)

            LazyVStack(spacing: 4) {
                ForEach(self.viewModel.approachItemViewModels) { approachItemViewModel in
                    ApproachItemView(viewModel: approachItemViewModel)
                }

                /*
                // https://forums.civfanatics.com/resources/diplomatic-total.25707/
                Text("-10 Favorable trades to them")*/
            }

            Text("TXT_KEY_DIPLOMACY_RELATIONSHIP_RAISE".localized())
        }
        .frame(width: 360)
    }
}

#if DEBUG
struct DiplomaticDialogView_Previews: PreviewProvider {

    private static func viewModel() -> DiplomaticDialogViewModel {

        let game = DemoGameModel()
        let playerOne = Player(leader: .barbarossa, isHuman: true)
        let playerTwo = Player(leader: .cyrus, isHuman: false)

        let viewModel = DiplomaticDialogViewModel()
        viewModel.gameEnvironment.game.value = game
        viewModel.update(for: playerOne, and: playerTwo, state: .intro, message: .messageIntro, emotion: .neutral)

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = DiplomaticDialogView_Previews.viewModel()

        DiplomaticDialogView(viewModel: viewModel)
    }
}
#endif
