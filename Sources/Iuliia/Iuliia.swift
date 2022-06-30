//
//  Iuliia.swift
//  Iuliia
//
//  Created by Peter Tretyakov on 11.07.2020.
//  Copyright © 2020 Peter Tretyakov. All rights reserved.
//

import Foundation

public class Iuliia {
    public let schema: Schema

    public init(schema: Schema) {
        self.schema = schema
    }

    public convenience init(name: Schema.Name) throws {
        guard let url = Bundle.module.url(forResource: name.rawValue, withExtension: "json") else {
            throw IuliiaError.schemaFileNotFound(name.rawValue + ".json")
        }

        try self.init(schemaURL: url)
    }

    public convenience init(schemaURL: URL) throws {
        guard schemaURL.isFileURL else { throw IuliiaError.invalidSchemaURL(schemaURL) }

        let data: Data
        do {
            data = try Data(contentsOf: schemaURL, options: .mappedIfSafe)
        } catch {
            throw IuliiaError.invalidSchemaFile(error)
        }

        let decoder = JSONDecoder()
        let schema: Schema
        do {
            schema = try decoder.decode(Schema.self, from: data)
        } catch {
            throw IuliiaError.schemaDecodingError(error)
        }
        self.init(schema: schema)
    }

    public func translate(_ string: String) -> String {
        let uppercased = string.filter { $0.isLetter }.allSatisfy { $0.isUppercase }
        let words = string
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .map { transliteratedWord($0, stringUppercased: uppercased) }

        var result: String = ""
        var inWord: Bool = false
        var currentWordIndex: Int?

        string.forEach {
            if $0.unicodeScalars.allSatisfy({ CharacterSet.whitespacesAndNewlines.contains($0) }) {
                inWord = false
                result.append($0)
            } else if !inWord {
                inWord = true
                let wordIndex = currentWordIndex.map { $0 + 1 } ?? 0
                currentWordIndex = wordIndex
                result.append(words[wordIndex])
            }
        }

        return result
    }

    private func transliteratedWord(_ word: String, stringUppercased: Bool) -> String {
        let lemma: String
        let endingTransliterated: String
        if
            let ending = schema.ending,
            let key = ending.keys.sorted(by: { $0.count > $1.count }).first(where: { word.lowercased().hasSuffix($0) }),
            let match = ending[key]
        {
            let suffix = word.suffix(key.count)
            endingTransliterated = suffix.allSatisfy { $0.isUppercase } ? match.uppercased() : match
            lemma = String(word[word.startIndex ..< word.index(word.startIndex, offsetBy: word.count - key.count)])
        } else {
            endingTransliterated = ""
            lemma = word
        }

        let lemmaTransliterated = lemma.enumerated().map { offset, element in
            let lowercased = Character(element.lowercased())
            var transliterated = previous(lowercased, at: offset, in: lemma)
                ?? next(lowercased, at: offset, in: lemma)
                ?? base(lowercased)
                ?? String(element)

            if element.isUppercase {
                let nextElement = offset < lemma.count - 1 ? lemma[lemma.index(lemma.startIndex, offsetBy: offset + 1)] : nil
                let nextLowercased = nextElement?.unicodeScalars.allSatisfy({ CharacterSet.lowercaseLetters.contains($0) }) ?? false
                if (word.count == 1 && !stringUppercased) || nextLowercased {
                    transliterated = transliterated.capitalized
                } else {
                    transliterated = transliterated.uppercased()
                }
            }

            return transliterated
        }.joined()

        return lemmaTransliterated + endingTransliterated
    }

    private func previous(_ character: Character, at index: Int, in string: String) -> String? {
        guard let previous = schema.previous?.filter({ $0.key.last == character }), !previous.isEmpty else { return nil }

        if index == 0, let replace = previous[String(character)] {
            return replace
        } else if index > 0 {
            let previousElement = string[string.index(string.startIndex, offsetBy: index - 1)].lowercased()
            let key = previousElement + String(character)
            return previous[key]
        }

        return nil
    }

    private func next(_ character: Character, at index: Int, in string: String) -> String? {
        guard let next = schema.next?.filter({ $0.key.first == character }), !next.isEmpty, index < string.count - 1 else { return nil }

        let nextElement = string[string.index(string.startIndex, offsetBy: index + 1)].lowercased()
        let key = String(character) + nextElement
        return next[key]
    }

    private func base(_ character: Character) -> String? {
        schema.letters[String(character)]
    }
}
