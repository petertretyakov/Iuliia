//
//  XCTestManifests.swift
//  IuliiaTests
//
//  Created by Peter Tretyakov on 13.07.2020.
//  Copyright © 2020 Peter Tretyakov. All rights reserved.
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(IuliiaTests.allTests),
    ]
}
#endif
