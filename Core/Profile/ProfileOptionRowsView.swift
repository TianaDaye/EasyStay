//
//  ProfileOptionRowsView.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 12/10/24.
//

import SwiftUI

struct ProfileOptionRowsView: View {
    let imageName: String
    let title: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageName)
                
                Text(title)
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")

            }
            
            Divider()
        }
    }
}

#Preview {
    ProfileOptionRowsView(imageName: "gear", title: "Settings")
}
