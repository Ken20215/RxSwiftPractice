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

protocol ViewModelInput: AnyObject {
    var tapButton: PublishRelay<Void> { get }
    var resetButton: PublishRelay<Void> { get }
}

protocol ViewModelOutput: AnyObject {
    var tapLabel: Driver<Int> { get }
    var bannerLabel: Driver<Bool> { get }
}

protocol ViewModelType: AnyObject {
    var input: ViewModelInput { get }
    var output: ViewModelOutput { get }
}

class ViewModel: ViewModelInput, ViewModelOutput, ViewModelType {
    
    var input: ViewModelInput { return self }
    var output: ViewModelOutput { return self }
    
    
    var tapButton = PublishRelay<Void>()
    var resetButton = PublishRelay<Void>()
    
    var tapLabel: Driver<Int>
    var bannerLabel: Driver<Bool>
    
    var countNumber = BehaviorRelay<Int>(value: 0)
    var disposeBag = DisposeBag()
    
    init () {
        tapButton
            .withLatestFrom(countNumber)
            .filter { $0 < 10 }
            .map { $0 + 1 }
            .bind(to: countNumber)
            .disposed(by: disposeBag)
        
        resetButton
            .map { _ in 0 }
            .bind(to: countNumber)
            .disposed(by: disposeBag)
        
        tapLabel = countNumber
            .asDriver(onErrorJustReturn: 0)
            .distinctUntilChanged()
        
        bannerLabel = tapLabel
            .map { $0 >= 10 }
            .distinctUntilChanged()
    }
}
