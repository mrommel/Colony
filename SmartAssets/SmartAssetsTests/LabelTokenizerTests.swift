//
//  LabelTokenizerTests.swift
//  SmartAssetsTests
//
//  Created by Michael Rommel on 21.11.21.
//

import XCTest
@testable import SmartAssets

class LabelTokenizerTests: XCTestCase {

    func testTokenizeNoMatches() throws {

        // GIVEN
        let tokenizer = LabelTokenizer()

        // WHEN
        let result = tokenizer.tokenize(text: "abc def")

        // THEN
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], .text(content: "abc def"))
    }

    func testTokenizeExactMatch() throws {

        // GIVEN
        let tokenizer = LabelTokenizer()

        // WHEN
        let result = tokenizer.tokenize(text: "[Food]")

        // THEN
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], .image(type: .food))
    }

    func testTokenize3Elements() throws {

        // GIVEN
        let tokenizer = LabelTokenizer()

        // WHEN
        let result = tokenizer.tokenize(text: "abc [Food] def")

        // THEN
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0], .text(content: "abc"))
        XCTAssertEqual(result[1], .image(type: .food))
        XCTAssertEqual(result[2], .text(content: "def"))
    }

    func testTokenize5Elements() throws {

        // GIVEN
        let tokenizer = LabelTokenizer()

        // WHEN
        let result = tokenizer.tokenize(text: "abc [Food] def 3 [Production] Production")

        // THEN
        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result[0], .text(content: "abc"))
        XCTAssertEqual(result[1], .image(type: .food))
        XCTAssertEqual(result[2], .text(content: "def 3"))
        XCTAssertEqual(result[3], .image(type: .production))
        XCTAssertEqual(result[4], .text(content: "Production"))
    }

    func testTokenize5ElementsAndColor() throws {

        // GIVEN
        let tokenizer = LabelTokenizer()

        // WHEN
        let result = tokenizer.tokenize(text: "abc [Food] def [green]3[/green] [Production] [red]Production[/red]")

        // THEN
        XCTAssertEqual(result.count, 6)
        XCTAssertEqual(result[0], .text(content: "abc"))
        XCTAssertEqual(result[1], .image(type: .food))
        XCTAssertEqual(result[2], .text(content: "def"))
        XCTAssertEqual(result[3], .colored(content: "3", color: .green))
        XCTAssertEqual(result[4], .image(type: .production))
        XCTAssertEqual(result[5], .colored(content: "Production", color: .red))
    }
}
