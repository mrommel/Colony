//
//  GenericPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 08.02.22.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class GenericPopupViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var summary: String

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "-"
        self.summary = "-"
    }

    /// both texts must be already translated
    func update(with title: String, and summary: String) {

        self.title = title
        self.summary = summary
/*
 <Replace Language='en_US' Tag="LOC_NOTIFICATION_CITY_BECAME_FREE_CITY_MESSAGE">
     <Text>City Loyalty Lost</Text>
 </Replace>
 <Replace Language='en_US' Tag="LOC_NOTIFICATION_CITY_BECAME_FREE_CITY_SUMMARY">
     <Text>Because Loyalty dropped to 0, {1_CityName} has rebelled and become a Free City. To gain control of it again, you must once again exert your Loyalty there or use military force.</Text>
 </Replace>
 <Replace Language='en_US' Tag="LOC_NOTIFICATION_FOREIGN_CITY_BECAME_FREE_CITY_MESSAGE">
     <Text>Foreign City Gains Independence</Text>
 </Replace>
 <Replace Language='en_US' Tag="LOC_NOTIFICATION_FOREIGN_CITY_BECAME_FREE_CITY_SUMMARY">
     <Text>{1_CivName} no longer has enough Loyalty to keep the city of {2_CityName} in their empire. Nearby civilizations exerting Loyalty or using military force may soon gain control of this Free City.</Text>
 </Replace>
 */
    }

    func closePopup() {

        self.delegate?.closePopup()
    }
}
