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

            let url = Bundle.module.url(forResource: name.rawValue, withExtension: "json")!
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let samples = try decoder.decode(Samples.self, from: data)

            for item in samples.items {
                let result = iuliia.transliterate(item.source)

                print("SCHEMA          : \(iuliia.schema.name)")
                print("SOURCE          : \(item.source)")
                print("TRANSLITERATION : \(item.transliteration)")
                print("RESULT          : \(result)")
                print("-----------------")

                XCTAssertTrue(result == item.transliteration)
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
