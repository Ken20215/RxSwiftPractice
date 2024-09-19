//
//  ViewModel.swift
//  RxSwiftCompactMapPractice
//
//  Created by *石岡顕* on 2024/09/19.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelInputs: AnyObject {
    var inputTextFild: PublishRelay<String> { get }
    var tapButton: PublishRelay<Void> { get }
}

protocol ViewModelOutputs: AnyObject {
    var displayLabel: Driver<String> { get }
}

protocol ViewModelType: AnyObject {
    var inputs: ViewModelInputs { get }
    var outpusts: ViewModelOutputs { get }
}

class ViewModel: ViewModelInputs, ViewModelOutputs, ViewModelType {
    
    var inputs: any ViewModelInputs { return self }
    var outpusts: any ViewModelOutputs { return self }
    
    var inputTextFild = PublishRelay<String>()
    var tapButton = PublishRelay<Void>()
    
    var displayLabel: Driver<String>

    let disposeBag = DisposeBag()
    
    init() {
        displayLabel = tapButton
            .withLatestFrom(inputTextFild)
            .compactMap { text in
                // 文字列が空でなければ表示 (compactMapでnilを排除)
                return text.isEmpty ? nil : text
            }
            .asDriver(onErrorJustReturn: "")
    }
    
}
