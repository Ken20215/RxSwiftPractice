//
//  ViewModel.swift
//  RxSwiftStepperCount
//
//  Created by *石岡顕* on 2024/09/04.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelInputs: AnyObject {
    var tapButton: PublishRelay<Void> { get }
    var resetButton: PublishRelay<Void> { get }
}

protocol ViewModelOutputs: AnyObject {
    var tapCountLabel: Driver<Int> { get }
    var isBannerVisible: Driver<Bool> { get }
}

protocol ViewModelType: AnyObject {
    var input: ViewModelInputs { get }
    var output: ViewModelOutputs { get }
}

class ViewModel: ViewModelInputs, ViewModelOutputs, ViewModelType {
    
    var input: ViewModelInputs { return self }
    var output: ViewModelOutputs { return self }

    var tapButton = PublishRelay<Void>()
    var resetButton = PublishRelay<Void>()
    
    var tapCountLabel: Driver<Int>
    var isBannerVisible: Driver<Bool>
    
    var count = BehaviorRelay<Int>(value: 0)
    var disposeBag = DisposeBag()
    
    init () {
        tapButton
            .withLatestFrom(count)
            .filter { $0 < 10 }
            .map { $0 + 1 }
            .bind(to: count)
            .disposed(by: disposeBag)
        
        resetButton
            .map { _ in 0 }
            .bind(to: count)
            .disposed(by: disposeBag)
        
        tapCountLabel = count
            .asDriver(onErrorJustReturn: 0)
            .distinctUntilChanged()
        
        isBannerVisible = tapCountLabel
            .map { $0 >= 10 }
            .distinctUntilChanged()
    }
}
