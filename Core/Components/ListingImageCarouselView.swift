//
//  ListingImageCarouselView.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 11/19/24.
//

import SwiftUI

struct ListingImageCarouselView: View {
    let listing: Listing
    
    var body: some View {
        TabView {
            ForEach(listing.imageURLs, id: \.self) { image in
                Image(image)
                    .resizable()
                    .scaledToFill()
            }
        }
        
        .tabViewStyle(.page)
    }
}

#Preview {
    // Example usage with static data for preview purposes
    let exampleListing = Listing(
        id: "1",
        ownerId: "1",
        ownerName: "Example Owner",
        ownerImageUrl: "example-owner-photo",
        numberOfBedrooms: 3,
        numberOfBathrooms: 2,
        numberOfGuests: 4,
        numberOfBeds: 3,
        pricePerNight: 200,
        latitude: 37.7749,
        longitude: -122.4194,
        imageURLs: ["listing-1", "listing-2", "listing-3"],
        address: "123 Example St",
        city: "Example City",
        state: "CA",
        title: "Example Listing",
        rating: 4.5,
        features: [],
        amenities: [],
        type: .house )
    
    ListingImageCarouselView(listing: exampleListing)
}
