//
//  ExampleData.swift
//  GeographicAtlas
//
//  Created by Жаслан Танербергенов on 15.05.2023.
//

import Foundation

let exampleData = Country(
    name: Country.Name(
        common: "China",
        official: "People's Republic of China"),
    cca2: "CN",
    currencies: ["CNY": Country.Currency(name: "Chinese yuan", symbol: "¥"), "EUR": Country.Currency(name: "Rubliki", symbol: "R")],
    capital: ["Beijing"],
    region: "Asia",
    subregion: "China",
    latitudeAndLongitude: [39.92, 116.38],
    area: 536,
    flag: "🇨🇳",
    maps: Country.Maps(googleMaps: URL(string: "https://goo.gl/maps/p9qC6vgiFRRXzvGi7")!, openStreetMaps: URL(string: "https://goo.gl/maps/p9qC6vgiFRRXzvGi7")!),
    population: 115041264781426,
    timezones: ["GMT +6"],
    continents: ["sir"],
    flags: Country.Images(
        png: "https://flagcdn.com/w320/cn.png",
        svg: "https://flagcdn.com/cn.svg"),
    capitalInfo: Country.CapitalInfo(latitudeAndLongitude: [39.92, 116.38])
    
)
