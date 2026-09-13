# Archive content

Copyright © 2026 Vladimir Uvarov. All rights reserved.

The initial bundle contains 78 championship venues, ten selected historic constructors and 57 sourced personal-car connections. F1DB refreshes circuit, constructor and driver records together from one versioned split JSON archive. Historical ownership reports do not assert present ownership. Car descriptions are original short factual summaries with dated source links; source photographs are not bundled.

## Circuit records

Each circuit uses the most recently raced F1DB layout, excluding future race dates. The displayed time is the minimum positive recorded race-lap time belonging to that exact layout ID. It excludes qualifying/testing times and is limited by the provider’s historical coverage. Older layout records cannot override it.

## Outlines

Source: https://github.com/f1db/f1db/tree/main/src/assets/circuits/white
Original artwork: https://github.com/f1db/f1-circuits-svg
Copyright © 2024–2026 ROY Jules, CC BY 4.0. Imported 15 September 2026.

The SVG paths were sampled at 501 evenly spaced path parameters using svgpathtools 1.8.0, translated to a zero origin, uniformly normalized by the longest bounding-box dimension, and rounded to five decimal places. Ain-Diab’s translation is removed by that normalization. The app draws these generated points as a native SwiftUI path, with its own colour and stroke width. Attribution and modification notices are available on circuit pages and in Settings.

To update outlines, obtain the upstream assets, match each SVG filename to the catalog’s layout ID, repeat the sampling and normalization, and preserve the licence notices. The renderer only reuses an outline when its layout ID still matches the refreshed record. A new unmatched layout shows an unavailable state rather than a misleading older shape.

## Localizable content

UI copy, quiz prompts/options/explanations, original team histories and bundled garage editorial text have keys in Localizable.xcstrings. Backend names and record values remain provider content. Official licence texts retain their original wording. Adding another language requires translations in the catalog; this change does not claim that translated content already exists.
