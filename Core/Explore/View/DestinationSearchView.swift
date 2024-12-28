//
//  DestinationSearchView.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 12/7/24.
//

import SwiftUI

enum DestinationSearchOptions {
    case location
    case dates
    case guests
}

struct DestinationSearchView: View {
    @Binding var show: Bool
    @ObservedObject var viewModel: ExplorerViewModel
    
    //@State private var destination = ""
    @State private var selectedOption: DestinationSearchOptions = .location
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var numGuests = 0
    
    
    
    
    var body: some View {
        VStack {
            HStack {
                Button{
                    withAnimation(.snappy) {
                        viewModel.updtateListingsBasedLocation()
                        show.toggle()
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                if !viewModel.searchLocation.isEmpty {
                    Button("Clear") {
                        viewModel.searchLocation = ""
                        viewModel.updtateListingsBasedLocation()
                    }
                    .foregroundStyle(.black)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                if selectedOption == .location {
                    Text("Where to?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.small)
                        
                        TextField("Search destination", text: $viewModel.searchLocation)
                            .font(.subheadline)
                            .onSubmit {
                                viewModel.updtateListingsBasedLocation()
                                show.toggle()
                            }
                    }
                    .frame(height: 44)
                    .padding(.horizontal)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1.0)
                            .foregroundStyle(Color(.systemGray4))
                    }
                } else {
                    ExtractedView(title: "Where", description: "Add Destination")
                }
                
            }
            .modifier(DestinationViewModifier())
            .frame(height: selectedOption == .location ? 120 : 64)
            .onTapGesture {
                withAnimation(.snappy) { selectedOption = .location }
            }
            
            VStack(alignment: .leading) {
                if selectedOption == .dates {
                 
                       Text("When is your trip?")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack {
                            DatePicker("From", selection: $startDate,
                                       displayedComponents: .date)
                            
                            Divider()
                            
                            DatePicker("To", selection: $endDate,
                                       displayedComponents: .date)
                        }
                        .foregroundStyle(.gray)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                } else {
                    //add dates
                    ExtractedView(title: "When", description: "Add Dates")
                }
            }
            .modifier(DestinationViewModifier())
            .frame(height: selectedOption == .dates ? 180 : 64)
            .onTapGesture {
                withAnimation(.snappy) { selectedOption = .dates }
            }
        
            VStack(alignment: .leading) {
                if selectedOption == .guests {
                        Text("How many guests?")
                            .font(.title2)
                            .fontWeight(.semibold)
                    
                    Stepper {
                        Text("\(numGuests) Adults")
                    } onIncrement: {
                        numGuests += 1
                    } onDecrement: {
                        guard numGuests > 0 else {return}
                        numGuests -= 1
                    }
                } else {
                    //add guests
                    ExtractedView(title: "Who", description: "Add Guests")
                }
                    
            }
            .modifier(DestinationViewModifier())
            .frame(height: selectedOption == .guests ? 120 : 64)
            .onTapGesture {
                withAnimation(.snappy) { selectedOption = .guests }
            }
            
            Spacer()
        }
    }
}

#Preview {
    DestinationSearchView(show: .constant(false),
                          viewModel: ExplorerViewModel(service: ExploreService()))
}

//custom modifer
struct DestinationViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            .shadow(radius: 6)
        
    }
}

struct ExtractedView: View {
    let title: String
    let description: String
    
    
    var body: some View {
        VStack{
            HStack {
                Text("Who")
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Text("Add Guests")
            }
            .fontWeight(.semibold)
            .font(.subheadline)
        }
    }
}
