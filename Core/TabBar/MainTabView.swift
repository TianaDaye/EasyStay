//
//  MainTabView.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 12/10/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ExploreView()
                .tabItem{ Label("Explore", systemImage: "magnifyingglass")}
            
            WishListView()
                .tabItem{ Label("Wishlist", systemImage: "heart")}
            
            ProfileView()
                .tabItem{ Label("Profile", systemImage: "person")}
        }
    }
}

#Preview {
    MainTabView()
}
