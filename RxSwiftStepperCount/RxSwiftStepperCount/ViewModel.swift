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

protocol StepperCountInput: AnyObject {
    var tapButton: PublishRelay<Void> { get }
    var resetButton: PublishRelay<Void> { get }
}

protocol StepperCountOutput: AnyObject {
    var tapLabel: Driver<Int> { get }
    var bannerLabel: Driver<Bool> { get }
}

protocol StepperCountType: AnyObject {
    var input: StepperCountInput { get }
    var output: StepperCountOutput { get }
}

class StepperCountViewModel: StepperCountInput, StepperCountOutput, StepperCountType {
    
    var input: StepperCountInput { return self }
    var output: StepperCountOutput { return self }
    
    
    var tapButton = PublishRelay<Void>()
    var resetButton = PublishRelay<Void>()
    
    var tapLabel: Driver<Int>
    var bannerLabel: Driver<Bool>
    
    var countNumber = BehaviorRelay<Int>(value: 0)
    var disposeBag = DisposeBag()
    
    init () {
        
        tapLabel = countNumber
            .asDriver(onErrorJustReturn: 0)
            .distinctUntilChanged()
        
        bannerLabel = tapLabel
            .map { $0 > 100 }
            .distinctUntilChanged()
            
    }
}
