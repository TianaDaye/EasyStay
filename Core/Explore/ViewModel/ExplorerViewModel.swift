//
//  ExplorerViewModel.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 12/10/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class ExplorerViewModel: ObservableObject {
    private var service: ExploreService
    @Published var listings: [Listing] = []
    @Published var searchLocation: String = ""
    private var listingsCopy = [Listing]()
    
    init(service: ExploreService) {
        self.service = service
        fetchListings()
    }
    
    func fetchListings() {
        service.fetchListings { [weak self] listings in
            DispatchQueue.main.async {
                self?.listings = listings
                self?.listingsCopy = listings
            }
        }
    }
    
    func updtateListingsBasedLocation(){
        let filteredListings = listings.filter {
            $0.city.lowercased() == searchLocation.lowercased() ||
            $0.state.lowercased() == searchLocation.lowercased()
        }
        
        self.listings = filteredListings.isEmpty ? listingsCopy : filteredListings
    }
}






