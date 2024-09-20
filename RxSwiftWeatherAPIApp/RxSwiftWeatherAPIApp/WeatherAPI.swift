//
//  WeatherAPI.swift
//  RxSwiftWeatherAPIApp
//
//  Created by *石岡顕* on 2024/09/20.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation

class WeatherAPI {

    // 天気データを取得する関数
    func fetchWeather(for city: String, completion: @escaping (WeatherResponse?) -> Void) {
        let apiKey = "4427c745cb0f68ef58840352e8f43ab2"
        // URLを作成
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric") else {
            completion(nil)
            return
        }
        // URLSessionを使ってリクエストを作成
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching weather data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(nil)
                return
            }
            
            // JSONデコード
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(weatherResponse)
            } catch {
                print("Error decoding weather data: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
