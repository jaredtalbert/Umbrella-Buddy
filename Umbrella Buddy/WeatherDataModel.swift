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
    var condition: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    var umbrellaNeeded: Bool = true
    
    func updateConditon(condition: Int) -> Bool {

        switch (condition) {

            case 0...300 :
                return true

            case 301...500 :
                return true

            case 501...600 :
                return true

            case 601...700 :
                return true

            case 701...771 :
                return false

            case 772...799 :
                return true

            case 800 :
                return false

            case 801...804 :
                return false

            case 900...903, 905...1000  :
                return true

            case 903 :
                return true

            case 904 :
                return false

            default :
                return true
        }

    }
    
    
    //This method turns a condition code into the name of the weather condition image
    
//    func updateWeatherIcon(condition: Int) -> String {
//
//        switch (condition) {
//
//            case 0...300 :
//                return "tstorm1"
//
//            case 301...500 :
//                return "light_rain"
//
//            case 501...600 :
//                return "shower3"
//
//            case 601...700 :
//                return "snow4"
//
//            case 701...771 :
//                return "fog"
//
//            case 772...799 :
//                return "tstorm3"
//
//            case 800 :
//                return "sunny"
//
//            case 801...804 :
//                return "cloudy2"
//
//            case 900...903, 905...1000  :
//                return "tstorm3"
//
//            case 903 :
//                return "snow5"
//
//            case 904 :
//                return "sunny"
//
//            default :
//                return "dunno"
//        }
//
//    }
}
