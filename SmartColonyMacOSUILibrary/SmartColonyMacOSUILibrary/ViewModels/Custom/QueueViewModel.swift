//
//  QueueViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 20.05.21.
//

import SmartAILibrary

class QueueViewModel {

    let uuid: String
    let queueType: BuildableItemType

    init(queueType: BuildableItemType) {

        self.uuid = UUID().uuidString
        self.queueType = queueType
    }
}

extension QueueViewModel: Hashable {

    static func == (lhs: QueueViewModel, rhs: QueueViewModel) -> Bool {

        return lhs.queueType == rhs.queueType && lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.uuid)
        hasher.combine(self.queueType)
    }
}
