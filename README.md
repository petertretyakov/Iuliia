# `Iuliia — Swift Version`

> Transliterate Cyrillic → Latin in every possible way

This is a Swift package for [Iuliia by Anton Zhiyanov](https://github.com/nalgeon/iuliia). It requires Swift 5.3 and Xcode 12 since from Swift 5.3 SPM supports package resources (JSON schema files and localization files in this case).

Transliteration means representing Cyrillic data (mainly names and geographic locations) with Latin letters. It is used for international passports, visas, green cards, driving licenses, mail and goods delivery etc.

`Iuliia` makes transliteration easy as calling `iuliia.translate()` in your favorite programming language.

Why use `Iuliia`:

-   20 transliteration schemas (rule sets), including all main international and Russian standards.
-   Correctly implements not only the base mapping, but all the special rules for letter combinations and word endings (AFAIK, Iuliia is the only library which does so).
-   Simple API and zero third-party dependencies.

## Supported schemas

Actual schemas:

-   ALA-LC: [ala_lc.json](Sources/Iuliia/Resources/Schemas/ala_lc.json) and [ala_lc_alt.json](Sources/Iuliia/Resources/Schemas/ala_lc_alt.json)
-   BGN/PCGN: [bgn_pcgn.json](Sources/Iuliia/Resources/Schemas/bgn_pcgn.json) and [bgn_pcgn_alt.json](Sources/Iuliia/Resources/Schemas/bgn_pcgn_alt.json)
-   BS 2979:1958: [bs_2979.json](Sources/Iuliia/Resources/Schemas/bs_2979.json) and [bs_2979_alt.json](Sources/Iuliia/Resources/Schemas/bs_2979_alt.json)
-   GOST R 52290-2004: [gost_52290.json](Sources/Iuliia/Resources/Schemas/gost_52290.json)
-   GOST R 7.0.34-2014: [gost_7034.json](Sources/Iuliia/Resources/Schemas/gost_7034.json)
-   ICAO DOC 9303: [icao_doc_9303.json](Sources/Iuliia/Resources/Schemas/icao_doc_9303.json)
-   ISO 9:1995 aka GOST 7.79-2000: [gost_779.json](Sources/Iuliia/Resources/Schemas/gost_779.json) and [gost_779_alt.json](Sources/Iuliia/Resources/Schemas/gost_779_alt.json)
-   UNGEGN 1987 V/18: [ungegn_1987.json](Sources/Iuliia/Resources/Schemas/ungegn_1987.json)
-   Moscow Metro map: [mosmetro.json](Sources/Iuliia/Resources/Schemas/mosmetro.json)
-   Scientific: [scientific.json](Sources/Iuliia/Resources/Schemas/scientific.json)
-   Telegram: [telegram.json](Sources/Iuliia/Resources/Schemas/telegram.json)
-   Wikipedia: [wikipedia.json](Sources/Iuliia/Resources/Schemas/wikipedia.json)
-   Yandex.Maps: [yandex_maps.json](Sources/Iuliia/Resources/Schemas/yandex_maps.json)
-   Yandex.Money: [yandex_money.json](Sources/Iuliia/Resources/Schemas/yandex_money.json)

And deprecated ones:

-   GOST 16876-71: [gost_16876.json](Sources/Iuliia/Resources/Schemas/gost_16876.json) and [gost_16876_alt.json](Sources/Iuliia/Resources/Schemas/gost_16876_alt.json)
-   GOST R 52535.1-2006: [gost_52535.json](Sources/Iuliia/Resources/Schemas/gost_52535.json)
-   ISO/R 9:1954: [iso_9_1954.json](Sources/Iuliia/Resources/Schemas/iso_9_1954.json)
-   ISO/R 9:1968: [iso_9_1968.json](Sources/Iuliia/Resources/Schemas/iso_9_1968.json) and [iso_9_1968_alt.json](Sources/Iuliia/Resources/Schemas/iso_9_1968_alt.json)
-   MVD 310-1997: [mvd_310.json](Sources/Iuliia/Resources/Schemas/mvd_310.json) and [mvd_310_fr.json](Sources/Iuliia/Resources/Schemas/mvd_310_fr.json)
-   MVD 782-2000: [mvd_782.json](Sources/Iuliia/Resources/Schemas/mvd_782.json)

For schema details and other information, see <https://dangry.ru/iuliia> (in Russian).

## Basic Usage

```swift
let iuliia = try! Iuliia(name: .wikipedia) // Parses schema file and initializes Schema
iuliia.translate("Юлия") // → Iuliia
```

### Custom Schemas

You can create your own schema JSON file with the following structure:

```json
{
    "name": "Your Schema name", 
    "mapping": {
        "а": "a",
        "б": "b",
        "в": "v",
        .
        .
        .
        "э": "e",
        "ю": "yu",
        "я": "ya"
    },
    "prev_mapping": {
        "е": "ye",
        "ае": "ye"
    },
    "next_mapping": {
        "ъа": "y",
        "ъи": "y"
    },
    "ending_mapping": {
        "ий": "y",
        "ый": "y"
    }
}
```
- `name` (*Optional*) — readable title for schema. "Custom" by default.
- `mapping` (**Required**) — Dictionary<Cyrillic letter, Latin representation>. Only one character per key allowed, keys with more than one character will be ommited during transliteration. To define custom transliteration logic for sequence of characters use `prev_mapping`, `next_mapping` and `ending_mapping`.
- `prev_mapping` (*Optional*) — Dictionary<1 or 2 cyrillic letters, Latin representation>. Mapping for letters with respect to previous sibling. One letter used for transliteration in beginning of words. According to this schema any `е` character in beginning of word or after `а` character will be transliterated to `ye`.
- `next_mapping` (*Optional*) — Dictionary<2 cyrillic letters, Latin representation>. Mapping for letters with respect to next sibling. According to this schema any `ъ` character before `а` and `и` characters will be transliterated to `y`.
- `ending_mapping` (*Optional*) — Dictionary<Any quantity of cyrillic letters, Latin represenation>. Mapping for word endings. According to this schema any word ended with `ий` or `ый` will end with just `y`.

For example, if you want to transliterate sequence of two cyrillic characters into one latin character (`кс` → `x` is the common case) you can achieve this with the following `prev_mapping` and `next_mapping` structure:

```json
{
    "prev_mapping": {
        "кс": "x"
    },
    "next_mapping": {
        "кс": ""
    }
}
```

To use your schema with `Iuliia` initialize it with schema URL

```swift
let iuliia = try! Iuliia(schemaURL: /path/to/your/custom/schema.json)
```

Additionaly you can create Swift `Schema` object and initialize `Iuliia` with it.

```swift
let schema = Schema(
    name: "My Custom Schema",
    letters: [ ... ],
    previous: [ ... ],
    next: [ ... ],
    ending: [ ... ]
)
let iuliia = Iuliia(schema: schema)
```

As with JSON schema files only `letters` required, other parameters are optional.

### Additional features

- You can see if `Schema.Name` is actual or deprecated with `isActual` and `isDeprecated` boolean variables.
- Full `Schema` localized (English or Russian) name is located in `Schema.name` property or in `Schema.Name.title` for any pre-built schemas.
- Check `IuliiaError` enum for list of possible errors during initialization process. Though they can be thrown during initialization of pre-built schemas, but they all are tested, so only some black magic can produce them. 

## Issues and limitations

In general:

-   Only Russian subset of Cyrillic is supported in pre-built schemas.
-   Does not support composite Unicode characters (e.g., `Ё`, but not `Ё`).

Schema-specific:

-   *BS 2979:1958*. This schema defines two alternative translations for `Ы`: `Ы` → `Ȳ` (used by the Oxford University Press) and `Ы` → `UI` (used by the British Library). `Iuliia` uses `Ы` → `Ȳ`.
-   *GOST R 7.0.34-2014*. This schema defines alternatives for many letters, but does not specify when to use which. Therefore, `Iuliia` uses the first of suggested translations for each such letter.
-   *MVD-310*. This schema defines `С` between two vowels → `SS`" rule. There is no such rule in other schemas, and MVD-310 itself is deprecated, so I decided to ignore this specific rule for the sake of code simplicity.

**If you found any problems while working with `Iuliia` feel free to create an Issue [here](https://github.com/petertretyakov/Iuliia/issues).**
