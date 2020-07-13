//
//  IuliiaError.swift
//  Iuliia
//
//  Created by Peter Tretyakov on 13.07.2020.
//  Copyright © 2020 Peter Tretyakov. All rights reserved.
//

import Foundation

public enum IuliiaError: Error {
    case invalidSchemaURL(URL)
    case schemaFileNotFound(String)
    case invalidSchemaFile(Error)
    case schemaDecodingError(Error)
}
