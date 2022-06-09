//
//  AchievementViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.08.21.
//

import SwiftUI
import Cocoa
import SmartAssets

enum AchievementMode {

    case small
    case medium

    func size() -> CGFloat {

        switch self {

        case .small: return 16
        case .medium: return 32
        }
    }
}

class AchievementViewModel: ObservableObject, Identifiable {

    // private
    let id: UUID = UUID()
    let imageName: String
    let toolTip: NSAttributedString

    @Published
    var image: NSImage

    @Published
    var mode: AchievementMode

    init(imageName: String, mode: AchievementMode = .small, toolTipText: NSAttributedString) {

        self.imageName = imageName
        self.toolTip = toolTipText
        self.mode = mode

        self.image = ImageCache.shared.image(for: imageName).copy() as! NSImage
    }
}

extension AchievementViewModel: Hashable {

    static func == (lhs: AchievementViewModel, rhs: AchievementViewModel) -> Bool {

        return lhs.id == rhs.id && lhs.imageName == rhs.imageName
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
        hasher.combine(self.imageName)
    }
}
