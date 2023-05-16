//
//  GeographicAtlasApp.swift
//  GeographicAtlas
//
//  Created by Жаслан Танербергенов on 12.05.2023.
//

import SwiftUI

@main
struct GeographicAtlasApp: App {
    @StateObject private var countriesVM = CountriesViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(countriesVM: CountriesViewModel())
                .environmentObject(countriesVM)
        }
    }
}
