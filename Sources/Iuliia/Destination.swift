//
//  Destination.swift
//  Iuliia
//
//  Created by Peter Tretyakov on 13.07.2020.
//  Copyright © 2020 Peter Tretyakov. All rights reserved.
//

public enum Destination {
    case passport
    case driverLicense
    case creditCard
    case address
    case addressInternational
    case name
    case url
    case reversible

    internal var schema: Schema.Name {
        switch self {
            case .passport:
                return .icaoDoc9303
            case .driverLicense:
                return .icaoDoc9303
            case .creditCard:
                return .mosmetro
            case .address:
                return .wikipedia
            case .addressInternational:
                return .bs2979
            case .name:
                return .mosmetro
            case .url:
                return .wikipedia
            case .reversible:
                return .gost779
        }
    }
}
