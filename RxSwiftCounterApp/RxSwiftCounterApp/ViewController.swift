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
        bind()
    }
}

extension ViewController {
    func bind() {
        countUpButton.rx.tap
            .bind(to: viewModel.inputs.countUpButton)
            .disposed(by: disposeBag)
        
        countDownButton.rx.tap
            .bind(to: viewModel.inputs.countDownButton)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .bind(to: viewModel.inputs.countResetButton)
            .disposed(by: disposeBag)
        
        viewModel.outputs.counterText
            .map { String($0) }
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
