//
//  ListingView.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 11/19/24.
//

import SwiftUI
import FirebaseFirestore

struct ListingView: View {
    let listingId: String
    @State private var listing: Listing?
    
    var body: some View {
        VStack(spacing: 8) {
            if let listing = listing {
                // Images
                ListingImageCarouselView(listing: listing)
                    .frame(height: 320)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // Listing details
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("\(listing.city), \(listing.state)")
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        
                        Text("2 mi away") // You can replace this with actual distance if available
                            .foregroundStyle(.gray)
                        
                        Text("Dec 2nd - 14th") // This can be dynamically updated based on the listing's availability
                            .foregroundStyle(.gray)
                        
                        HStack(spacing: 4) {
                            Text("$\(listing.pricePerNight)")
                                .fontWeight(.semibold)
                            Text("night")
                        }
                        .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    // Rating
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                        
                        Text("\(listing.rating, specifier: "%.1f")")
                    }
                    .foregroundStyle(.black)
                }
                .font(.footnote)
            } else {
                Text("Loading...")
                    .onAppear {
                        fetchListing()
                    }
            }
        }
        .padding()
    }
    
    private func fetchListing() {
        let db = Firestore.firestore()
        
        // Fetch the listing data from Firestore by its ID
        db.collection("listings").document(listingId).getDocument { document, error in
            if let error = error {
                print("Error fetching listing: \(error)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Listing not found")
                return
            }
            
            let data = document.data()
            
            // Map the Firestore data to a Listing object
            if let data = data {
                let featureEnums = (data["features"] as? [String] ?? []).compactMap {ListingFeatures(rawValue: $0)}
                let amenityEnums = (data["features"] as? [String] ?? []).compactMap {ListingAmenities(rawValue: $0)}
                
                self.listing = Listing(
                    id: document.documentID,
                    ownerId: data["ownerId"] as? String ?? "",
                    ownerName: data["ownerName"] as? String ?? "",
                    ownerImageUrl: data["ownerImageUrl"] as? String ?? "",
                    numberOfBedrooms: data["numberOfBedrooms"] as? Int ?? 0,
                    numberOfBathrooms: data["numberOfBathrooms"] as? Int ?? 0,
                    numberOfGuests: data["numberOfGuests"] as? Int ?? 0,
                    numberOfBeds: data["numberOfBeds"] as? Int ?? 0,
                    pricePerNight: data["pricePerNight"] as? Int ?? 0,
                    latitude: data["latitude"] as? Double ?? 0,
                    longitude: data["longitude"] as? Double ?? 0,
                    imageURLs: data["imageURLs"] as? [String] ?? [],
                    address: data["address"] as? String ?? "",
                    city: data["city"] as? String ?? "",
                    state: data["state"] as? String ?? "",
                    title: data["title"] as? String ?? "",
                    rating: data["rating"] as? Double ?? 0,
                    features: featureEnums,
                    amenities: amenityEnums,
                    type: ListingType(rawValue: data["type"] as? Int ?? -1) ?? .default
                )
            }
        }
    }
}

#Preview {
    ListingView(listingId: "listingID2")
}

