//
//  MomentViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.01.22.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class MomentViewModel: ObservableObject {

    public let id: UUID = UUID()

    @Published
    var summaryText: String

    @Published
    var tooltipText: String

    @Published
    var yearText: String

    @Published
    var turnText: String

    @Published
    var scoreText: String

    private let momentType: MomentType

    init(moment: Moment) {

        self.summaryText = ""
        self.tooltipText = moment.type.summary().localized()
        self.yearText = GameModel.yearText(for: moment.turn)
        self.turnText = "Turn \(moment.turn)"
        self.scoreText = "+\(moment.type.eraScore()) Era Score"

        self.momentType = moment.type

        self.summaryText = self.generateSummaryText()
    }

    private func generateSummaryText() -> String {

        let translatedFormatText = self.momentType.instanceText().localized()

        switch self.momentType {

        case .causeForWar(warType: let warType, civilizationType: let civilizationType):
            return String(format: translatedFormatText, warType.name().localized(), civilizationType.name().localized())

        case .cityOnNewContinent(cityName: let cityName, continentName: let continentName):
            return String(format: translatedFormatText, cityName, continentName)

        case .cityReturnsToOriginalOwner(cityName: let cityName, originalCivilization: let civilizationType):
            return String(format: translatedFormatText, cityName, civilizationType.name().localized())

        case .desertCity(cityName: let cityName):
            return String(format: translatedFormatText, cityName)

        case .firstBustlingCity(cityName: let cityName):
            return String(format: translatedFormatText, cityName)

        case .firstEnormousCity(cityName: let cityName):
            return String(format: translatedFormatText, cityName)

        case .firstGiganticCity(cityName: let cityName):
            return String(format: translatedFormatText, cityName)

        case .firstLargeCity(cityName: let cityName):
            return String(format: translatedFormatText, cityName)

        case .snowCity(cityName: let cityName):
            return String(format: translatedFormatText, cityName)

        case .tradingPostEstablishedInNewCivilization(civilization: let civilization):
            return String(format: translatedFormatText, civilization.name().localized())

        case .tundraCity(cityName: let cityName):
            return String(format: translatedFormatText, cityName)

        case .worldsFirstBustlingCity(cityName: let cityName):
            return String(format: translatedFormatText, cityName)

        case .worldsFirstEnormousCity(cityName: let cityName):
            return String(format: translatedFormatText, cityName)

        case .worldsFirstGiganticCity(cityName: let cityName):
            return String(format: translatedFormatText, cityName)

        case .worldsFirstLargeCity(cityName: let cityName):
            return String(format: translatedFormatText, cityName)

        default:
            return translatedFormatText
        }

    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.momentType.iconTexture())
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
