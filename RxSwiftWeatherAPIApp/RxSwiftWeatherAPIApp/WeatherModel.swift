//
//  WeatherModel.swift
//  RxSwiftWeatherAPIApp
//
//  Created by *石岡顕* on 2024/09/20.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift

// 天気情報の構造体
struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let rain: Rain?
}

// 気温、気圧、湿度に関する情報
struct Main: Codable {
    let temp: Double
    let pressure: Double?
    let humidity: Double?
}

// 天気に関する情報
struct Weather: Codable {
    let description: String
}

// 降水量に関する情報
struct Rain: Codable {
    let oneHour: Double? // 1時間あたりの降水量
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}
