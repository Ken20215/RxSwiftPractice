//
//  WeatherModel.swift
//  RxSwiftWeatherAPIApp
//
//  Created by *石岡顕* on 2024/09/20.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation

// 天気情報の構造体
struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let rain: Rain?
    
    struct Main: Codable {
        let temp: Double
        let pressure: Double?
        let humidity: Double?
    }
    
    struct Weather: Codable {
        let description: String
    }

    struct Rain: Codable {
        let oneHour: Double? // 1時間あたりの降水量
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }
}
