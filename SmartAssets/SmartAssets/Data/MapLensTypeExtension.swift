//
//  MapLensTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 07.12.21.
//

import SmartAILibrary

public struct LegendItem {

    public let textureName: String
    public let title: String
}

extension MapLensType {

    public func title() -> String {

        switch self {

        case .none: return "None"

        case .religion: return "Religion"
        case .continents: return "Continents"
        case .appeal: return "Appeal"
        case .settler: return "Settler"
        case .government: return "Government"
        case .political: return "Political"
        case .tourism: return "Tourism"
        case .empire: return "Empire"
        }
    }

    public func legendItems() -> [LegendItem] {

        var legendItems: [LegendItem] = []

        switch self {

        case .appeal:
            for appealLevel in AppealLevel.all {
                legendItems.append(
                    LegendItem(
                        textureName: appealLevel.textureName(),
                        title: appealLevel.legendText()
                    )
                )
            }

        case .settler:
            for citySiteEvaluationType in CitySiteEvaluationType.all {
                legendItems.append(
                    LegendItem(
                        textureName: citySiteEvaluationType.textureName(),
                        title: citySiteEvaluationType.legendText()
                    )
                )
            }

        default:
            // NOOP
            break
        }

        return legendItems
    }
}
