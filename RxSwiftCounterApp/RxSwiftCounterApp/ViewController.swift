//
//  ViewController.swift
//  RxSwiftCounterApp
//
//  Created by *石岡顕* on 2024/08/30.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {

    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var countUpButton: UIButton!
    @IBOutlet private weak var countDownButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    private var viewModel = CounterRxViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }

    private func setupViewModel() {
        let input = CounterVieModelInput(countUpButton: countUpButton.rx.tap.asObservable(),
                                         countDownButton: countDownButton.rx.tap.asObservable(),
                                         countResetButton: resetButton.rx.tap.asObservable())
        
        viewModel.setup(input: input)
        
        viewModel.outputs?.counterText
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }

}

