//
//  APIKeys.swift
//  SimpleWeather
//
//  Created by Simone Grant on 2/6/18.
//  Copyright © 2018 Simone Grant. All rights reserved.
//

import Foundation

func valueForAPIKey(_ keyname: String) -> String {
    let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile: filePath!)
    let value: String = plist?.object(forKey: keyname) as! String
    return value
}
