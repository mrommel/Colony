//
//  MapLoadingTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 02.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class MapLoadingTests: XCTestCase {
    
    private var downloadsFolder: URL = {
        let fm = FileManager.default
        let folder = fm.urls(for: .downloadsDirectory, in: .userDomainMask)[0]

        var isDirectory: ObjCBool = false
        if !(fm.fileExists(atPath: folder.path, isDirectory: &isDirectory) && isDirectory.boolValue) {
            try! fm.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
        }
        return folder
    }()
    
    func testConvertDuelMap() throws {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Earth_Duel", ofType: "Civ5Map")
        let url = URL(fileURLWithPath: path!)

        let civ5MapLoader = Civ5MapReader()
        let civ5Map = civ5MapLoader.load(from: url)
        
        let map = civ5Map?.toMap()
        
        let filename = downloadsFolder.appendingPathComponent("earth_duel.map")
        
        let writer = MapWriter()
        let saved = writer.write(map: map, to: filename)

        XCTAssertTrue(saved)
        XCTAssertNotNil(map)
    }
    
    func testConvertTinyMap() throws {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Earth_Tiny", ofType: "Civ5Map")
        let url = URL(fileURLWithPath: path!)

        let civ5MapLoader = Civ5MapReader()
        let civ5Map = civ5MapLoader.load(from: url)
        
        let map = civ5Map?.toMap()
        
        let filename = downloadsFolder.appendingPathComponent("earth_tiny.map")
        
        let writer = MapWriter()
        let saved = writer.write(map: map, to: filename)

        XCTAssertTrue(saved)
        XCTAssertNotNil(map)
    }
    
    func testConvertSmallMap() throws {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Earth_Small", ofType: "Civ5Map")
        let url = URL(fileURLWithPath: path!)

        let civ5MapLoader = Civ5MapReader()
        let civ5Map = civ5MapLoader.load(from: url)
        
        let map = civ5Map?.toMap()
        
        let filename = downloadsFolder.appendingPathComponent("earth_small.map")
        
        let writer = MapWriter()
        let saved = writer.write(map: map, to: filename)

        XCTAssertTrue(saved)
        XCTAssertNotNil(map)
    }
    
    func testConvertStandardMap() throws {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Earth_Standard", ofType: "Civ5Map")
        let url = URL(fileURLWithPath: path!)

        let civ5MapLoader = Civ5MapReader()
        let civ5Map = civ5MapLoader.load(from: url)
        
        let map = civ5Map?.toMap()
        
        let filename = downloadsFolder.appendingPathComponent("earth_standard.map")
        
        let writer = MapWriter()
        let saved = writer.write(map: map, to: filename)

        XCTAssertTrue(saved)
        XCTAssertNotNil(map)
    }
    
    func testConvertLargeMap() throws {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Earth_Large", ofType: "Civ5Map")
        let url = URL(fileURLWithPath: path!)

        let civ5MapLoader = Civ5MapReader()
        let civ5Map = civ5MapLoader.load(from: url)
        
        let map = civ5Map?.toMap()
        
        let filename = downloadsFolder.appendingPathComponent("earth_large.map")
        
        let writer = MapWriter()
        let saved = writer.write(map: map, to: filename)

        XCTAssertTrue(saved)
        XCTAssertNotNil(map)
    }
    
    func testConvertHugeMap() throws {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Earth_Huge", ofType: "Civ5Map")
        let url = URL(fileURLWithPath: path!)

        let civ5MapLoader = Civ5MapReader()
        let civ5Map = civ5MapLoader.load(from: url)
        
        let map = civ5Map?.toMap()
        
        let filename = downloadsFolder.appendingPathComponent("earth_huge.map")
        
        let writer = MapWriter()
        let saved = writer.write(map: map, to: filename)

        XCTAssertTrue(saved)
        XCTAssertNotNil(map)
    }
    
    func testLoadDuelMap() throws {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Earth_Duel", ofType: "Civ5Map")
        let url = URL(fileURLWithPath: path!)

        let civ5MapLoader = Civ5MapReader()
        let civ5Map = civ5MapLoader.load(from: url)
        
        let map = civ5Map?.toMap()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(map)
        //let string = String(data: data, encoding: .utf8)!
        
        let decoder = JSONDecoder()
        let decodedMap = try decoder.decode(MapModel.self, from: data)
        
        XCTAssertNotNil(decodedMap)
    }
}
