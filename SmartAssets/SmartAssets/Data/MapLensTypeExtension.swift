//
//  MapLensTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 07.12.21.
//

import SmartAILibrary

public struct LegendItem {

    public let color: TypeColor
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

    public func legendItems(in gameModel: GameModel?) -> [LegendItem] {

        var legendItems: [LegendItem] = []

        switch self {

        case .religion:
            guard let gameModel = gameModel else {
                break
            }

            for religion in gameModel.religionsInUse() {
                legendItems.append(
                    LegendItem(
                        color: religion.legendColor(),
                        title: religion.name()
                    )
                )
            }

        case .continents:
            guard let gameModel = gameModel else {
                break
            }

            for continent in gameModel.continents().map( { $0.type() } ) {
                legendItems.append(
                    LegendItem(
                        color: continent.legendColor(),
                        title: continent.legendText()
                    )
                )
            }

        case .appeal:
            for appealLevel in AppealLevel.all {
                legendItems.append(
                    LegendItem(
                        color: appealLevel.legendColor(),
                        title: appealLevel.legendText()
                    )
                )
            }

        case .settler:
            for citySiteEvaluationType in CitySiteEvaluationType.all {
                legendItems.append(
                    LegendItem(
                        color: citySiteEvaluationType.legendColor(),
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
