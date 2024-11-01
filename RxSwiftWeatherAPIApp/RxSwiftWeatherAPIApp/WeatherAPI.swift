//
//  WeatherAPI.swift
//  RxSwiftWeatherAPIApp
//
//  Created by *石岡顕* on 2024/09/20.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherRepositoryProtocol {
    func getWeather(for city: String) -> Single<Result<WeatherResponse, Error>>
}

class WeatherAPI: WeatherRepositoryProtocol {
    func getWeather(for city: String) -> Single<Result<WeatherResponse, Error>> {
        let apiKey = "4427c745cb0f68ef58840352e8f43ab2"
        
        return Single.create { single in
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric") else {
                single(.success(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))))
                print("URLの取得成功")
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                print("URLSession\(String(describing: data))です")
                if let error = error {
                    single(.success(.failure(error)))
                    return
                }
                
                guard let data = data else {
                    single(.success(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(WeatherResponse.self, from: data)
                    single(.success(.success(response)))
                } catch {
                    single(.success(.failure(error)))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
