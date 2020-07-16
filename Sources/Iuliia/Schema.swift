//
//  Schema.swift
//  Iuliia
//
//  Created by Peter Tretyakov on 11.07.2020.
//  Copyright © 2020 Peter Tretyakov. All rights reserved.
//

import Foundation

public struct Schema: Decodable {
    public enum Name: String, CaseIterable {
        case alaLcAlt = "ala_lc_alt"
        case alaLc = "ala_lc"
        case bgnPcgnAlt = "bgn_pcgn_alt"
        case bgnPcgn = "bgn_pcgn"
        case bs2979Alt = "bs_2979_alt"
        case bs2979 = "bs_2979"
        case gost779Alt = "gost_779_alt"
        case gost779 = "gost_779"
        case gost7034 = "gost_7034"
        case gost16876Alt = "gost_16876_alt"
        case gost16876 = "gost_16876"
        case gost52290 = "gost_52290"
        case gost52535 = "gost_52535"
        case icaoDoc9303 = "icao_doc_9303"
        case iso9_1954 = "iso_9_1954"
        case iso9_1968Alt = "iso_9_1968_alt"
        case iso9_1968 = "iso_9_1968"
        case mosmetro = "mosmetro"
        case mvd310Fr = "mvd_310_fr"
        case mvd310 = "mvd_310"
        case mvd782 = "mvd_782"
        case scientific = "scientific"
        case telegram = "telegram"
        case ungegn1987 = "ungegn_1987"
        case wikipedia = "wikipedia"
        case yandexMaps = "yandex_maps"
        case yandexMoney = "yandex_money"

        public var isActual: Bool {
            switch self {
                case .alaLc, .alaLcAlt, .bgnPcgn, .bgnPcgnAlt, .bs2979, .bs2979Alt, .gost52290, .gost7034, .icaoDoc9303, .gost779,
                     .gost779Alt, .ungegn1987, .mosmetro, .scientific, .telegram, .wikipedia, .yandexMaps, .yandexMoney:
                    return true
                case .gost16876, .gost16876Alt, .gost52535, .iso9_1954, .iso9_1968, .iso9_1968Alt, .mvd310, .mvd310Fr, .mvd782:
                    return false
            }
        }

        public var isDeprecated: Bool {
            !isActual
        }

        public var title: String {
            NSLocalizedString(rawValue, bundle: .module, comment: "")
        }
    }

    public let name: String
    public let letters: [String: String]
    public let previous: [String: String]?
    public let next: [String: String]?
    public let ending: [String: String]?

    public init(
        name: String = "Custom",
        letters: [String: String],
        previous: [String: String]? = nil,
        next: [String: String]? = nil,
        ending: [String: String]? = nil
    ) {
        self.name = name
        self.letters = letters
        self.previous = previous
        self.next = next
        self.ending = ending
    }

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case letters = "mapping"
        case previous = "prev_mapping"
        case next = "next_mapping"
        case ending = "ending_mapping"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let jsonName = try container.decodeIfPresent(String.self, forKey: .name) ?? "Custom"
        name = Name(rawValue: jsonName)?.title ?? jsonName
        letters = try container.decode([String: String].self, forKey: .letters)
        previous = try container.decodeIfPresent([String: String].self, forKey: .previous)
        next = try container.decodeIfPresent([String: String].self, forKey: .next)
        ending = try container.decodeIfPresent([String: String].self, forKey: .ending)
    }
}
