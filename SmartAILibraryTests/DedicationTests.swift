//
//  DedicationTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 05.01.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class DedicationTests: XCTestCase {

    func testCombatWarriorAgainstWarrior() {

        // GIVEN
        let ancientEra = EraType.ancient
        let classicalEra = EraType.classical
        let medievalEra = EraType.medieval
        let renaissanceEra = EraType.renaissance
        let industrialEra = EraType.industrial
        let modernEra = EraType.modern
        let atomicEra = EraType.atomic
        let informationEra = EraType.information

        // WHEN
        let ancientDedications = ancientEra.dedications()
        let classicalDedications = classicalEra.dedications()
        let medievalDedications = medievalEra.dedications()
        let renaissanceDedications = renaissanceEra.dedications()
        let industrialDedications = industrialEra.dedications()
        let modernDedications = modernEra.dedications()
        let atomicDedications = atomicEra.dedications()
        let informationDedications = informationEra.dedications()

        // THEN
        XCTAssertEqual(ancientDedications, [])
        XCTAssertEqual(classicalDedications, [.monumentality, .penBrushAndVoice, .freeInquiry, .exodusOfTheEvangelists])
        XCTAssertEqual(medievalDedications, [.monumentality, .penBrushAndVoice, .freeInquiry, .exodusOfTheEvangelists])
        XCTAssertEqual(renaissanceDedications, [.monumentality, .exodusOfTheEvangelists, .hicSuntDracones, .reformTheCoinage])
        XCTAssertEqual(industrialDedications, [.hicSuntDracones, .reformTheCoinage, .heartbeatOfSteam, .toArms])
        XCTAssertEqual(modernDedications, [.hicSuntDracones, .reformTheCoinage, .heartbeatOfSteam, .toArms])
        XCTAssertEqual(atomicDedications, [.toArms, .wishYouWereHere, .bodyguardOfLies, .skyAndStars])
        XCTAssertEqual(informationDedications, [.toArms, .wishYouWereHere, .bodyguardOfLies, .skyAndStars, .automatonWarfare])
    }
}
