//
//  OperationAbortReasonType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum OperationAbortReasonType: Int, Codable {

    case none

    case success // AI_ABORT_SUCCESS
    case noTarget // AI_ABORT_NO_TARGET
    case repeatTarget // AI_ABORT_REPEAT_TARGET
    case lostTarget // AI_ABORT_LOST_TARGET
    case targetAlreadyCaptured // AI_ABORT_TARGET_ALREADY_CAPTURED
    case noRoomDeploy // AI_ABORT_NO_ROOM_DEPLOY
    case halfStrength // AI_ABORT_HALF_STRENGTH
    case noMuster // AI_ABORT_NO_MUSTER
    case escortDied // AI_ABORT_ESCORT_DIED
    case lostCivilian // AI_ABORT_LOST_CIVILIAN
    // AI_ABORT_NO_NUKES
    case killed // AI_ABORT_KILLED
    case warStateChange // AI_ABORT_WAR_STATE_CHANGE,
    case diploOpinionChange // AI_ABORT_DIPLO_OPINION_CHANGE,
    case lostPath // AI_ABORT_LOST_PATH,
}
