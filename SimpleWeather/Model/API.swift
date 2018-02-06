//
//  Network.swift
//  SimpleWeather
//
//  Created by Simone Grant on 2/6/18.
//  Copyright © 2018 Simone Grant. All rights reserved.
//

import Foundation

struct API {
    static let baseURL = "http://api.openweathermap.org/data/2.5/weather"
    static let app_ID = valueForAPIKey("CLIENT_ID")
}
