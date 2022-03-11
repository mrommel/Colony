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

        case .overview:
            return AnyView(self.intelReportOverviewView)
        case .gossip:
            return AnyView(self.intelReportGossipView)
        case .accessLevel:
            return AnyView(self.intelReportAccessLevelView)
        case .ourRelationship:
            return AnyView(self.intelReportOurRelationshipView)

        default:
            fatalError("wrong intel report type")
        }
    }

    private var intelReportOverviewView: some View {

        VStack(spacing: 10) {

            // gossip
            HStack {
                Image(nsImage: ImageCache.shared.image(for: IntelReportType.gossip.iconTexture()))
                    .resizable()
                    .frame(width: 20, height: 20)

                Text(IntelReportType.gossip.title().localized())
                    .font(.body)
                    .frame(width: 150, alignment: .leading)

                Text("- No New Items")
                    .font(.body)
                    .frame(width: 150, alignment: .leading)
            }

            // access level
            HStack {
                Image(nsImage: ImageCache.shared.image(for: IntelReportType.accessLevel.iconTexture()))
                    .resizable()
                    .frame(width: 20, height: 20)

                Text(IntelReportType.accessLevel.title().localized())
                    .font(.body)
                    .frame(width: 150, alignment: .leading)

                Text("  None")
                    .font(.body)
                    .frame(width: 150, alignment: .leading)
            }

            // government
            HStack {
                Image(nsImage: ImageCache.shared.image(for: IntelReportType.government.iconTexture()))
                    .resizable()
                    .frame(width: 20, height: 20)

                Text("Government")
                    .font(.body)
                    .frame(width: 150, alignment: .leading)

                Text("- Chiefdom")
                    .font(.body)
                    .frame(width: 150, alignment: .leading)
            }
        }
    }

    private var intelReportGossipView: some View {

        VStack(spacing: 10) {

            Text("Gossip")
        }
    }

    private var intelReportAccessLevelView: some View {

        VStack(spacing: 10) {

            Text("AccessLevel")
        }
    }

    private var intelReportOurRelationshipView: some View {

        VStack(spacing: 10) {

            Text("Relationship")
        }
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
