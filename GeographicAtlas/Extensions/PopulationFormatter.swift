//
//  DateFormatter.swift
//  GeographicAtlas
//
//  Created by Жаслан Танербергенов on 15.05.2023.
//

import Foundation

let displayFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 1
    formatter.multiplier = 0.000001
    return formatter
}()

extension Int {
    var formattedForDisplay: String {
        displayFormatter.string(from: self as NSNumber) ?? ""
    }

}
