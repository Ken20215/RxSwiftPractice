//
//  ViewController.swift
//  RxSwiftFirstPractice
//
//  Created by *石岡顕* on 2024/08/26.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ViewController {
    func bind() {
        viewModel.hellorWorldObservable
            .subscribe(onNext: { value in
                print("value = \(value)")
            })
            .disposed(by: disposeBag)
        viewModel.updateItem()
    }
}

