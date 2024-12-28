// ExploreView.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 11/19/24.
//

import SwiftUI

struct ExploreView: View {
    @State private var showDestinationSearchView = false
    @StateObject var viewModel = ExplorerViewModel(service: ExploreService())
    @State private var showMapView = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Your main content
                if showDestinationSearchView {
                    DestinationSearchView(show: $showDestinationSearchView, viewModel: viewModel)
                } else {
                    ScrollView {
                        // Search bar
                        SearchBar(location: $viewModel.searchLocation)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    showDestinationSearchView.toggle()
                                }
                            }
                        
                        // Show listings only when they are fetched
                        if viewModel.listings.isEmpty {
                            // Show a loading indicator if listings are not yet fetched
                            AnyView(
                                ProgressView("Loading listings...")
                                    .progressViewStyle(CircularProgressViewStyle())
                            )
                        } else {
                            AnyView(
                                LazyVStack(spacing: 32) {
                                    ForEach(viewModel.listings) { listing in
                                        // Pass the listing.id (String) to NavigationLink
                                        NavigationLink(value: listing.id) {
                                            ListingView(listingId: listing.id)
                                                .frame(height: 400)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                } // LazyVStack
                            )
                        }
                    } // ScrollView
                    
                    .navigationDestination(for: String.self) { listingId in
                        ListingDetailView(listingId: listingId)
                            .navigationBarBackButtonHidden(false)
                    }
                }

                Button {
                    showMapView.toggle()
                } label: {
                    HStack {
                        Text("Map")
                        Image(systemName: "paperplane")
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color.black)
                    .clipShape(Capsule())
                    .padding()
                }
            }
            .sheet(isPresented: $showMapView) {
                // Pass listingIds (Strings) instead of full listings
                ListingMapView(listingIds: viewModel.listings.map { $0.id })
            }
        }
    } // NavigationStack
}

#Preview {
    ExploreView()
}
