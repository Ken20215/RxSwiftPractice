//
//  ViewModel.swift
//  RxSwiftFirstPractice
//
//  Created by *石岡顕* on 2024/08/26.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ViewModel {
    var hellorWorldObservable: Observable<String> {
        return helloSubject.asObservable()
    }
    
    private let helloSubject = PublishSubject<String>()
    
    func updateItem() {
        helloSubject.onNext("Hello World")
        helloSubject.onNext("Hello World!")
        helloSubject.onNext("Hello World!!")
        helloSubject.onCompleted()
    }
}
