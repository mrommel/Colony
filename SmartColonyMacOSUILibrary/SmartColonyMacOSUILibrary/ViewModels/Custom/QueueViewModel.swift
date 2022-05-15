//
//  QueueViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 20.05.21.
//

import SmartAILibrary

class QueueViewModel: NSObject, ObservableObject {

    var uuid: String
    let queueType: BuildableItemType

    init(queueType: BuildableItemType) {

        self.uuid = UUID().uuidString
        self.queueType = queueType
    }
}

extension QueueViewModel {

    static func == (lhs: QueueViewModel, rhs: QueueViewModel) -> Bool {

        return lhs.queueType == rhs.queueType && lhs.uuid == rhs.uuid
    }

    override var hash: Int {

        return self.uuid.hashValue ^ self.queueType.hashValue
    }
}
