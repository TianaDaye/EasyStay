import SwiftUI
import MapKit
import FirebaseFirestore

struct ListingMapView: View {
   private let listingIds: [String] // Array of listing IDs to fetch
   @State private var listings: [Listing] = [] // Array to store the fetched listings
   @State private var cameraRegion: MKCoordinateRegion // Use MKCoordinateRegion for map
   @State private var selectedListing: Listing?
   @State private var showDetails = false
   @Environment(\.dismiss) var dismiss
   
   // Initializer to accept a list of listing IDs
   init(listingIds: [String], center: CLLocationCoordinate2D = .rochester) {
       self.listingIds = listingIds
       
       self._cameraRegion = State(initialValue: MKCoordinateRegion(
           center: center,
           latitudinalMeters: 500,
           longitudinalMeters: 500
       ))
   }
   
   var body: some View {
       ZStack(alignment: .topLeading) {
           ZStack(alignment: .bottom) {
               // Map displaying the listings
               Map(coordinateRegion: $cameraRegion, annotationItems: listings) { listing in
                   MapAnnotation(coordinate: listing.coordinates) {
                       Image(systemName: "pin.circle.fill")
                           .foregroundColor(.blue)
                           .onTapGesture {
                               selectedListing = listing // Update selected listing on tap
                           }
                   }
               }
               
               // Preview of the selected listing
               if let selectedListing {
                   ListingMapPreview(listingId: selectedListing.id)
                       .onTapGesture {
                           showDetails.toggle() // Toggle details view when tapped
                       }
               }
           }
           
           // Back button to dismiss the view
           Button {
               dismiss()
           } label: {
               Image(systemName: "chevron.left")
                   .foregroundColor(.black)
                   .background(
                       Circle()
                           .fill(Color.white)
                           .frame(width: 32, height: 32)
                           .shadow(radius: 4)
                   )
                   .padding(.top, 40)
                   .padding(.leading, 32)
           }
       }
       .onAppear {
           fetchListings() // Fetch the listings when the view appears
       }
       .fullScreenCover(isPresented: $showDetails, content: {
           // Display listing details in full screen if a listing is selected
           if let selectedListing = selectedListing {
               ListingDetailView(listingId: selectedListing.id)
           }
       })
   }
   
   // Fetch listings from Firestore based on the provided listing IDs
   private func fetchListings() {
       let db = Firestore.firestore()
       let listingsRef = db.collection("listings")

       Task {
           do {
               var fetchedListings = [Listing]()

               // Fetch the documents from Firestore
               let documents = try await listingsRef.getDocuments()
               for document in documents.documents where listingIds.contains(document.documentID) {
                   let data = document.data()
                       
                   // Extract features and amenities from the Firestore document
                   let features = data["features"] as? [String] ?? []
                   let amenities = data["amenities"] as? [String] ?? []

                   // Map features and amenities to their respective enums
                   let featureEnums = features.compactMap { ListingFeatures(rawValue: $0) }
                   let amenityEnums = amenities.compactMap { ListingAmenities(rawValue: $0) }

                   // Create a Listing object from the Firestore data
                   let listing = Listing(
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
                   fetchedListings.append(listing) // Append the listing to the array
               }
               self.listings = fetchedListings // Update the listings state
           } catch {
               print("Error fetching documents: \(error)")
           }
       }
   }
}

#Preview {
   // Pass a valid list of listing IDs to preview the map with real data
   ListingMapView(listingIds: ["listing1", "listing2", "listing3"])
}
