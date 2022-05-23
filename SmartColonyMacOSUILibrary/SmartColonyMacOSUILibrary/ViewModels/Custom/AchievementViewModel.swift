//
//  AchievementViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.08.21.
//

import SwiftUI
import Cocoa
import SmartAssets

class AchievementViewModel: ObservableObject, Identifiable {

    // private
    let id: UUID = UUID()
    let imageName: String
    let toolTip: NSAttributedString

    @Published
    var image: NSImage

    init(imageName: String, toolTipText: NSAttributedString) {

        self.imageName = imageName
        self.toolTip = toolTipText

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
