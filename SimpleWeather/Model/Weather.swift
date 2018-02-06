//
//  Weather.swift
//  SimpleWeather
//
//  Created by Simone Grant on 2/6/18.
//  Copyright © 2018 Simone Grant. All rights reserved.
//

import Foundation

struct Weather {
    var temperature: Int = 0
    var condition: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    
    func getWeatherIcon(forWeather condition: Int) -> String {
        switch condition {
        case 0...300 :
            return "thunder"
        case 301...500 :
            return "light_rain"
        case 501...600 :
            return "showers"
        case 601...700 :
            return "snow"
        case 701...771 :
            return "fog"
        case 772...799 :
            return "strong_thunder"
        case 800 :
            return "sunny"
        case 801...804 :
            return "cloudy_day"
        case 900...903, 905...1000  :
            return "severe_thunder"
        case 903 :
            return "heavy_snow"
        case 904 :
            return "sunny"
        default :
            return "n_a"
        }
    }
    
    
}
