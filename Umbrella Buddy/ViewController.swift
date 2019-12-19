//
//  ViewController.swift
//  Umbrella Buddy
//
//  Created by Jared Talbert on 12/17/19.
//  Copyright © 2019 Jared Talbert. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var needUmbrellaLabel: UILabel!
    
    let constants = Constants()
    
    
    let weather_url = "https://api.openweathermap.org/data/2.5/weather"
    let app_id = "c47460de6ec07691f888b3f46c96bc4a"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    let weatherVocalization = WeatherVocalization()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: Networky Things
    
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("DEBUG - Success! Got weather data")
                
                let weatherJSON: JSON = JSON(response.result.value!)
                
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                
                print("DEBUG - Error: \(String(describing: response.result.error))")
                self.cityNameLabel.text = "Connection Issues"
                
            }
        }
        
    }
    
    func updateWeatherData(json: JSON) {
            if let tempResult = json["main"]["temp"].double {
                
                // convert temp to Fahrenheit and round
                let tempInFahrenheit = round(tempResult * (9/5) - 459.67)
                
    //            weatherDataModel.temperature = Int(tempResult - 273.15)
                weatherDataModel.city = json["name"].string!
                weatherDataModel.condition = json["weather"][0]["id"].intValue
                print("Weather Condition: \(weatherDataModel.condition)")
//                weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
                weatherDataModel.umbrellaNeeded = weatherDataModel.updateConditon(condition: weatherDataModel.condition)
                
                updateUI()
            } else {
                print("DEBUG - Did not receive valid data from OWM API")
                cityNameLabel.text = "Weather Unavailable"
            }
        }
    
    func updateUI() {
        cityNameLabel.text = "\(weatherDataModel.city)"
        
        if (weatherDataModel.umbrellaNeeded) {
//            needUmbrellaLabel.text = "You're probably going to need an umbrella today."
            needUmbrellaLabel.text = weatherVocalization.giveVocalization(isUmbrellaNeeded: true)
        } else {
//            needUmbrellaLabel.text = "It doesn't look like you need an umbrella."
            needUmbrellaLabel.text = weatherVocalization.giveVocalization(isUmbrellaNeeded: false)
        }
        
        print("DEBUG - UI Updated")
        
    }
    
    // MARK: Location Manager Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if (location.horizontalAccuracy > 0) {
            locationManager.stopUpdatingLocation() // we got a good location (non negative number), stop draining battery!!
            print("Longitude: \(location.coordinate.longitude)\nLatitude: \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let locationParameters: [String: String] = ["lat": latitude, "lon": longitude, "appid": app_id]
            
            getWeatherData(url: weather_url, parameters: locationParameters)
        }
    }
    
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityNameLabel.text = "Location Unavailable"
    }


}

