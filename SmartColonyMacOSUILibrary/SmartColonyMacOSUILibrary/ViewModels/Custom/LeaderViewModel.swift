//
//  LeaderViewModel.swift
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
