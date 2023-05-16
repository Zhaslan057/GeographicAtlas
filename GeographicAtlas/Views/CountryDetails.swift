//
//  CountriesItem.swift
//  GeographicAtlas
//
//  Created by Жаслан Танербергенов on 12.05.2023.
//

import SwiftUI

struct CountryDetails: View {
    let country: Country
    @State private var isCoordinateTapped = false
    @ObservedObject var countryDetailsVM: CountriesViewModel
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                AsyncImage(url: URL(string: country.flags.png)) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "photo")
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "exclamationmark.icloud")
                    @unknown default:
                        Image(systemName: "questionmark")
                    }
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .frame(width: 24, height: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Region")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        Text(country.region)
                    }
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .frame(width: 24, height: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Capital")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        Text("\(country.capital?.joined(separator: ", ") ?? "N/A")")
                    }
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .frame(width: 24, height: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Capital coordinates")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        
                        let formattedCoordinates = formatCoordinates(latitude: country.latitudeAndLongitude[0], longitude: country.latitudeAndLongitude[1])
                        Text("\(formattedCoordinates)")
                    }
                    Spacer()
                }
                .onTapGesture {
                    if let url = URL(string: "\(country.maps.openStreetMaps)") {
                        UIApplication.shared.open(url)
                    }
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .frame(width: 24, height: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Population")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        if country.population > 1000000 {
                            Text("\(country.population.formattedForDisplay) mln")
                        } else {
                            Text("\(country.population)")
                        }
                    }
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .frame(width: 24, height: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Area")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        Text("\(country.area.formatted()) km²")
                    }
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .frame(width: 24, height: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Currency")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        if let currencies = country.currencies {
                            LazyVStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(currencies.values), id: \.name) { currency in
                                    HStack {
                                        Text("\(currency.name)")
                                        Text("(\(currency.symbol ?? ""))")
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .frame(width: 24, height: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Timezones")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        Text("\(country.timezones.joined(separator: ", "))")
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
        }
        .navigationTitle(country.name.common)
        .navigationBarBackButtonHidden(true)
        .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            CustomBackButton()
                        }
                    }
        .task {
            if let fetchedCountry = await countryDetailsVM.fetchCountry(by: country.cca2) {
                countryDetailsVM.country = fetchedCountry
            }
        }
        .onAppear {
            countryDetailsVM.country = country
        }
    }
}

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
            }
        }
    }
}


struct CountryDetails_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetails(country: exampleData, countryDetailsVM: CountriesViewModel())
    }
}
