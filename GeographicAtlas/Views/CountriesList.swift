//
//  CountriesList.swift
//  GeographicAtlas
//
//  Created by Жаслан Танербергенов on 12.05.2023.
//

import SwiftUI

struct CountriesList: View {
    @State var isExpanded = false
    @State var items: [Country] = []
    @StateObject var countriesVM = CountriesViewModel()
    var country: Country
    var body: some View {
        allCountries
            .onAppear {
                countriesVM.fetchCountries {
                    items = countriesVM.items
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if !countriesVM.items.isEmpty {
                            let randomIndex = Int.random(in: 0..<countriesVM.items.count)
                            let randomCountry = countriesVM.items[randomIndex]
                            countriesVM.scheduleNotification(with: randomCountry)
                        }
                    }
                }
            }
    }
    
    var allCountries: some View {
        VStack(spacing: 12) {
            HStack {
                AsyncImage(url: URL(string: country.flags.png)) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "photo")
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 82, height: 48)
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "exclamationmark.icloud")
                    @unknown default:
                        Image(systemName: "questionmark")
                    }
                }
                VStack(alignment: .leading,spacing: 4) {
                    Text("\(country.name.common)")
                        .font(.system(size: 17))
                    Text("\(country.capital?.joined(separator: ", ") ?? "N/A")")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            if isExpanded {
                VStack(alignment: .leading,spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Population:")
                            .foregroundColor(.gray)
                        if country.population > 1000000 {
                            Text("\(country.population.formattedForDisplay) mln")
                        } else {
                            Text("\(country.population)")
                        }
                    }
                    HStack(spacing: 4) {
                        Text("Area:")
                            .foregroundColor(.gray)
                        Text("\(country.area.formatted()) km²")
                    }
                    HStack(spacing: 4) {
                        Text("Currencies:")
                            .foregroundColor(.gray)
                        
                        if let currencies = country.currencies {
                            LazyVStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(currencies.values), id: \.name) { currency in
                                    HStack {
                                        Text("\(currency.name)") + Text("(\(currency.symbol ?? ""))")
                                    }
                                }
                            }
                        }
                    }
                    NavigationLink(destination: CountryDetails(country: country, countryDetailsVM: CountriesViewModel())) {
                        Text("Learn more")
                            .font(.system(size: 17))
                            .padding(.vertical, 14)
                    }
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        countriesVM.selectCountry(countryCode: country.cca2)
                    }
                }
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("World countries")
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        }
    }
}
