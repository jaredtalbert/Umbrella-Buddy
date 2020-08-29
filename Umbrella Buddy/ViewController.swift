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
    @IBOutlet weak var needUmbrellaTaglineLabel: UILabel!
    @IBOutlet weak var needUmbrellaLabel: UILabel!
    
    let constants = Constants()
    
    
    let owm_url = "https://api.openweathermap.org/data/2.5/weather"
    let owm_app_id = "c47460de6ec07691f888b3f46c96bc4a"
    
    // DarkSky api info
    
    let darkSkyBaseURL = "https://api.darksky.net/forecast/a2b2ac4bc8a8aa8490212ceff0d64169/"
    
    
    
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
    
    // MARK: Network Things
    
    // TODO: exclude unwanted data
    func getWeatherData(url: String, parameters: [String]) { // grab weather from Dark Sky API
        
        let darkSkyParametizedURL = "\(url)\(parameters[0]),\(parameters[1])"
        
        Alamofire.request(darkSkyParametizedURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess {
                
                let weatherJSON: JSON = JSON(response.result.value!)
                
                self.updateWeatherData(json: weatherJSON)
                
                print("DEBUG - Success! Got weather data from Dark Sky")
//                print(weatherJSON)
            }
            
        }
        
    }
    
    // TODO: check within next 8 hours if rain will be present
    // using the data received from weather API, update app info
    func updateWeatherData(json: JSON) {
        
        if let currentTemparature = json["currently"]["temperature"].double { // if we receive a valid temperature, we know we have valid data
            print("DEBUG - Received valid data from Dark Sky")
            
            
            // TODO: change this to check precipIntensity then use precipType
            weatherDataModel.condition = json["currently"]["icon"].string!
            
            weatherDataModel.umbrellaNeeded = weatherDataModel.updateConditon(condition: weatherDataModel.condition) // realistically, probably could just condense this into the function
            
            updateUI()
            
        } else {
            print("DEBUG - Did not receive valid data from Dark Sky")
            cityNameLabel.text = "Weather Unavailable"
            needUmbrellaTaglineLabel.text = "Weather Unavailable"
        }
        
    }
    
    func updateUI() {
        cityNameLabel.text = "\(weatherDataModel.city)"
        needUmbrellaTaglineLabel.text = weatherVocalization.giveVocalization(isUmbrellaNeeded: weatherDataModel.umbrellaNeeded)
        
        needUmbrellaLabel.text = weatherDataModel.umbrellaNeeded ? "YES" : "NO" // changes umbrella needed label text depending on status of umbrellaNeeded bool value
        
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
            
//            let locationParameters: [String: String] = ["lat": latitude, "lon": longitude, "appid": app_id]
            
            let locationParameters: [String] = [latitude, longitude]
            
            getWeatherData(url: darkSkyBaseURL, parameters: locationParameters)
            getCityName(passedLocation: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityNameLabel.text = "Location Unavailable"
    }
    
    func getCityName(passedLocation: CLLocation) {
    
        let geocoder = CLGeocoder()
        let location = passedLocation
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            placemarks?.forEach { (placemark) in

                if let city = placemark.locality {
                    self.weatherDataModel.city = city
                }
            }
        })
    }
}

