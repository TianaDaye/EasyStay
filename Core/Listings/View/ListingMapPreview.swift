//
//  ListingMapPreview.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 12/10/24.
//

import SwiftUI
import FirebaseFirestore

struct ListingMapPreview: View {
    @State private var listing: Listing?
    private let listingId: String
    
    // Initialize with listingId to fetch the specific listing from Firebase
    init(listingId: String) {
        self.listingId = listingId
    }
    
    var body: some View {
        VStack {
            if let listing = listing {
                // Show the images as before
                TabView {
                    ForEach(listing.imageURLs, id: \.self) { imageURL in
                        Image(imageURL)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Rectangle())
                    }
                }
                .frame(height: 200)
                .tabViewStyle(.page)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("\(listing.city), \(listing.state)")
                            .fontWeight(.semibold)
                        
                        Text("5 nights: Dec 4 - 10")
                        
                        HStack {
                            Text("$\(listing.pricePerNight)")
                                .fontWeight(.semibold)
                            Text("night")
                        }
                    }
                    
                    Spacer()
                    
                    Text("\(listing.rating, specifier: "%.1f")")
                }
                .font(.footnote)
                .padding(8)
            } else {
                // Show a loading view while fetching data
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
        .onAppear {
 
            Task {
                await fetchListing()
            }
        }
    }
    
    private func fetchListing() async {
        let db = Firestore.firestore()
        
        do {
            let document = try await db.collection("listings").document(listingId).getDocument()
            if let data = document.data() {
                // Parse the data from Firestore
                guard
                    let ownerId = data["ownerId"] as? String,
                    let ownerName = data["ownerName"] as? String,
                    let ownerImageUrl = data["ownerImageUrl"] as? String,
                    let numberOfBedrooms = data["numberOfBedrooms"] as? Int,
                    let numberOfBathrooms = data["numberOfBathrooms"] as? Int,
                    let numberOfGuests = data["numberOfGuests"] as? Int,
                    let numberOfBeds = data["numberOfBeds"] as? Int,
                    let pricePerNight = data["pricePerNight"] as? Int,
                    let latitude = data["latitude"] as? Double,
                    let longitude = data["longitude"] as? Double,
                    let imageURLs = data["imageURLs"] as? [String],
                    let address = data["address"] as? String,
                    let city = data["city"] as? String,
                    let state = data["state"] as? String,
                    let title = data["title"] as? String,
                    let rating = data["rating"] as? Double,
                    let features = data["features"] as? [String],
                    let amenities = data["amenities"] as? [String],
                    let typeRaw = data["type"] as? Int
                    //let type = ListingType(rawValue: typeRaw)
                else {
                    print("Error parsing document data")
                    return
                }
                
                let featureEnums = features.compactMap{ ListingFeatures(rawValue: $0)}
                let amenityEnums = amenities.compactMap{ ListingAmenities(rawValue: $0)}
                
                // Construct the Listing object
                self.listing = Listing(
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
                    type: ListingType(rawValue: data["type"] as? Int ?? -1) ?? .default
                )
            } else {
                print("Document does not exist")
            }
        } catch {
            print("Error fetching listing: \(error)")
        }
    }
}

struct ListingMapPreview_Previews: PreviewProvider {
    static var previews: some View {
        // Use a valid listingId from your Firestore collection
        ListingMapPreview(listingId: "listingID2")
    }
}

