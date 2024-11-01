//
//  WeatherViewModel.swift
//  RxSwiftWeatherAPIApp
//
//  Created by *石岡顕* on 2024/09/20.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

protocol WeatherViewModelInputs: AnyObject {
    var textField: PublishRelay<String> { get }
}

protocol WeatherViewModelOutputs: AnyObject {
    var weatherText: Driver<String> { get }
}

protocol WeatherViewModelType: AnyObject {
    var inputs: WeatherViewModelInputs { get }
    var outputs: WeatherViewModelOutputs { get }
}

class WeatherViewModel: WeatherViewModelInputs, WeatherViewModelOutputs, WeatherViewModelType {
    
    var inputs: any WeatherViewModelInputs { return self }
    var outputs: any WeatherViewModelOutputs { return self }
    
    var textField = PublishRelay<String>()
    var weatherText: Driver<String>
    
    var loadAction: Action<String, Result<WeatherResponse, Error>>
    private let weatherInputText = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
    init(jsonManagerRepository: WeatherRepositoryProtocol = WeatherAPI()) {
        
        // Actionの設定
        self.loadAction = Action { city in
            return jsonManagerRepository.getWeather(for: city).asObservable().asSingle()
        }
        
        // `weatherText`の設定
        weatherText = loadAction.elements
            .map { result in
                switch result {
                case .success(let response):
                    return "Temperature: \(response.main.temp)°C, Condition: \(response.weather.first?.description ?? "N/A")"
                case .failure(let error):
                    return "Error: \(error.localizedDescription)"
                }
            }
            .asDriver(onErrorJustReturn: "Error loading weather data")
        
        // テキストフィールドの値が更新された時に`loadAction`を実行
        textField
            .bind(onNext: { [weak self] input in
                self?.loadAction.execute(input)
            })
            .disposed(by: disposeBag)
    }
}
