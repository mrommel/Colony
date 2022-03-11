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
                Text("Diplomatic")
                    .font(.title2)
                    .bold()
                    .padding()

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

                self.detailView
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 700, height: 550, alignment: .top)
        .dialogBackground()
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
                ForEach(IntelReportType.all) { intelReportType in

                    Image(nsImage: ImageCache.shared.image(for: intelReportType.iconTexture()))
                        .resizable()
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            self.viewModel.select(report: intelReportType)
                        }
                }
            }

            self.intelReportView
            // different view
            // deals proposed
        }
    }

    private var intelReportView: some View {

        VStack(spacing: 10) {

            Text(self.viewModel.intelReportType.title())
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
