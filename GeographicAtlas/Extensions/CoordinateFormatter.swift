//
//  CoordinateFormatter.swift
//  GeographicAtlas
//
//  Created by Жаслан Танербергенов on 16.05.2023.
//

import Foundation

func formatCoordinates(latitude: Double, longitude: Double) -> String {
    func formatCoordinate(coordinate: Double) -> String {
        let degrees = Int(coordinate)
        let minutes = Int((coordinate - Double(degrees)) * 60)
        return "\(degrees)°\(minutes)′"
    }
    
    let latitudeString = formatCoordinate(coordinate: latitude)
    let longitudeString = formatCoordinate(coordinate: longitude)
    
    return "\(latitudeString), \(longitudeString)"
}
