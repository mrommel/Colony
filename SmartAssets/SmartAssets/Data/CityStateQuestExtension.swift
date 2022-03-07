//
//  CityStateQuestExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 07.03.22.
//

import SmartAILibrary

extension CityStateQuest {

    public func summary() -> String {

        switch self.type {

        case .none:
            return "-"
        case .trainUnit(type: let type):
            return "TXT_KEY_CITY_STATE_QUEST_TRAIN_UNIT".localizedWithFormat(with: [type.name().localized()])
        case .constructDistrict(type: let type):
            return "TXT_KEY_CITY_STATE_QUEST_CONSTRUCT_DISTRICT".localizedWithFormat(with: [type.name().localized()])
        case .triggerEureka(tech: let tech):
            return "TXT_KEY_CITY_STATE_QUEST_TRIGGER_EUREKA".localizedWithFormat(with: [tech.name().localized()])
        case .triggerInspiration(civic: let civic):
            return "TXT_KEY_CITY_STATE_QUEST_TRIGGER_INSPIRATION".localizedWithFormat(with: [civic.name().localized()])
        case .recruitGreatPerson(greatPerson: let greatPerson):
            return "TXT_KEY_CITY_STATE_QUEST_RECRUIT_GREAT_PERSON".localizedWithFormat(with: [greatPerson.name().localized()])
        case .convertToReligion(religion: _):
            return "TXT_KEY_CITY_STATE_QUEST_CONVERT_RELIGION".localized()
        case .sendTradeRoute:
            return "TXT_KEY_CITY_STATE_QUEST_SEND_TRADE_ROUTE".localized()
        case .destroyBarbarianOutput(location: _):
            return "TXT_KEY_CITY_STATE_QUEST_DESTROY_OUTPOST".localized()
        }
    }
}
