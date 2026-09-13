//
// RacingPlaceCatalog.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

import Foundation

enum RacingPlaceCatalog {
    static let places: [RacingPlace] = [
        RacingPlace(
            id: "ferrari", kind: .museum, name: "Museo Ferrari",
            location: String(localized: "museum.ferrari.location", defaultValue: "Maranello, Italy"), countryCode: "IT",
            address: "Via Dino Ferrari 43, 41053 Maranello, Italy",
            summary: String(
                localized: "museum.ferrari.summary",
                defaultValue:
                    "A natural stop for Ferrari followers: explore the marque’s road and racing history in the town where its cars are built. Pair the visit with time in Italy’s Motor Valley."
            ),
            website: "https://www.ferrari.com/en-EN/museums/ferrari-maranello"),
        RacingPlace(
            id: "alfa", kind: .museum, name: "Museo Alfa Romeo",
            location: String(localized: "museum.alfa.location", defaultValue: "Arese, Italy"), countryCode: "IT",
            address: "Viale Alfa Romeo, 20044 Arese, Italy",
            summary: String(
                localized: "museum.alfa.summary",
                defaultValue:
                    "Trace Alfa Romeo through its road cars, design and racing heritage. A fitting companion to the archive’s stories of the marque’s early Grand Prix success."
            ),
            website: "https://www.museoalfaromeo.com/en-us/visita/Pages/visita.aspx"),
        RacingPlace(
            id: "porsche", kind: .museum, name: "Porsche Museum",
            location: String(localized: "museum.porsche.location", defaultValue: "Stuttgart, Germany"),
            countryCode: "DE",
            address: "Porscheplatz 1, 70435 Stuttgart, Germany",
            summary: String(
                localized: "museum.porsche.summary",
                defaultValue:
                    "Explore the connection between Porsche’s sports cars, engineering and competition history. Particularly rewarding if the stories behind racing technology interest you."
            ),
            website: "https://www.porsche.com/international/aboutporsche/porschemuseum/"),
        RacingPlace(
            id: "mercedes", kind: .museum, name: "Mercedes-Benz Museum",
            location: String(localized: "museum.mercedes.location", defaultValue: "Stuttgart, Germany"),
            countryCode: "DE",
            address: "Mercedesstraße 100, 70372 Stuttgart, Germany",
            summary: String(
                localized: "museum.mercedes.summary",
                defaultValue:
                    "A broader journey through automotive history, with road vehicles and motorsport woven together. A useful way to place the Silver Arrows’ story in its wider engineering context."
            ),
            website: "https://www.mercedes-benz.com/en/art-and-culture/place/visitor-information/"),
        RacingPlace(
            id: "silverstone", kind: .museum, name: "Silverstone Museum",
            location: String(localized: "museum.silverstone.location", defaultValue: "Silverstone, United Kingdom"),
            countryCode: "GB",
            address: "Silverstone Circuit, Dadford Road, NN12 8TN, United Kingdom",
            summary: String(
                localized: "museum.silverstone.summary",
                defaultValue:
                    "Discover the people and stories behind British motorsport at Silverstone. The museum makes a natural addition to a trip to the circuit; access arrangements can differ on major event weekends."
            ),
            website: "https://www.silverstonemuseum.co.uk/plan-your-visit/visitor-info/"),
        RacingPlace(
            id: "lamborghini", kind: .museum, name: "Museo Lamborghini",
            location: String(localized: "museum.lamborghini.location", defaultValue: "Sant’Agata Bolognese, Italy"),
            countryCode: "IT",
            address: "Via Modena 12, 40019 Sant’Agata Bolognese BO, Italy",
            summary: String(
                localized: "museum.lamborghini.summary",
                defaultValue:
                    "Lamborghini’s own collection sits beside the factory, a short drive from Maranello. Convenient if you are already touring Italy’s Motor Valley and want more than one marque in a day."
            ),
            website: "https://www.lamborghini.com/en-en/place"),
        RacingPlace(
            id: "mauto", kind: .museum, name: "Museo Nazionale dell’Automobile",
            location: String(localized: "museum.mauto.location", defaultValue: "Turin, Italy"),
            countryCode: "IT",
            address: "Corso Unità d’Italia 40, 10126 Torino TO, Italy",
            summary: String(
                localized: "museum.mauto.summary",
                defaultValue:
                    "One of the oldest automobile museums in the world, telling the story of the car as an object and an industry. Turin’s own motoring history runs through the collection."
            ),
            website: "https://www.museoauto.it/"),
        RacingPlace(
            id: "schlumpf", kind: .museum, name: "Cité de l’Automobile",
            location: String(localized: "museum.schlumpf.location", defaultValue: "Mulhouse, France"),
            countryCode: "FR",
            address: "17 Rue de la Mertzau, 68100 Mulhouse, France",
            summary: String(
                localized: "museum.schlumpf.summary",
                defaultValue:
                    "The former Schlumpf collection, including an exceptional row of Bugattis. Worth the detour for anyone interested in pre-war Grand Prix machinery."
            ),
            website: "https://www.citedelautomobile.com/"),
        RacingPlace(
            id: "brooklands", kind: .museum, name: "Brooklands Museum",
            location: String(localized: "museum.brooklands.location", defaultValue: "Weybridge, United Kingdom"),
            countryCode: "GB",
            address: "Brooklands Road, Weybridge KT13 0QN, United Kingdom",
            summary: String(
                localized: "museum.brooklands.summary",
                defaultValue:
                    "The site of the world’s first purpose-built motor racing circuit, opened in 1907. Sections of the original banking still stand and can be walked."
            ),
            website: "https://www.brooklandsmuseum.com/"),
        RacingPlace(
            id: "jimclark", kind: .museum, name: "Jim Clark Motorsport Museum",
            location: String(localized: "museum.jimclark.location", defaultValue: "Duns, United Kingdom"),
            countryCode: "GB",
            address: "44 Newtown Street, Duns TD11 3AU, United Kingdom",
            summary: String(
                localized: "museum.jimclark.summary",
                defaultValue:
                    "A museum in the Borders town Jim Clark called home, devoted to the two-time World Champion. Small, specific and a quiet counterpoint to the factory collections."
            ),
            website: "https://jimclarktrust.com/"),
        RacingPlace(
            id: "villeneuve", kind: .museum, name: "Musée Gilles-Villeneuve",
            location: String(localized: "museum.villeneuve.location", defaultValue: "Berthierville, Canada"),
            countryCode: "CA",
            address: "960 Avenue Gilles-Villeneuve, Berthierville, QC J0K 1A0, Canada",
            summary: String(
                localized: "museum.villeneuve.summary",
                defaultValue:
                    "Gilles Villeneuve’s home town keeps his story in the open, from karting beginnings to Ferrari. A reminder of how local a Grand Prix career can start."
            ),
            website: "https://www.museegillesvilleneuve.com/"),
        RacingPlace(
            id: "fangio", kind: .museum, name: "Museo Juan Manuel Fangio",
            location: String(localized: "museum.fangio.location", defaultValue: "Balcarce, Argentina"),
            countryCode: "AR",
            address: "Dardo Rocha 639, B7620 Balcarce, Buenos Aires, Argentina",
            summary: String(
                localized: "museum.fangio.summary",
                defaultValue:
                    "Five world titles, documented in the Argentine town where Fangio was born and is buried. The collection covers the road-racing era that shaped him."
            ),
            website: "https://www.museofangio.com/"),
        RacingPlace(
            id: "louwman", kind: .museum, name: "Louwman Museum",
            location: String(localized: "museum.louwman.location", defaultValue: "The Hague, Netherlands"),
            countryCode: "NL",
            address: "Leidsestraatweg 57, 2594 BB Den Haag, Netherlands",
            summary: String(
                localized: "museum.louwman.summary",
                defaultValue:
                    "A broad private collection strong on early motoring and coachwork. Useful context for how racing cars and road cars diverged."
            ),
            website: "https://www.louwmanmuseum.nl/"),
        RacingPlace(
            id: "petersen", kind: .museum, name: "Petersen Automotive Museum",
            location: String(localized: "museum.petersen.location", defaultValue: "Los Angeles, United States"),
            countryCode: "US",
            address: "6060 Wilshire Blvd, Los Angeles, CA 90036, United States",
            summary: String(
                localized: "museum.petersen.summary",
                defaultValue:
                    "Wide-ranging exhibits on car culture, design and competition, with rotating displays. A good stop if your interest runs past Grand Prix racing alone."
            ),
            website: "https://petersen.org/"),
        RacingPlace(
            id: "monza", kind: .landmark, name: "Autodromo Nazionale Monza",
            location: String(localized: "museum.monza.location", defaultValue: "Monza, Italy"),
            countryCode: "IT",
            address: "Viale di Vedano 5, 20900 Monza MB, Italy",
            summary: String(
                localized: "museum.monza.summary",
                defaultValue:
                    "In continuous use since 1922 and set inside a royal park. The abandoned banked oval still stands away from the modern track and is the reason many people come."
            ),
            website: "https://www.monzanet.it/"),
        RacingPlace(
            id: "spa", kind: .landmark, name: "Circuit de Spa-Francorchamps",
            location: String(localized: "museum.spa.location", defaultValue: "Stavelot, Belgium"),
            countryCode: "BE",
            address: "Route du Circuit 55, 4970 Stavelot, Belgium",
            summary: String(
                localized: "museum.spa.summary",
                defaultValue:
                    "Eau Rouge and Raidillon read very differently in person than on television; the gradient is the point. Public access depends on the event calendar and track days."
            ),
            website: "https://www.spa-francorchamps.be/"),
        RacingPlace(
            id: "nurburgring", kind: .landmark, name: "Nürburgring",
            location: String(localized: "museum.nurburgring.location", defaultValue: "Nürburg, Germany"),
            countryCode: "DE",
            address: "Otto-Flimm-Straße, 53520 Nürburg, Germany",
            summary: String(
                localized: "museum.nurburgring.summary",
                defaultValue:
                    "The Nordschleife opens to the public on tourist-driving days, and the Karussell can be reached on foot. Check opening and closure notices before travelling."
            ),
            website: "https://www.nuerburgring.de/"),
        RacingPlace(
            id: "imola", kind: .landmark, name: "Autodromo Enzo e Dino Ferrari",
            location: String(localized: "museum.imola.location", defaultValue: "Imola, Italy"),
            countryCode: "IT",
            address: "Piazza Ayrton Senna da Silva 1, 40026 Imola BO, Italy",
            summary: String(
                localized: "museum.imola.summary",
                defaultValue:
                    "The parkland setting is open outside events, and memorials to Ayrton Senna and Roland Ratzenberger stand near the circuit. Visitors treat both as places of remembrance."
            ),
            website: "https://www.autodromoimola.it/"),
        RacingPlace(
            id: "monaco", kind: .landmark, name: "Circuit de Monaco",
            location: String(localized: "museum.monaco.location", defaultValue: "Monte Carlo, Monaco"),
            countryCode: "MC",
            address: "Automobile Club de Monaco, 23 Boulevard Albert 1er, 98000 Monaco",
            summary: String(
                localized: "museum.monaco.summary",
                defaultValue:
                    "The circuit is ordinary public road for most of the year, so the corners can simply be walked. Casino Square, the tunnel exit and Rascasse are all within a short route."
            ),
            website: "https://acm.mc/"),
        RacingPlace(
            id: "goodwood", kind: .landmark, name: "Goodwood Motor Circuit",
            location: String(localized: "museum.goodwood.location", defaultValue: "Chichester, United Kingdom"),
            countryCode: "GB",
            address: "Goodwood, Chichester PO18 0PH, United Kingdom",
            summary: String(
                localized: "museum.goodwood.summary",
                defaultValue:
                    "A post-war circuit kept close to its original form, best known now for historic meetings. Access is tied to the event and track-day calendar."
            ),
            website: "https://www.goodwood.com/motorsport/"),
        RacingPlace(
            id: "zandvoort", kind: .landmark, name: "Circuit Zandvoort",
            location: String(localized: "museum.zandvoort.location", defaultValue: "Zandvoort, Netherlands"),
            countryCode: "NL",
            address: "Burgemeester van Alphenstraat 108, 2041 KP Zandvoort, Netherlands",
            summary: String(
                localized: "museum.zandvoort.summary",
                defaultValue:
                    "Laid out through coastal dunes, which gives the banking and elevation their character. Reachable by train from Amsterdam on event days."
            ),
            website: "https://www.circuitzandvoort.nl/"),
        RacingPlace(
            id: "hockenheim", kind: .landmark, name: "Hockenheimring",
            location: String(localized: "museum.hockenheim.location", defaultValue: "Hockenheim, Germany"),
            countryCode: "DE",
            address: "Am Motodrom, 68766 Hockenheim, Germany",
            summary: String(
                localized: "museum.hockenheim.summary",
                defaultValue:
                    "The stadium section survives from a much longer forest layout. A motorsport museum sits at the circuit; confirm its hours separately."
            ),
            website: "https://www.hockenheimring.de/"),
        RacingPlace(
            id: "donington", kind: .landmark, name: "Donington Park",
            location: String(localized: "museum.donington.location", defaultValue: "Castle Donington, United Kingdom"),
            countryCode: "GB",
            address: "Castle Donington, Derby DE74 2RP, United Kingdom",
            summary: String(
                localized: "museum.donington.summary",
                defaultValue:
                    "A pre-war Grand Prix venue that returned to Formula One for a single wet race in 1993. Still active, with a full events calendar."
            ),
            website: "https://www.donington-park.co.uk/"),
    ]
}
