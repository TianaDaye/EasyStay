//
//  WishListView.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 12/10/24.
//

import SwiftUI

struct WishListView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 32) {
             
                VStack(alignment: .leading, spacing: 4) {
                    Text("Log in to view your wishlist")
                        .font(.headline)
                    
                    Text("Create, view or edit wishlist once you've logged in")
                        .font(.footnote)
                }
                Button {
                    print("Log in")
                } label: {
                    Text("Log in")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 48)
                        .background(.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Wishlist")
        }
    }
}

#Preview {
    WishListView()
}
