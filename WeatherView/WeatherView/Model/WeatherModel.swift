//
//  WeatherModel.swift
//  WeatherView
//
//  Created by Vinay, GHR on 06/11/21.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let currentTemp: String
    let feelsTemp: String
    let description: String
    let windSpeed: String
    let conditionId: Int
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.min"
        case 801...804:
            return "cloud.sun"
        default:
            return "sun.max"
        }
    }
}
