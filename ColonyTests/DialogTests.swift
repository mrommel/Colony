//
//  DialogTests.swift
//  ColonyTests
//
//  Created by Michael Rommel on 04.11.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import XCTest
import XMLCoder
@testable import Colony

class DialogTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDialogConfiguration() {
        
        let dialogConfigurationData = """
        <?xml version="1.0"?>
        <context>
            <anchorx>center</anchorx>
            <anchory>center</anchory>
            <offsetx>-350</offsetx>
            <offsety>-670</offsety>
            <width>300</width>
            <height>620</height>
            <background>grid9_dialog</background>
            
            <!-- sub items -->
            <items>
                <item>
                    <identifier>dialog_image</identifier>
                    <type>image</type>
                    <anchorx>center</anchorx>
                    <anchory>center</anchory>
                    <offsetx>0</offsetx>
                    <offsety>170</offsety>
                    <width>80</width>
                    <height>80</height>
                    <image>questionmark</image>
                </item>
                <item>
                    <identifier>summary</identifier>
                    <type>label</type>
                    <title>Please select the map type</title>
                    <anchorx>center</anchorx>
                    <anchory>center</anchory>
                    <offsetx>0</offsetx>
                    <offsety>90</offsety>
                    <width>200</width>
                    <height>40</height>
                </item>
                <item>
                    <identifier>earth_button</identifier>
                    <type>button</type>
                    <image>MapType_Earth</image>
                    <title>Earth</title>
                    <result>EARTH</result>
                    <anchorx>center</anchorx>
                    <anchory>center</anchory>
                    <offsetx>0</offsetx>
                    <offsety>50</offsety>
                    <width>200</width>
                    <height>42</height>
                </item>
                <item>
                    <identifier>continents_button</identifier>
                    <type>button</type>
                    <image>MapType_Continents</image>
                    <title>Continents</title>
                    <result>CONTINENTS</result>
                    <anchorx>center</anchorx>
                    <anchory>center</anchory>
                    <offsetx>0</offsetx>
                    <offsety>0</offsety>
                    <width>200</width>
                    <height>42</height>
                </item>
                <item>
                    <identifier>pangaea_button</identifier>
                    <type>button</type>
                    <image>MapType_Pangaea</image>
                    <title>Pangaea</title>
                    <result>PANGAEA</result>
                    <anchorx>center</anchorx>
                    <anchory>center</anchory>
                    <offsetx>0</offsetx>
                    <offsety>-50</offsety>
                    <width>200</width>
                    <height>42</height>
                </item>
                <item>
                    <identifier>inlandsea_button</identifier>
                    <type>button</type>
                    <image>MapType_InlandSea</image>
                    <title>InlandSea</title>
                    <result>INLANDSEA</result>
                    <anchorx>center</anchorx>
                    <anchory>center</anchory>
                    <offsetx>0</offsetx>
                    <offsety>-100</offsety>
                    <width>200</width>
                    <height>42</height>
                </item>
                <item>
                    <identifier>archipelago_button</identifier>
                    <type>button</type>
                    <image>MapType_Archipelago</image>
                    <title>Archipelago</title>
                    <result>ARCHIPELAGO</result>
                    <anchorx>center</anchorx>
                    <anchory>center</anchory>
                    <offsetx>0</offsetx>
                    <offsety>-150</offsety>
                    <width>200</width>
                    <height>42</height>
                </item>
                <item>
                    <identifier>random_button</identifier>
                    <type>button</type>
                    <image>MapType_Random</image>
                    <title>Random</title>
                    <result>TYPERANDOM</result>
                    <anchorx>center</anchorx>
                    <anchory>center</anchory>
                    <offsetx>0</offsetx>
                    <offsety>-200</offsety>
                    <width>200</width>
                    <height>42</height>
                </item>
                <item>
                    <identifier>cancel_button</identifier>
                    <type>button</type>
                    <title>Cancel</title>
                    <result>CANCEL</result>
                    <anchorx>center</anchorx>
                    <anchory>center</anchory>
                    <offsetx>0</offsetx>
                    <offsety>-270</offsety>
                    <width>200</width>
                    <height>42</height>
                </item>
            </items>
        </context>
        """.data(using: .utf8)!
        
        let decoder = XMLDecoder()

        let dialogConfiguration = try! decoder.decode(DialogConfiguration.self, from: dialogConfigurationData)
        
        XCTAssertEqual(dialogConfiguration.offsetx, -350)
        XCTAssertEqual(dialogConfiguration.offsety, -670)
        XCTAssertEqual(dialogConfiguration.width, 300)
        XCTAssertEqual(dialogConfiguration.height, 620)
    }
}
