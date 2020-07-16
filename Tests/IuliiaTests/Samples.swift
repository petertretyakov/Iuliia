//
//  Sample.swift
//  IuliiaTests
//
//  Created by Peter Tretyakov on 16.07.2020.
//  Copyright © 2020 Peter Tretyakov. All rights reserved.
//

import Foundation
@testable import Iuliia

struct Samples: Decodable {
    struct Item {
        let source: String
        let transliteration: String
    }

    let items: [Item]

    private enum CodingKeys: String, CodingKey {
        case samples = "samples"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let itemsArray = try container.decodeIfPresent([[String]].self, forKey: .samples) ?? []
        items = itemsArray.filter { $0.count == 2 }.map { Item(source: $0[0], transliteration: $0[1]) }
    }
}
