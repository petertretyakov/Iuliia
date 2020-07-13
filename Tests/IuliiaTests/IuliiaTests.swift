//
//  IuliiaTests.swift
//  IuliiaTests
//
//  Created by Peter Tretyakov on 23.04.2020.
//  Copyright © 2020 Peter Tretyakov. All rights reserved.
//

import XCTest
@testable import Iuliia

final class IuliiaTests: XCTestCase {
    func testSamples() throws {
        for name in Schema.Name.allCases {
            let iuliia = try Iuliia(schema: name)
            for sample in iuliia.schema.samples {
                print("SCHEMA          : \(iuliia.schema.name)")
                print("SOURCE          : \(sample.source)")
                print("TRANSLITERATION : \(sample.transliteration)")
                print("RESULT          : \(iuliia.transliterate(sample.source))")
                print("-----------------")
                XCTAssertTrue(iuliia.transliterate(sample.source) == sample.transliteration)
            }
        }
    }

    func testSingleUppercasedLetter() throws {
        let iuliia = try Iuliia(schema: .gost52290)
        XCTAssertTrue(iuliia.transliterate("Ё КРЁ МЯКОЁ123") == "YO KRYE MYAKOYO123")
    }

    func testTabsAndNewlines() throws {
        let iuliia = try Iuliia(schema: .mosmetro)
        XCTAssertTrue(iuliia.transliterate("\n\tМосметро\tОдин\n\t") == "\n\tMosmetro\tOdin\n\t")
    }

    static var allTests = [
        ("testSamples", testSamples),
        ("testSingleUppercasedLetter", testSingleUppercasedLetter),
        ("testTabsAndNewlines", testTabsAndNewlines)
    ]
}
