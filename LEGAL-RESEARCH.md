# Data and release review

Reviewed 14 September 2026. This records source terms and implementation decisions; it is not a legal opinion or an assurance of App Store approval.

## Database and dependency

[F1DB](https://github.com/f1db/f1db#license) publishes its database under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), which permits commercial sharing and adaptation with attribution, license identification and change notices. These notices appear in the app and repository. The database’s license does not grant trademark, privacy or personality rights, and does not warrant non-infringement.

[ZIPFoundation 0.9.20](https://github.com/weichsel/ZIPFoundation/tree/0.9.20) uses the MIT license. Remote SPM integration is compatible with GitHub publication and commercial distribution when its copyright and permission notice are preserved; the app bundles that notice. SPM is the delivery mechanism, not a different license.

[Jolpica’s terms](https://github.com/jolpica/jolpica-f1/blob/main/TERMS.md) restrict its API data to noncommercial use under CC BY-NC-SA 4.0 without separate permission. The application no longer uses Jolpica; its cache filename also changed so previous Jolpica snapshots are not reused.

## Images and editorial content

[Commons reuse guidance](https://commons.wikimedia.org/wiki/Commons:Reusing_content_outside_Wikimedia) requires checking the individual file’s licensing and attribution. The app retains credit/license/source links and omits photos whose license metadata cannot be verified. Metadata checks cannot establish that every uploader owned every relevant right. Personality and trademark concerns remain separate, particularly for promotion or implied endorsement.

Garage descriptions distinguish documented use, delivery, commissioning and past ownership. Sources include manufacturer releases, auction descriptions and identified reporting. Photographs represent a model or family and do not prove ownership. Favourite tracks are attributed preferences, not inferred from wins. New editorial additions should follow the same evidence standard.

## Items needed before public operation or App Store submission

The Wikimedia User-Agent identifies ApexArchive and links to the operator profile, https://github.com/vladimir-uvarov, following the [Wikimedia User-Agent policy](https://foundation.wikimedia.org/wiki/Policy:Wikimedia_Foundation_User-Agent_Policy).
- Supply a privacy policy and support URL, real bundle identifier and signing team. The app stores favorites and cache locally, but requests to GitHub and Wikimedia expose normal connection information to those services.
- Review app name, icon, screenshots and marketing against [Formula 1 brand guidance](https://www.formula1.com/en/information/guidelines.4EOKE9RRqevL4niTK9kWyt) and relevant personality/trademark law. Removing a stripe from a yellow-and-green helmet does not establish clearance.
- Review [Apple’s intellectual-property requirements](https://developer.apple.com/app-store/review/guidelines/#intellectual-property) and the intended storefront/monetization model. Third-party data licensing alone does not establish full app compliance.

The F1DB and ZIPFoundation license terms provide a basis for publishing their permitted material on GitHub with the included notices. This is narrower than certifying every app asset and every intended use as legally cleared.

## Alternate artwork (15 September 2026)


The Crimson, Glacier and Pearl alternate helmet artworks were generated from the existing approved app artwork. Prompts requested fictional designs without driver, team, sponsor or manufacturer branding. These are decorative app icon choices, not representations or endorsements of particular drivers.

## Open Government Licence portraits

Wikimedia portraits explicitly marked OGL 3 are accepted only with the official National Archives version-3 licence URL. Author attribution, Commons source-page link, and the licence link accompany the image. [OGL v3 terms](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) permit commercial reuse subject to attribution and exclusions. This does not imply endorsement or grant unrelated personality/trademark rights. The current Lewis Hamilton lead portrait was identified as OGL 3 during a live Commons metadata check.

For Commons metadata explicitly marked Public domain with no separate licence URL, the rights link opens that file’s Commons description page. CC and OGL assets still require their recognized licence URLs. Source and author credits remain visible. See [Commons reuse guidance](https://commons.wikimedia.org/wiki/Commons:Reusing_content_outside_Wikimedia).

## Local commercial-readiness audit (15 September 2026)

Status: preparatory changes only; not legal clearance or authorization to launch. See COMMERCIAL-READINESS.md for unresolved release gates. Privacy information and complete F1DB/ZIPFoundation licences are accessible in Settings. File-timestamp access is declared for in-container cache management (C617.1). Photo credit metadata now retains supplied attribution, copyright, credit and restrictions; licence labels must match their canonical URL family/version.

The yellow-and-green default artwork has been replaced locally with an original orange/graphite abstract design in the app, splash and repository display asset. This reduces deliberate resemblance; it is not a trademark/design search or a guarantee of non-infringement. The old artwork may remain in earlier public Git history and requires a separate publication/history decision. Alternate designs still require visual rights review before marketing.
