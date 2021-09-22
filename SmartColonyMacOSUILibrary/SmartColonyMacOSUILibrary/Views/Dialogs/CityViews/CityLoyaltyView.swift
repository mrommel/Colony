//
//  CityLoyaltyView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.09.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CityLoyaltyView: View {

    @ObservedObject
    var viewModel: CityLoyaltyViewModel

    public init(viewModel: CityLoyaltyViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Text("Loyalty")
    }
}
