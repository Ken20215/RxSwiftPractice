//
//  ViewModel.swift
//  RxSwiftCounterApp
//
//  Created by *石岡顕* on 2024/09/01.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct CounterVieModelInput {
    let countUpButton: Observable<Void>
    let countDownButton: Observable<Void>
    let countResetButton: Observable<Void>
}

protocol CounterViewmodelOutput {
    var counterText: Driver<String?> { get }
}

protocol CounterViewModelType {
    var outputs: CounterViewmodelOutput? { get }
    func setup(input: CounterVieModelInput)
}

class CounterRxViewModel: CounterViewModelType {
    var outputs: CounterViewmodelOutput?
    
    private let countRelay = BehaviorRelay<Int>(value: 0)
    private let initialcount = 0
    private let disposeBag = DisposeBag()
    
    init() {
        self.outputs = self
    }
    
    func setup(input: CounterVieModelInput) {
        input.countUpButton
            .subscribe( onNext: { _ in
                incrementCount()
            })
            .disposed(by: disposeBag)
        
        input.countDownButton
            .subscribe( onNext: { _ in
                decrementCount()
            })
            .disposed(by: disposeBag)
        
        input.countResetButton
            .subscribe( onNext: { _ in
                resetCount()
            })
            .disposed(by: disposeBag)
        
        func incrementCount() {
            let count = countRelay.value + 1
            countRelay.accept(count)
        }
        
        func decrementCount() {
            let count = countRelay.value - 1
            countRelay.accept(count)
        }
        
        func resetCount() {
            countRelay.accept(initialcount)
        }
    }
}

extension CounterRxViewModel: CounterViewmodelOutput {
    var counterText: Driver<String?> {
        return countRelay
            .map { "Rxパターン\($0)" }
            .asDriver(onErrorJustReturn: nil)
    }
}
