//
//  WeatherData.swift
//  Clima
//
//  Created by Aavhan Chatse on 29/08/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String?
    let weather: [Weather]
    let main: Main
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
