// Listing.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 12/10/24.
//

import Foundation
import CoreLocation
import SwiftUI

struct Listing: Identifiable, Codable, Hashable {
    let id: String
    let ownerId: String
    let ownerName: String
    let ownerImageUrl: String
    let numberOfBedrooms: Int
    let numberOfBathrooms: Int
    let numberOfGuests: Int
    let numberOfBeds: Int
    let pricePerNight: Int
    let latitude: Double
    let longitude: Double
    var imageURLs: [String]
    let address: String
    let city: String
    let state: String
    let title: String
    let rating: Double
    var features: [ListingFeatures]
    var amenities: [ListingAmenities]
    let type: ListingType
    
    var coordinates: CLLocationCoordinate2D {
        return .init(latitude: latitude, longitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId
        case ownerName
        case ownerImageUrl
        case numberOfBedrooms
        case numberOfBathrooms
        case numberOfGuests
        case numberOfBeds
        case pricePerNight
        case latitude
        case longitude
        case imageURLs
        case address
        case city
        case state
        case title
        case rating
        case features
        case amenities
        case type
    }
    
    // Encoding enums back to raw values to store in Firebase
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(ownerId, forKey: .ownerId)
        try container.encode(ownerName, forKey: .ownerName)
        try container.encode(ownerImageUrl, forKey: .ownerImageUrl)
        try container.encode(numberOfBedrooms, forKey: .numberOfBedrooms)
        try container.encode(numberOfBathrooms, forKey: .numberOfBathrooms)
        try container.encode(numberOfGuests, forKey: .numberOfGuests)
        try container.encode(numberOfBeds, forKey: .numberOfBeds)
        try container.encode(pricePerNight, forKey: .pricePerNight)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(imageURLs, forKey: .imageURLs)
        try container.encode(address, forKey: .address)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(title, forKey: .title)
        try container.encode(rating, forKey: .rating)
        
        // Encode features and amenities arrays as raw values
        let featureStrings = features.map { $0.rawValue }
        try container.encode(featureStrings, forKey: .features)
        
        let amenityStrings = amenities.map { $0.rawValue }
        try container.encode(amenityStrings, forKey: .amenities)
        
        try container.encode(type, forKey: .type)
    }
}

enum ListingFeatures: String, Codable, Identifiable, Hashable {
    case selfCheckIn = "selfCheckIn"
    case superHost = "superHost"
    
    var imageName: String {
        switch self {
        case .selfCheckIn: return "door.left.hand.open"
        case .superHost: return "medal"
        }
    }
    
    var title: String {
        switch self {
        case .selfCheckIn: return "Self check-in"
        case .superHost: return "Superhost"
        }
    }
    
    var subtitle: String {
        switch self {
        case .selfCheckIn:
            return "Check in with keypad"
        case .superHost:
            return "Superhosts are experienced, highly rated hosts who are committed to great service"
        }
    }
    
    var id: String {return self.rawValue}
}

enum ListingAmenities: String, Codable, Identifiable, Hashable {
    case pool = "pool"
    case kitchen = "kitchen"
    case wifi = "wifi"
    case laundry = "laundry"
    case tv = "tv"
    case alarmSystem = "alarmSystem"
    case office = "office"
    case balcony = "balcony"
    
    var title: String {
        switch self {
        case .pool: return "Pool"
        case .kitchen: return "Kitchen"
        case .wifi: return "Wifi"
        case .laundry: return "Laundry"
        case .tv: return "TV"
        case .alarmSystem: return "Alarm System"
        case .office: return "Office"
        case .balcony: return "Balcony"
        }
    }
    
    var imageName: String {
        switch self {
        case .pool: return "figure.pool.swim"
        case .kitchen: return "fork.knife"
        case .wifi: return "wifi"
        case .laundry: return "washer"
        case .tv: return "tv"
        case .alarmSystem: return "checkerboard.shield"
        case .office: return "pencil.and.ruler.fill"
        case .balcony: return "building"
        }
    }
    
    var id: String {return self.rawValue}
}

enum ListingType: Int, Codable, Identifiable, Hashable {
    case apartment = 0
    case house = 1
    case townHouse = 2
    case villa = 3
    case `default` = -1
    
    var description: String {
        switch self {
        case .apartment: return "Apartment"
        case .house: return "House"
        case .townHouse: return "Town House"
        case .villa: return "Villa"
        case .default: return "Default" // Handle the default case
        }
    }
    
    var id: Int {return self.rawValue}
}

