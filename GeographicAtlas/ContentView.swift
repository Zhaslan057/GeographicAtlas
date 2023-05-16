//
//  ContentView.swift
//  GeographicAtlas
//
//  Created by Жаслан Танербергенов on 12.05.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var countriesVM: CountriesViewModel
    
    var body: some View {
        NavigationView {
            if countriesVM.items.isEmpty {
                VStack {
                    ForEach(0..<8) {_ in
                        SkeletonView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    ForEach(Dictionary(grouping: countriesVM.items, by: { $0.region }).sorted(by: { $0.key < $1.key }), id: \.key) { region, countries in
                        Section(header:
                                    HStack {
                            Text(region)
                                .foregroundColor(.gray)
                                .font(.headline)
                                .textCase(.uppercase)
                                .padding(.leading, 16)
                            Spacer()
                        }) {
                            ForEach(countries) { country in
                                CountriesList(country: country)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            countriesVM.fetchCountries {
                countriesVM.items = countriesVM.items
            }
        }
    }
}

struct SkeletonView: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .frame(width: 82, height: 48)
                    
                VStack(alignment: .leading,spacing: 4) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                    
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                }
                Spacer()
                
                Circle()
                    .foregroundColor(.gray.opacity(0.1))
            }
            .foregroundColor(.gray.opacity(0.1))
        }
        .padding(12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("World countries")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(countriesVM: CountriesViewModel())
            .environmentObject(CountriesViewModel())
    }
}
