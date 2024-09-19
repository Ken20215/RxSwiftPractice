//
//  CounterViewModel.swift
//  RxSwiftCounterSecondApp
//
//  Created by *石岡顕* on 2024/09/04.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CounterViewModelInput: AnyObject {
    var counterUpButton: PublishRelay<Void> { get }
    var counterDowenButton: PublishRelay<Void> { get }
    var resetButton: PublishRelay<Void> { get }
}

protocol CounterViewModelOutput: AnyObject {
    var counterLabel: Driver<Int> { get }
}

protocol CounterViewModelType: AnyObject {
    var input: CounterViewModelInput { get }
    var output: CounterViewModelOutput { get }
}

final class CounterViewModel: CounterViewModelInput, CounterViewModelOutput, CounterViewModelType {
    
    var input: CounterViewModelInput { return self }
    var output: CounterViewModelOutput { return self }
    
    var counterUpButton = PublishRelay<Void>()
    var counterDowenButton = PublishRelay<Void>()
    var resetButton = PublishRelay<Void>()
    
    var counterLabel: Driver<Int>
    
    var counterBind = BehaviorRelay<Int>(value: 0)
    var disposeBag = DisposeBag()
    
    init() {
        counterUpButton
            .withLatestFrom(counterBind)
            .map { $0 + 1 }
            .bind(to: counterBind)
            .disposed(by: disposeBag)
        
        counterDowenButton
            .withLatestFrom(counterBind)
            .map { $0 - 1 }
            .bind(to: counterBind)
            .disposed(by: disposeBag)
        
        resetButton
            .withLatestFrom(counterBind)
            .map { _ in 0 }
            .bind(to: counterBind)
            .disposed(by: disposeBag)
        
        counterLabel = counterBind
            .asDriver(onErrorJustReturn: 0)
            .distinctUntilChanged()
    }
}
