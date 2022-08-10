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

        case .none: return "-"

        case .religion: return "TXT_KEY_LENS_RELIGION_TITLE"
        case .continents: return "TXT_KEY_LENS_CONTINENTS_TITLE"
        case .appeal: return "TXT_KEY_LENS_APPEAL_TITLE"
        case .settler: return "TXT_KEY_LENS_SETTLER_TITLE"
        case .government: return "TXT_KEY_LENS_GOVERNMENT_TITLE"
        case .tourism: return "TXT_KEY_LENS_TOURISM_TITLE"
        case .loyalty: return "TXT_KEY_LENS_LOYALTY_TITLE"
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

            let continentTypes = gameModel.continents()
                .map { $0.type() }
                .filter { $0 != .none }
            for continentType in continentTypes {
                legendItems.append(
                    LegendItem(
                        color: continentType.legendColor(),
                        title: continentType.legendText()
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

        case .government:
            guard let gameModel = gameModel else {
                break
            }

            let governmentTypes: [GovernmentType] = gameModel.players
                .map { $0.government?.currentGovernment() ?? .chiefdom }
                .uniqued()
            for governmentType in governmentTypes {
                legendItems.append(
                    LegendItem(
                        color: governmentType.legendColor(),
                        title: governmentType.legendText()
                    )
                )
            }

        case .tourism:
            // NOOP
            break

        case .loyalty:
            // NOOP
            break

        default:
            // NOOP
            break
        }

        return legendItems
    }
}
