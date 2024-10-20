//
//  WeatherModel.swift
//  Clima
//
//  Created by Aavhan Chatse on 30/08/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    var conditionId: Int
    var cityName: String
    var temprature: Double

    var temperatureString: String {
        return String(format: "%.1f", temprature)
    }

    var conditionName: String {
        switch conditionId {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
        }
    }
}
