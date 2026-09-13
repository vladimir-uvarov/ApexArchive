//
// ArchiveValidationError.swift
// ApexArchive
//
// Copyright © 2026 Vladimir Uvarov. All rights reserved.
//

public enum ArchiveValidationError: Error, Equatable {
    case invalidCareerSeason
    case invalidLifeStory
    case invalidCatalog
    case duplicateSourceIdentifier
    case duplicateDriver, duplicateCar, invalidDriver, invalidCar
    case orphanedAchievements, invalidFeaturedDriver, invalidSource, negativeRecord, duplicateTrack
}
