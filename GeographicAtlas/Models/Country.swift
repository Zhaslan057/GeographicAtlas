//
//  Counrty.swift
//  GeographicAtlas
//
//  Created by Жаслан Танербергенов on 14.05.2023.
//

import Foundation

struct Country {

    struct Name {
        let common, official: String
    }

    struct Currency {
        let name: String
        let symbol: String?
    }

    struct Maps {
        let googleMaps, openStreetMaps: URL
    }

    struct Images {
        let png, svg: String
    }

    struct CapitalInfo  {
        let latitudeAndLongitude: [Double]?
    }

    let name: Name
    let cca2: String
    let currencies: [String: Currency]?
    let capital: [String]?
    let region: String
    let subregion: String?
    let latitudeAndLongitude: [Double]
    let area: Double
    let flag: String
    let maps: Maps
    let population: Int
    let timezones: [String]
    let continents: [String]
    let flags: Images
    let capitalInfo: CapitalInfo?
    var selectAction: (() -> Void)? = nil
    
    static func ==(lhs: Country, rhs: Country) -> Bool {
            return lhs.cca2 == rhs.cca2
        }
}

// MARK: - Decodable + Equatable

extension Country: Decodable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case name
        case cca2
        case currencies
        case capital
        case region
        case subregion
        case latitudeAndLongitude = "latlng"
        case area
        case flag
        case maps
        case population
        case timezones
        case continents
        case flags
        case capitalInfo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(Country.Name.self, forKey: .name)
        cca2 = try container.decode(String.self, forKey: .cca2)
        currencies = try container.decodeIfPresent([String : Country.Currency].self, forKey: .currencies)
        capital = try container.decodeIfPresent([String].self, forKey: .capital)
        region = try container.decode(String.self, forKey: .region)
        subregion = try container.decodeIfPresent(String.self, forKey: .subregion)
        latitudeAndLongitude = try container.decode([Double].self, forKey: .latitudeAndLongitude)
        area = try container.decode(Double.self, forKey: .area)
        flag = try container.decode(String.self, forKey: .flag)
        maps = try container.decode(Country.Maps.self, forKey: .maps)
        population = try container.decode(Int.self, forKey: .population)
        timezones = try container.decode([String].self, forKey: .timezones)
        continents = try container.decode([String].self, forKey: .continents)
        flags = try container.decode(Country.Images.self, forKey: .flags)
        capitalInfo = try container.decode(Country.CapitalInfo.self, forKey: .capitalInfo)
    }
}


extension Country.CapitalInfo: Decodable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case latitudeAndLongitude = "latlng"
    }
}
extension Country.Name: Decodable, Equatable { }
extension Country.Currency: Decodable, Equatable { }
extension Country.Maps: Decodable, Equatable { }
extension Country.Images: Decodable, Equatable { }

// MARK: - Identifiable

extension Country: Identifiable {
    var id: String { name.common }
}

