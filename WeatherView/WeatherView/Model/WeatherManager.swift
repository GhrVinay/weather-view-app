//
//  WeatherManager.swift
//  WeatherView
//
//  Created by Vinay, GHR on 06/11/21.
//

import Foundation
import CoreLocation
import UIKit
protocol WeatherManagerDelegate {
    func updateWeather(weatherModel: WeatherModel)
    func failWithURLError(hasError: Bool)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather?appid=9fa48a7cf970fd1839c49521f8b20e78&units=metric"
    
    func fetchWeatherData(city: String) {
        let fullUrl = baseUrl+"&q=\(city)"
        print(fullUrl)
        performRequest(urlString: fullUrl)
    }
    
    func fetchWeatherData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let fullUrl = baseUrl+"&lat=\(latitude)"+"&lon=\(longitude)"
        print(fullUrl)
        performRequest(urlString: fullUrl)
    }
    
    func performRequest(urlString: String) {
        //start url session
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print(e)
                } else {
                    print("parsing JSON...")
                    if let safeData = data {
                        if let weather = parseJSON(weatherData: safeData) {
                            delegate?.updateWeather(weatherModel: weather)
                        } else {
                            print("Error updating weather")
                            let invalidWeather = WeatherModel(cityName: "N/A", currentTemp: "--", feelsTemp: "--", description: "Enter Valid City", windSpeed: "--", conditionId: 0)
                            delegate?.updateWeather(weatherModel: invalidWeather)
                        }
                        
                    }
                }
            }
            task.resume()
            print("Session Started!")
        } else {
            print("URL error::",Error.self)
            delegate?.failWithURLError(hasError: true)
        }
        
        
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let city = decodedData.name
            let temp = String(format: "%.1f°C",decodedData.main.temp)
            let temp2 = String(format: "%.1f°C", decodedData.main.feels_like)
            var description = decodedData.weather[0].description
            description = description.capitalizingFirstLetter()
            let wind = String(format: "%.2f kmph",decodedData.wind.speed * 3.6)
            let iconId = decodedData.weather[0].id
            
            let weatherModel = WeatherModel(cityName: city, currentTemp: temp, feelsTemp: temp2, description: description, windSpeed: wind, conditionId: iconId)
            return weatherModel
        } catch {
            print(error)
            return nil
        }
        
        
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
