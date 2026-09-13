# Validation record

14 September 2026 · Xcode 26.2 / Swift 6.2.3.

## Completed

- 74 Swift Package Manager tests passed, zero failures, with code coverage enabled. Tests run locally without network access.
- swift-format strict checks, source structure/header checks and SwiftLint 0.65.1: zero violations across 112 Swift files.
- ArchiveDomain and ArchivePresentation cross-compiled for arm64 iOS 17. ArchiveData and its remote ZIPFoundation package also cross-compiled successfully.
- All app SwiftUI sources passed iOS 17 type-checking with Swift 6 and complete strict concurrency. The earlier app revision also passed arm64 simulator type-checking against the exact package modules built by the user’s Xcode session.
- The earlier live F1DB release check returned 917 unique drivers and, at that time, 12 sourced personal car entries; Senna totals were 41 Grand Prix wins and 19 fastest race laps.
- Four live image checks decoded licensed photos for Senna, Norris, first-generation Honda NSX and Ferrari F50. This is a sample check, not a claim that all historical drivers have available photos.
- The approved app icon file is 1024 × 1024 and its universal iOS asset entry points to that file.
- Sorting tests cover debut season, country, wins, missing values and interaction with search. Photo tests cover request sharing, unavailable metadata, explicit retry, eviction and isolation of Observation updates.

## Full build and remaining manual checks

The actual 01:58 Xcode build log revealed a Debug architecture mismatch: the app requested x86_64 while packages supplied arm64. Debug now uses ONLY_ACTIVE_ARCH=YES, with no hard-coded excluded architecture. The project validator checks this setting. The user confirmed a successful complete Xcode build after this fix.

A full current Xcode build could not complete in the automation environment: Xcode’s package-manifest resolver fails with `sandbox-exec: sandbox_apply: Operation not permitted`. The environment also cannot connect to CoreSimulatorService. Standalone SPM builds and app source type-checking succeeded; those checks do not replace a complete app build, asset compilation or simulator run.

The complete build was confirmed in the user’s Xcode session. Manually verify car image fit, credit popover anchoring, long-name layouts, Dynamic Type, VoiceOver, scrolling with the full archive, dark mode, offline startup and retry on an actual simulator/device before calling the UI release-ready. The simulator screenshot supplied for card layout could not be read from its temporary path. Xcode issue screenshots were visible and used to correct icon size and project references.

Swift 6 and complete concurrency checking are enabled on the app target. ArchiveKit uses Swift 6 through its package manifest; third-party packages retain their declared language mode. ZIPFoundation 0.9.20 declares Swift 5 language support; it has upstream mutable globals in its ZIP64 code. The dependency remains pinned and unmodified. Confirm warnings after Xcode rebuilds with the package configuration.

The GitHub Actions workflow is configured but has not run remotely yet.

## Reproduce

Run `Scripts/format.sh`, `Scripts/lint.sh`, then `Scripts/test.sh` with Xcode selected. Use `swift run --package-path Packages/ArchiveKit ArchiveIntegrationCheck --live` separately to contact external services. There is no automatic claim of performance or comprehensive test coverage based on test count alone.

Latest UI refinement: car card images fill the card width; credit controls use a 15-point visible inset and a content-sized popover. Empty garage and favourite-track sections are omitted, with a regression test for archive refreshes. Garage coverage is now 29 attributed connections across 16 drivers, with 30 editorial profiles. Latest UI changes passed iOS cross-compilation and app typechecking; simulator visual review remains pending.


The latest photo-cache suite verifies persistence across repository recreation, no download for unchanged URLs, replacement for changed URLs, metadata removal when media becomes ineligible, corrupt-image recovery, byte-budget eviction, shared downloads, and nonfatal disk-write failure. Presentation tests verify immediate cached display before refresh completion, offline preservation, successful removal, and prefetch batch limits. These are deterministic network-free tests, not measured real-device latency results.

Latest animation/caching changes passed iOS package cross-compilation and app SwiftUI typechecking. SwiftPM reports sandbox-related manifest-cache warnings in this environment; the compiler checks themselves passed. The new launch image asset has not been visually validated on a simulator. Record device cold/warm launch timing, scrolling hitches, memory and disk use, Reduced Motion, large Dynamic Type, and VoiceOver before publishing performance claims.

Launch/scroll refinement: iOS package cross-compilation, app SwiftUI typechecking, and SwiftLint (112 files, zero violations) passed. Project validation now checks the launch Info.plist and referenced background color asset. Simulator launch/scroll appearance remains a manual check: CoreSimulator access is blocked by this environment.

Local alternate-icon/settings changes: 79 package tests passed, including five SettingsViewModel tests for restoration, failure/retry, unsupported/no-op actions, concurrent taps, and system refresh. SwiftLint passed for 122 own Swift files. iOS package cross-compilation and app typechecking passed. Project validation checks all four named 1024px icon sets for Debug and Release. Actual Home Screen icon switching, system confirmation UI, iPad behavior, and Settings layout remain device/Simulator acceptance checks. These changes have not been pushed.

Selected-helmet splash and light-palette refinement: the splash reads the installed icon at startup and uses a full-resolution local image for each option. Light-mode interactive tint is burnt orange (#B94724), with neutral light-gray cards; dark mode retains gold. Check appearance and selected-icon launch on a device before release. No changes pushed.

Quiz and comparison: 90 package tests passed, including ten new tests covering question validity, insufficient records, locked answers, invalid input, scoring, completion/replay, distinct driver selection, swapping, and missing records. SwiftLint passed for 137 own Swift files. iOS packages and the Debug app compile/typecheck successfully; Xcode reference validation and whitespace checks passed. All quiz/comparison interface strings have English catalog entries. Simulator/device visual review, VoiceOver and large Dynamic Type remain manual acceptance checks. Changes remain local and unpushed.

Portrait follow-up: 97 package tests passed; SwiftLint passed for 140 own Swift files, and iOS package compilation/Debug app typechecking passed. Live Wikimedia metadata checks identified and corrected ambiguous article titles and OGL/public-domain handling. Retry overlays were removed. Full-device portrait coverage and comparison tap behavior still need visual acceptance checks.

Local commercial-readiness pass: 100 package tests passed, including licence-label/URL matching, credit retention and backward-compatible metadata decoding. SwiftLint passed for 143 own Swift files; iOS package and Debug app typechecks passed. Project validation checks bundled legal documents and cache file-timestamp declarations. Photo cache namespace advanced to Photos-v2 so images approved under older checks are not displayed before new rights validation. Default icon/splash/preview/README artwork updated locally. No subscription, publication or App Store submission. Operator contact details, rights review and full device acceptance remain release blockers listed in COMMERCIAL-READINESS.md.

## Circuits, heritage and quiz expansion — 15 September 2026

- 78 bundled circuits with licensed outlines; 10 historic constructors; 57 sourced garage entries.
- Live F1DB catalog integration passed (917 drivers, 78 circuits, 10 teams).
- Regression coverage checks layout-specific lap selection, exclusion of future races, legacy cache migration, catalog validation and unique quiz answers.
- Device/Simulator visual review remains pending; command-line app typechecking is not a full device build.
