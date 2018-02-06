//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Simone Grant on 2/6/18.
//  Copyright © 2018 Simone Grant. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var weatherBlurb: UILabel!
    @IBOutlet weak var weatherDetailsLabel: UILabel!
    let locationManager = CLLocationManager()
    var weather = Weather()
    var weatherDict = ["thunder": "greased lightning", "light_rain": "drizzle", "showers": "pouring", "snow": "snow", "fog": "haze", "strong_thunder": "thunderbolt", "sunny": "gorgeous", "cloudy_day": "overcast", "severe_thunder": "thunderstruck", "heavy_snow": "snowed under"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
    }
    
    //MARK: - Setup
    
    func setupDelegates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters //best for weather map
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        searchBar.delegate = self
    }
    
    //MARK: - Alamofire Networking
    
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(API.baseURL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("Success! Got the weather data.")
                let weatherData: JSON = JSON(response.result.value!)
                self.updateWeather(json: weatherData)
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    //MARK: - SwiftyJSON Parsing
    
    func updateWeather(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            //temp is in kelvins
            weather.temperature = Int(tempResult * 9/5 - 459.67)
            let low = json["main"]["temp_min"].doubleValue
            let high = json["main"]["temp_max"].doubleValue
            weather.low = Int(low * 9/5 - 459.67)
            weather.high = Int(high * 9/5 - 459.67)
            weather.city = json["name"].stringValue
            weather.condition = json["weather"][0]["id"].intValue
            weather.weatherIconName = weather.getWeatherIcon(forWeather: weather.condition)
            //update the UI
            updateUIWithWeather()
            print("This is the temp result", tempResult)
        } else {
            print("Could not get weather")
            weatherBlurb.text = "Weather Unavailable"
        }
    }
    
    //MARK: CLLocation Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation() 
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            let latitude = "\(location.coordinate.latitude)"
            let longitude = "\(location.coordinate.longitude)"
            let params: [String:String] = ["lat": latitude, "lon": longitude, "appid": API.app_ID]
            
            getWeatherData(url: API.baseURL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        weatherBlurb.text = "Location Unavailable"
    }
    
    //MARK: - Change City
    func userSearchedForNewLocation(_ city: String) {
        let params: [String: String] = ["q": city, "appid": API.app_ID]
        getWeatherData(url: API.baseURL, parameters: params)
    }
    
    
    //MARK: - Update UI
    
    func updateUIWithWeather() {
        weatherIconView.image = UIImage(named: weather.weatherIconName)
        weatherDetailsLabel.text = "\(weather.temperature)°  L \(weather.low)°  H \(weather.high)°"
        weatherBlurb.text = weatherDict[weather.weatherIconName]
    }
}

extension ViewController: UISearchBarDelegate   {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            userSearchedForNewLocation(searchBar.text!)
            searchBar.text = ""
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
//            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
