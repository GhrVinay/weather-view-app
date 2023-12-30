//
//  WeatherData.swift
//  WeatherView
//
//  Created by Vinay, GHR on 06/11/21.
//

import Foundation

//structure which mimics fields in API response
struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}

struct Wind: Decodable {
    let speed: Double
}
