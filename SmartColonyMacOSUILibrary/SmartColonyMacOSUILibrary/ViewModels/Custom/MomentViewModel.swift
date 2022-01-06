//
//  MomentViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.01.22.
//

import SwiftUI
import SmartAILibrary

class MomentViewModel: ObservableObject {

    public let id: UUID = UUID()

    @Published
    var title: String

    @Published
    var summary: String

    init(moment: Moment) {

        self.title = moment.type.name()
        self.summary = moment.type.summary()
    }
}

extension MomentViewModel: Hashable {

    public static func == (lhs: MomentViewModel, rhs: MomentViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
