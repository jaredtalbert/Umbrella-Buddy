//
//  WeatherDataModel.swift
//  Umbrella Buddy
//
//  Created by Jared Talbert on 12/17/19.
//  Copyright © 2019 Jared Talbert. All rights reserved.
//

import UIKit

class WeatherDataModel {

    //Declare your model variables here
    var temperature: Int = 0
    var condition: String = ""
    var city: String = ""
    var weatherIconName: String = ""
    var umbrellaNeeded: Bool = true
    
    func updateConditon(condition: String) -> Bool {

        switch (condition) {
            case "rain", "sleet", "snow":
            return true

            default:
                return false
        }

    }
}
