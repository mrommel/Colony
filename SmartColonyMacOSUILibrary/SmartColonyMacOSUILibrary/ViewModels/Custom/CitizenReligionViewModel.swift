//
//  CitizenReligionViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.05.21.
//

import SwiftUI
import SmartAILibrary

class CitizenReligionViewModel: ObservableObject {

    @Published
    var religionCitizenNumber: Int

    @Published
    var religionCitizenName: String

    init(religionType: ReligionType, amount: Int) {

        self.religionCitizenNumber = amount
        self.religionCitizenName = "\(religionType) Citizens"
    }
}

extension CitizenReligionViewModel: Hashable {

    static func == (lhs: CitizenReligionViewModel, rhs: CitizenReligionViewModel) -> Bool {

        return lhs.religionCitizenName == rhs.religionCitizenName
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.religionCitizenNumber)
        hasher.combine(self.religionCitizenName)
    }
}
