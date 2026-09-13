<div align="center">
  <img src="Docs/Assets/ios-app-icon.svg" width="128" alt="ApexArchive painted racing helmet icon" />
  <h1>ApexArchive</h1>
  <p><strong>The drivers. The records. The cars beyond the circuit.</strong></p>
  <p>A racing archive for iPhone, bringing together the people, achievements and personal stories behind the sport.</p>
  <p>By <a href="https://github.com/vladimir-uvarov">Vladimir Uvarov</a></p>
</div>

---

## Discover the people behind the helmets

Explore modern favourites and legendary names, from today’s grid to Ayrton Senna and the drivers who shaped racing history. Find a driver by name or country, browse different eras, or discover who has the most Grand Prix wins.

## Explore their achievements

Dive into dedicated sections for Grand Prix victories and fastest race laps. Discover favourite circuits where a driver’s preference has been documented, with links to the original sources.

## Step inside their personal garages

Discover 57 documented car connections across 16 drivers, from everyday road cars to individually commissioned supercars. Explore personal specifications, distinctive finishes and the stories behind each connection.

Every entry includes its source and date, distinguishing personal ownership, manufacturer-provided cars and special commissions. Historical records describe the connection at that time; they do not imply current ownership. Photos illustrate the car model or model family.

## Circuits, teams and places to visit

Browse World Championship venues with their track outlines and lap records, the teams behind the legends, and a curated set of museums, collections and circuits you can actually visit — every one with an official link and a map.

## Test yourself, compare careers

A daily five-question quiz drawn from the archive itself, with a source behind every answer, and a side-by-side comparison of any two careers' records.

## Keep your favourites close

Save drivers to revisit their stories. Enjoy a clean, considered interface with light and dark appearances, subtle motion and saved content available when you’re offline.

---

## Engineering

- **Layered Swift package.** `ArchiveDomain` (models, contracts, no dependencies) ← `ArchiveData` (F1DB, Wikimedia, caching) and `ArchivePresentation` (observable view models). The app target composes them in one place and is the only module that imports `ArchiveData`. See [Docs/Architecture.md](Docs/Architecture.md).
- **Swift 6, strict concurrency, iOS 17+.** Actors isolate disk and network work; value types carry data.
- **Verification in CI.** 151 package tests, 14 app-hosted tests, swift-format and SwiftLint in strict mode, and project validators that fail on stale Xcode references, unreachable views, and localization values that drift from their source defaults. [VALIDATION.md](VALIDATION.md) records what has actually run.
- **Sourced content.** Every record, photo and place carries its source, licence and checked-on date; photos are accepted only under licences the app can display.

ApexArchive is an independent project, unaffiliated with Formula 1, teams or drivers. It is not currently available on the App Store.

Race data comes from [F1DB](https://github.com/f1db/f1db), by Marcel Overdijk and contributors, under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Data is selected, reformatted and combined with original editorial content. Individual photo credits and source links appear in the app. See [attributions](THIRD-PARTY-NOTICES.md).

© 2026 Vladimir Uvarov. All rights reserved.
