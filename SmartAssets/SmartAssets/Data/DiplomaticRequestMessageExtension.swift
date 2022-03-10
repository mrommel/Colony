//
//  DiplomaticRequestMessageExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 10.03.22.
//

import SmartAILibrary

extension DiplomaticRequestMessage {

    // try to get exact match for both leader, but have a fallback to generic matching (ANY_ANY)
    private func translation(key: String, sender: String, receiver: String = "ANY") -> String {

        guard key.hasSuffix("_") else {
            fatalError("wrong key structure - should end with underscore _")
        }

        var tmpKey = key + sender + "_" + receiver
        var result = tmpKey.localized()

        guard tmpKey == result else {
            return result
        }

        // no need to check this, when recevier is already ANY
        if receiver != "ANY" {
            tmpKey = key + sender + "_ANY"
            result = tmpKey.localized()

            guard tmpKey == result else {
                return result
            }

            tmpKey = key + "ANY_" + receiver
            result = tmpKey.localized()

            guard tmpKey == result else {
                return result
            }
        }

        tmpKey = key + "ANY_ANY"
        result = tmpKey.localized()

        guard tmpKey == result else {
            return result
        }

        fatalError("no match (not even generic)")
    }

    // GetDiploStringForMessage
    public func diploStringForMessage(for player1: AbstractPlayer?, and player2: AbstractPlayer? = nil) -> String {

        guard let leader1 = player1?.leader else {
            fatalError("leader must be provided")
        }

        let senderKey: String = leader1.name().uppercased()
        var receiverKey: String = "ANY"

        if let leader2 = player2?.leader {
            receiverKey = leader2.name().uppercased()
        }

        switch self {

        case .messageIntro: // RESPONSE_FIRST_GREETING

            return self.translation(key: "TXT_KEY_DIPLOMACY_FIRST_MEET_GREETINGS_", sender: senderKey, receiver: receiverKey)

        case .invitationToCapital:
            return self.translation(key: "TXT_KEY_DIPLOMACY_FIRST_MEET_NO_MANS_INFO_EXCHANGE_", sender: senderKey, receiver: receiverKey)

        case .coopWarRequest: // RESPONSE_COOP_WAR_REQUEST
            // AI would like to declare war on someone with a player
            guard let leader2 = player2?.leader else {
                fatalError("leader must be provided")
            }

            // TXT_KEY_COOP_WAR_REQUEST%
            return "Please join us to start war on \(leader2) now. Will you?"

        case .coopWarTime: // RESPONSE_COOP_WAR_TIME
            // AI calls up and says it's time to declare war on someone with a player
            guard let leader2 = player2?.leader else {
                fatalError("leader must be provided")
            }

            // TXT_KEY_COOP_WAR_TIME%
            return "Please join us to start war on \(leader2) in 10 turns. Will you?"

        case .peaceOffer: // RESPONSE_PEACE_OFFER
            return "I want peace"

        case .embassyExchange:
            return "Welcome to discuss .."

        case .embassyOffer:
            return "embassyOffer"

        case .openBordersExchange:
            return "openBordersExchange"

        case .openBordersOffer:
            return "openBordersOffer"

        case .exit:
            return "exit"
        }
    }
}
