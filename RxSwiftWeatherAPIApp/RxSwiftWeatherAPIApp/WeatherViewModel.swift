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
    var textFild: PublishRelay<String>{ get }
}

protocol WeatherViewModelOutputs: AnyObject {
    var weatherText: Driver<String>{ get }
}

protocol WeatherViewModelType: AnyObject {
    var inputs: WeatherViewModelInputs { get }
    var outputs: WeatherViewModelOutputs { get }
}

class WeatherViewModel: WeatherViewModelInputs, WeatherViewModelOutputs, WeatherViewModelType {
    
    
    var inputs: any WeatherViewModelInputs { return self }
    var outputs: any WeatherViewModelOutputs { return self }
    
    var textFild = PublishRelay<String>()
    
    var weatherText: Driver<String>

    let disposeBag = DisposeBag()
    
    init() {
        weatherText = textFild
            .asDriver(onErrorJustReturn: "")
            .distinctUntilChanged()
    }
}
