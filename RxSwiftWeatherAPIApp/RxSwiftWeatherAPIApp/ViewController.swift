//
//  ViewController.swift
//  RxSwiftWeatherAPIApp
//
//  Created by *石岡顕* on 2024/09/20.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 天気データを取得して表示する例
    let weatherAPI = WeatherAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherAPI.fetchWeather(for: "950-0086") { weather in
            if let weather = weather {
                print("Location: \(weather.name)")
                print("Temperature: \(weather.main.temp)°C")
                print("Weather: \(weather.weather.first?.description ?? "No description")")
                
                if let rainAmount = weather.rain?.oneHour {
                    print("Rain in last hour: \(rainAmount) mm")
                }
            } else {
                print("Failed to fetch weather data.")
            }
        }
    }
}

