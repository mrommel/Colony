//
//  SlpExtractionTests.swift
//  SmartColonyMacOSUITests
//
//  Created by Michael Rommel on 23.02.22.
//

import XCTest
import SmartAssets
@testable import SmartColonyMacOSUILibrary

class SlpExtractionTests: XCTestCase {

    private var downloadsFolder: URL = {
        let fileManager = FileManager.default
        let folder = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask)[0]

        var isDirectory: ObjCBool = false
        if !(fileManager.fileExists(atPath: folder.path, isDirectory: &isDirectory) && isDirectory.boolValue) {
            do {
                try fileManager.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
            } catch { }
        }
        return folder
    }()

    func testExtractMerchant() throws {

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "merchant-idle", ofType: "slp")
        let url = URL(fileURLWithPath: path!)

        guard let slpFile = SlpFileReader().load(from: url) else {
            XCTFail("Could not load file")
            return
        }

        XCTAssertEqual(slpFile.frames.count, 50)

        for index in 0..<slpFile.frames.count {

            let filenameUrl = downloadsFolder.appendingPathComponent("out\(index).png")
            try slpFile.frames[index].image()?.savePngTo(url: filenameUrl)
        }
    }
}
