//
//  LeaderView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol LeaderViewModelDelegate: AnyObject {

    func clicked(on leaderType: LeaderType)
}

class LeaderViewModel: ObservableObject {

    let id: UUID = UUID()

    let leaderType: LeaderType

    weak var delegate: LeaderViewModelDelegate?

    init(leaderType: LeaderType) {

        self.leaderType = leaderType
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.leaderType.iconTexture())
    }

    func clicked() {

        self.delegate?.clicked(on: self.leaderType)
    }
}

extension LeaderViewModel: Hashable {

    static func == (lhs: LeaderViewModel, rhs: LeaderViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}

struct LeaderView: View {

    @ObservedObject
    var viewModel: LeaderViewModel

    var body: some View {

        HStack(alignment: .top, spacing: 4) {

            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 32, height: 32, alignment: .topLeading)
                .onTapGesture {
                    self.viewModel.clicked()
                }
        }
    }
}

#if DEBUG
struct LeaderView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        LeaderView(viewModel: LeaderViewModel(leaderType: .cyrus))

        LeaderView(viewModel: LeaderViewModel(leaderType: .cleopatra))
    }
}
#endif
