//
//  ViewController.swift
//  WeatherView
//
//  Created by Vinay, GHR on 05/11/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, WeatherManagerDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var weatherIcon: UIImageView!


    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!

    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }

    func updateWeather(weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weatherModel.cityName
            self.tempLabel.text = weatherModel.currentTemp
            self.descriptionLabel.text = weatherModel.description
            self.feelsLikeLabel.text = "Feels Like "+weatherModel.feelsTemp
            self.windSpeedLabel.text = "Winds at "+weatherModel.windSpeed
            self.searchTextField.text = "Enter City"
            
            self.weatherIcon.image = UIImage(systemName: weatherModel.conditionName)
                
        }
    }
    
    func failWithURLError(hasError: Bool) {
        let alert = UIAlertController(title: "Enter Valid City!", message: "Tip: remove spaces(if any) in your city name", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func getLocationPressed(_ sender: UIButton) {
        print("get location pressed")
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got location")
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.fetchWeatherData(latitude: lat, longitude: long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
}

//MARK: - TextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Enter City" {
            textField.text = ""
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.last == " " {
            if let city = textField.text?.dropLast() {
                textField.text = String(city)
            }
            
        }
        weatherManager.fetchWeatherData(city: textField.text ?? "NoCity")
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = "Enter City"
    }
}

