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

protocol counterViewModelInput: AnyObject {
    var counterUpButton: PublishRelay<Void> { get }
    var counterDowenButton: PublishRelay<Void> { get }
    var resetButton: PublishRelay<Void> { get }
}

protocol counterViewModelOutput: AnyObject {
    var counterLabel: Driver<Int> { get }
}

protocol counterViewModelType: AnyObject {
    var input: counterViewModelInput { get }
    var output: counterViewModelOutput { get }
}

final class counterViewModel: counterViewModelInput, counterViewModelOutput, counterViewModelType {
    
    var input: counterViewModelInput { return self }
    var output: counterViewModelOutput { return self }
    
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
