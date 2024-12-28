//
//  ProfileView.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 12/10/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            //profile login view
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    Text("Log in to EasyStay to start planning your next trip")
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
                
                HStack {
                    Text("Don't have an account?")
                    
                    Text("Sign up")
                        .fontWeight(.semibold)
                        .underline()
                }
                .font(.caption)
            }
             
            VStack(spacing: 24) {
                ProfileOptionRowsView(imageName: "gear", title: "Settings")
                ProfileOptionRowsView(imageName: "gear", title: "Accessibility")
                ProfileOptionRowsView(imageName: "questionmark.circle", title: "Help Center")
            }
            .padding(.vertical)
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
