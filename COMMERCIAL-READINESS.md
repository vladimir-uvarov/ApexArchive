# Commercial readiness — internal release gates

Copyright © 2026 Vladimir Uvarov. All rights reserved.

Status: NOT CLEARED FOR COMMERCIAL LAUNCH. Changes are local; no subscriptions, purchases, new hosting, App Store submission or publication have been performed.

## Prepared in this version

- Independent product identity; no official logos or copied news feed. Default yellow/green helmet replaced with fictional orange/graphite artwork.
- F1DB CC BY 4.0 attribution, source links, release dates and modification notice. MIT notice for ZIPFoundation.
- Photo licence-name/URL matching, credit preservation, source access and display-change notice. Excluded NC/ND material is not made acceptable by a paywall.
- Offline-accessible privacy and legal information in Settings, support/correction route, and a required-reason declaration for cache timestamps.
- No ad/analytics/account/payment SDK. Existing quizzes, comparison and personalization are potential product features; there is no entitlement/paywall scaffolding to bypass or accidentally activate.

## Must resolve before public commercial operation

1. Operator details: confirm individual/company identity, jurisdiction, direct public support/privacy email, and a private route for rights complaints. The GitHub profile/issue route is provisional and not a substitute for all applicable privacy-notice requirements.
2. Hosting: publish the reviewed privacy policy and support page at stable public URLs only when authorized. Supply them in App Store Connect. The repository documents alone have not been published by this change.
3. Commercial content rights: ask F1DB maintainers about upstream provenance and scope, and have an IP professional assess database rights, driver personality rights and intended markets/marketing. F1DB CC BY 4.0 permits commercial use of rights its licensors control; it cannot grant rights held by others. Do not claim that a statistical fact or a licence notice alone clears extraction of an entire database.
4. Images: review each image used in store screenshots, paid creative, social campaigns or merchandise. Runtime Commons metadata is not an uploader-ownership, model-release or worldwide public-domain assessment. Keep licensed images editorial; do not sell raw third-party photos or suggest driver endorsement. Maintain source/credit links, accessible originals and applicable ShareAlike terms. For images that form copyright adaptations, comply with the relevant adaptation licence; app-code restrictions must not override third-party rights.
5. Brand: clear ApexArchive name, icon and intended store metadata in target markets. Avoid official logos, stylized marks, team liveries and athlete-branded paid tiers. Formula 1 fan guidance is not blanket permission for commercial activity. The previous yellow/green icon is already in public Git history; decide how to handle it before promotional use.
6. Privacy: finalize controller/contact and any legally required basis, transfers, retention and rights information for the actual operator and providers. Audit App Store privacy labels against the final binary and real collection practices, including GitHub/Wikimedia connection logging. No-tracking status is not a claim that no network personal data exists.
7. Store setup: replace the example bundle identifier before the first release and confirm signing, agreements, age rating, tax/banking details, storefronts and EU DSA trader status where applicable. Do not change an already-shipped identifier without a migration decision.
8. Verify the full archive/build and dependency privacy report in Xcode. Review VoiceOver, Dynamic Type, credits popover scrolling, image fallback, cold/warm launch, icon switching, comparison hit targets and offline behavior on devices. Automated checks do not replace these acceptance checks.

## Subscription design for a later implementation

Keep basic archive browsing, legal/privacy information, original-source links and attribution available independently of purchase. Monetize original continuing product value (fresh authored challenges, personal progress, advanced comparison tools) rather than exclusive ownership of third-party data or photographs. Validate actual recurring value before selecting a subscription; Apple requires ongoing value.

When authorized, implement StoreKit 2 with verified transactions, explicit entitlement states, restore/sync purchases, transaction updates, expiration/refund/revocation handling, family-sharing policy and offline behavior. Do not infer access from a local Boolean or hide disclosures behind login/payment. Test sandbox renewal, billing retry/grace period, cancellation and restore across devices.

The paywall must disclose the exact product, billing period, localized price, renewal terms, trial-to-paid transition where offered, and cancellation/management route. Provide accessible privacy policy and applicable EULA links. Do not promise lifetime features through a recurring plan or imply that cancellation refunds prior charges. Review region-specific payment, consumer, tax and withdrawal rules against the final business model. Any new purchase-related collection requires updated privacy disclosures.

## Sources checked

- Apple App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- Apple subscriptions: https://developer.apple.com/app-store/subscriptions/
- Apple required-reason APIs: https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api
- Apple EU trader requirements: https://developer.apple.com/help/app-store-connect/manage-compliance-information/manage-european-union-digital-services-act-trader-requirements
- F1DB: https://github.com/f1db/f1db
- CC BY 4.0: https://creativecommons.org/licenses/by/4.0/
- CC BY-SA 4.0 legal code: https://creativecommons.org/licenses/by-sa/4.0/legalcode.en
- Commons reuse: https://commons.wikimedia.org/wiki/Commons:Reusing_content_outside_Wikimedia
- Formula 1 brand guidance: https://www.formula1.com/en/information/guidelines.4EOKE9RRqevL4niTK9kWyt
