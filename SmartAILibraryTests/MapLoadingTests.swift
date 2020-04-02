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
    
    var downloadsFolder: URL = {
        let fm = FileManager.default
        let folder = fm.urls(for: .downloadsDirectory, in: .userDomainMask)[0]

        var isDirectory: ObjCBool = false
        if !(fm.fileExists(atPath: folder.path, isDirectory: &isDirectory) && isDirectory.boolValue) {
            try! fm.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
        }
        return folder
    }()
    
    func testLoadDuelMap() throws {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Earth_Duel", ofType: "Civ5Map")
        let url = URL(fileURLWithPath: path!)

        let civ5MapLoader = Civ5MapReader()
        let civ5Map = civ5MapLoader.load(from: url)
        
        let map = civ5Map?.toMap()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(map)
        let string = String(data: data, encoding: .utf8)!
        
        let filename = downloadsFolder.appendingPathComponent("duel.map")
        
        do {
            try string.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            
        }

        XCTAssertNotNil(map)
    }
    
    func testLoadTinyMap() throws {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Earth_Tiny", ofType: "Civ5Map")
        let url = URL(fileURLWithPath: path!)

        let civ5MapLoader = Civ5MapReader()
        let civ5Map = civ5MapLoader.load(from: url)
        
        let map = civ5Map?.toMap()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(map)
        let string = String(data: data, encoding: .utf8)!
        
        let filename = downloadsFolder.appendingPathComponent("tiny.map")
        
        do {
            try string.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            
        }

        XCTAssertNotNil(map)
    }
    
    func testLoadSmallMap() throws {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Earth_Small", ofType: "Civ5Map")
        let url = URL(fileURLWithPath: path!)

        let civ5MapLoader = Civ5MapReader()
        let civ5Map = civ5MapLoader.load(from: url)
        
        let map = civ5Map?.toMap()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(map)
        let string = String(data: data, encoding: .utf8)!
        
        let filename = downloadsFolder.appendingPathComponent("small.map")
        
        do {
            try string.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            
        }

        XCTAssertNotNil(map)
    }
    
    func testLoadStandardMap() throws {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Earth_Standard", ofType: "Civ5Map")
        let url = URL(fileURLWithPath: path!)

        let civ5MapLoader = Civ5MapReader()
        let civ5Map = civ5MapLoader.load(from: url)
        
        let map = civ5Map?.toMap()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(map)
        let string = String(data: data, encoding: .utf8)!
        
        let filename = downloadsFolder.appendingPathComponent("standard.map")
        
        do {
            try string.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            
        }

        XCTAssertNotNil(map)
    }
}
