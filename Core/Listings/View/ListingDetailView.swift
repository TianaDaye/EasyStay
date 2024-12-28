// ListingDetailView.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 11/19/24.
//

import SwiftUI
import MapKit
import FirebaseFirestore

struct ListingDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var cameraPosition: MapCameraPosition
    @State private var listing: Listing? // Change to hold a listing object
    
    var listingId: String
    private var service = ExploreService()
    
    init(listingId: String) {
        self.listingId = listingId
        
        let region = MKCoordinateRegion(
            center: .rochester,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        self._cameraPosition = State(initialValue: .region(region))
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                if let listing = listing {  // Use optional binding to safely unwrap the listing
                    ListingImageCarouselView(listing: listing)
                        .frame(height: 320)
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 32, height: 32)
                            }
                            .padding(32)
                    }
                }
            }
            
            if let listing = listing {  // Only show these details if the listing is loaded
                VStack(alignment: .leading, spacing: 8) {
                    Text(listing.title)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                            Text("\(listing.rating)")
                            Text(" - ")
                            Text("15 reviews")
                                .underline()
                                .fontWeight(.semibold)
                        }
                        .font(.caption)
                        .foregroundStyle(.black)
                        
                        Text("\(listing.city), \(listing.state)")
                    }
                    .font(.caption)
                }
                .padding()
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(listing.type.description) hosted by \(listing.ownerName)")
                            .font(.headline)
                            .frame(width: 250, alignment: .leading)
                        
                        HStack(spacing: 2) {
                            Text("\(listing.numberOfGuests) guests -")
                            Text("\(listing.numberOfBedrooms) bedrooms -")
                            Text("\(listing.numberOfBeds) beds -")
                            Text("\(listing.numberOfBathrooms) baths")
                        }
                        .font(.caption)
                    }
                    .frame(width: 300, alignment: .leading)
                    
                    Spacer()
                    
                    Image(listing.ownerImageUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                }
                .padding()
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(listing.features) { feature in
                        HStack(spacing: 12) {
                            Image(systemName: feature.imageName)
                            
                            VStack(alignment: .leading) {
                                Text(feature.title)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                
                                Text(feature.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Where you will sleep")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(1 ... listing.numberOfBedrooms, id: \.self) { bedroom in
                                VStack {
                                    Image(systemName: "bed.double")
                                    Text("Bedroom \(bedroom)")
                                }
                                .frame(width: 132, height: 100)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                    .scrollTargetBehavior(.paging)
                }
                .padding()
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("What this place offers")
                        .font(.headline)
                    
                    ForEach(listing.amenities) { amenity in
                        HStack {
                            Image(systemName: amenity.imageName)
                                .frame(width: 32)
                            
                            Text(amenity.title)
                                .font(.footnote)
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Where you'll be")
                        .font(.headline)
                    
                    Map(position: $cameraPosition)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            } else {
                Text("Loading listing details...")  // Display a loading text while the listing is being fetched
            }
        }
        .onAppear {
            fetchListing()
        }
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea()
        .padding(.bottom, 64)
        .overlay(alignment: .bottom) {
            VStack {
                Divider()
                    .padding(.bottom)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("$\(listing?.pricePerNight ?? 0)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("Total before tax")
                            .font(.footnote)
                        
                        Text("Dec 2nd - 14th")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .underline()
                    }
                    Spacer()
                    
                    Button {
                        // Action for Reserve button
                    } label: {
                        Text("Reserve")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 140, height: 40)
                            .background(.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 32)
            }
            .background(.white)
        }
    }
    
    private func fetchListing() {
        // Fetch the listing details from Firestore using the listingId
        let db = Firestore.firestore()
        let listingsRef = db.collection("listings")
        
        Task {
            do {
                let document = try await listingsRef.document(listingId).getDocument()
                guard let data = document.data() else { return }
                
                let fetchedListing = Listing(
                    id: listingId,
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
                    features: [], // Populate this as necessary
                    amenities: [], // Populate this as necessary
                    type: .default // Ensure you handle this properly
                )
                
                // Update the listing state with the fetched data
                self.listing = fetchedListing
            } catch {
                print("Error fetching listing: \(error)")
            }
        }
    }
}

