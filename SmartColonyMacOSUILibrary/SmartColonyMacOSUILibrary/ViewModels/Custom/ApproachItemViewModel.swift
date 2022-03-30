//
//  ApproachItemViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 20.03.22.
//

import Foundation

public class ApproachItemViewModel: ObservableObject, Identifiable {

    public let id: UUID = UUID()

    @Published
    var value: Int

    @Published
    var valueText: String

    @Published
    var text: String

    public init(value: Int, text: String) {

        self.value = value
        self.valueText = value > 0 ? "+\(value)" : "\(value)"
        self.text = text
    }
}

extension ApproachItemViewModel: Hashable {

    public static func == (lhs: ApproachItemViewModel, rhs: ApproachItemViewModel) -> Bool {

        return lhs.value == rhs.value && lhs.text == rhs.text
    }

    public func hash(into hasher: inout Hasher) {

        hasher.combine(self.value)
        hasher.combine(self.text)
    }
}
