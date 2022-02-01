//
//  BannerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.01.22.
//

import SwiftUI

public class BannerViewModel: ObservableObject {

    @Published
    var bannerVisible: Bool

    @Published
    var bannerText: String

    init() {

        self.bannerVisible = false
        self.bannerText = "Other players are taking their turns, please wait ..."
    }

    func showBanner() {

        if !self.bannerVisible {
            self.bannerVisible = true
        }
    }

    func hideBanner() {

        if self.bannerVisible {
            self.bannerVisible = false
        }
    }
}
