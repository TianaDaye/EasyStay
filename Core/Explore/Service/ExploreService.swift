//
//  ExploreService.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 12/10/24.
//

import FirebaseFirestore

class ExploreService {
    private let db = Firestore.firestore()
    
    // Fetch all listings from Firestore
    func fetchListings(completion: @escaping ([Listing]) -> Void) {
        db.collection("listings").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching listings: \(error)")
                completion([])  // Return empty array in case of error
                return
            }
            
            guard let snapshot = snapshot else {
                completion([])
                return
            }
            
            var listings: [Listing] = []
            for document in snapshot.documents {
                if let listing = self.createListing(from: document) {
                    listings.append(listing)
                }
            }
            
            completion(listings)
        }
    }
    
    // Fetch a single listing by ID
    func fetchListing(byId id: String, completion: @escaping (Listing?) -> Void) {
        db.collection("listings").document(id).getDocument { document, error in
            if let error = error {
                print("Error fetching listing: \(error)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else {
                completion(nil)
                return
            }
            
            let listing = self.createListing(from: document)
            completion(listing)
        }
    }
    
    // Helper method to create a Listing object from Firestore document
    private func createListing(from document: DocumentSnapshot) -> Listing? {
        let data = document.data()
        
        // Manually extract fields from the document data
        guard
            let ownerId = data?["ownerId"] as? String,
            let ownerName = data?["ownerName"] as? String,
            let ownerImageUrl = data?["ownerImageUrl"] as? String,
            let numberOfBedrooms = data?["numberOfBedrooms"] as? Int,
            let numberOfBathrooms = data?["numberOfBathrooms"] as? Int,
            let numberOfGuests = data?["numberOfGuests"] as? Int,
            let numberOfBeds = data?["numberOfBeds"] as? Int,
            let pricePerNight = data?["pricePerNight"] as? Int,
            let latitude = data?["latitude"] as? Double,
            let longitude = data?["longitude"] as? Double,
            let imageURLs = data?["imageURLs"] as? [String],
            let address = data?["address"] as? String,
            let city = data?["city"] as? String,
            let state = data?["state"] as? String,
            let title = data?["title"] as? String,
            let rating = data?["rating"] as? Double,
            let typeRaw = data?["type"] as? Int,
            let type = ListingType(rawValue: typeRaw)
        else {
            return nil
        }
        
        // Use fallback for features and amenities
        let features = data?["features"] as? [String] ?? []
        let amenities = data?["amenities"] as? [String] ?? []

        let featureEnums = features.compactMap { ListingFeatures(rawValue: $0) }
        let amenityEnums = amenities.compactMap { ListingAmenities(rawValue: $0) }
        
        // Construct the Listing object
        return Listing(
            id: document.documentID,
            ownerId: ownerId,
            ownerName: ownerName,
            ownerImageUrl: ownerImageUrl,
            numberOfBedrooms: numberOfBedrooms,
            numberOfBathrooms: numberOfBathrooms,
            numberOfGuests: numberOfGuests,
            numberOfBeds: numberOfBeds,
            pricePerNight: pricePerNight,
            latitude: latitude,
            longitude: longitude,
            imageURLs: imageURLs,
            address: address,
            city: city,
            state: state,
            title: title,
            rating: rating,
            features: featureEnums,
            amenities: amenityEnums,
            type: type
        )
    }

}
