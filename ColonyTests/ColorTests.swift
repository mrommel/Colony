//
//  ColorTests.swift
//  ColonyTests
//
//  Created by Michael Rommel on 09.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import XCTest

class ColorTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitColor16() {
        
        let color1 = Color16(red: 45, green: 128, blue: 17)
        
        XCTAssertEqual(color1.red, 41, "red not equal")
        XCTAssertEqual(color1.green, 130, "green not equal")
        XCTAssertEqual(color1.blue, 16, "blue not equal")
        //XCTAssertEqual(color.alpha, color2.alpha, "alpha not equal")
        
        let color2 = Color16(red: 41, green: 130, blue: 16)
        
        XCTAssertEqual(color1.value, color2.value, "values not equal")
        
        XCTAssertEqual(color2.red, 41, "red not equal")
        XCTAssertEqual(color2.green, 130, "green not equal")
        XCTAssertEqual(color2.blue, 16, "blue not equal")
    }
    
    func testCopyColor16() {
        
        let color1 = Color16(red: 45, green: 128, blue: 17)
        
        let color2 = Color16(value: color1.value)
        
        XCTAssertEqual(color1.red, color2.red, "red not equal")
        XCTAssertEqual(color1.green, color2.green, "green not equal")
        XCTAssertEqual(color1.blue, color2.blue, "blue not equal")
        XCTAssertEqual(color1.alpha, color2.alpha, "alpha not equal")
    }
    
    func testColor32FromColor16() {
        
        let color1 = Color16(red: 45, green: 128, blue: 17)
        
        let color2 = Color32(color: color1)
        
        XCTAssertEqual(color1.red, color2.red, "red not equal")
        XCTAssertEqual(color1.green, color2.green, "green not equal")
        XCTAssertEqual(color1.blue, color2.blue, "blue not equal")
        //XCTAssertEqual(color1.alpha, color2.alpha, "alpha not equal")
    }
    
    func testLerpColor16() {
        
        let color1 = Color16(red: 45, green: 128, blue: 17) // => r: 41, g: 125, b: 16
        let color2 = Color16(red: 47, green: 136, blue: 89) // => r: 41, g: 133, b: 82
        
        let color3 = Color16.lerp(min: color1, max: color2, value: 0.5)
        
        XCTAssertEqual(color3.red, 41, "red not equal")
        XCTAssertEqual(color3.green, 134, "green not equal")
        XCTAssertEqual(color3.blue, 49, "blue not equal")
    }
    
    func testParseUIColorRGB() {
        
        // GIVEN
        let colorString = "08bcfa"
        let colorWithHashString = "#e355f7"
        
        // WHEN
        let color = UIColor(hex: colorString).rgba
        let colorWithHash = UIColor(hex: colorWithHashString).rgba
        
        // THEN
        XCTAssertEqual(UInt(color.red * 255), 8, "red not equal")
        XCTAssertEqual(UInt(color.green * 255), 188, "green not equal")
        XCTAssertEqual(UInt(color.blue * 255), 250, "blue not equal")
        
        XCTAssertEqual(UInt(colorWithHash.red * 255), 227, "red not equal")
        XCTAssertEqual(UInt(colorWithHash.green * 255), 85, "green not equal")
        XCTAssertEqual(UInt(colorWithHash.blue * 255), 247, "blue not equal")
    }
    
    func testHexValueUIColor() {
        
        // GIVEN
        let color1 = UIColor(red: 8, green: 188, blue: 250)
        let color2 = UIColor(red: 227, green: 85, blue: 247)
        
        // WHEN
        let hexValue1 = color1.hexValue
        let hexValue2 = color2.hexValue
        
        // THEN
        XCTAssertEqual(hexValue1, "#08BCFA", "hex not equal")
        XCTAssertEqual(hexValue2, "#E355F7", "hex not equal")
    }
}
