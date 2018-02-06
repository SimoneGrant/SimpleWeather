//
//  APIRequestManager.swift
//  SimpleWeather
//
//  Created by Simone Grant on 2/6/18.
//  Copyright © 2018 Simone Grant. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIRequestManager {
    static let manager = APIRequestManager()
    private init () {}

    func getData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("Got weather data")
                guard let weatherData: JSON = JSON(response.result.value!) else { return }
            } else {
                print("Error on response", response.result.error!)
            }
        }
    }
}

