//
//  ViewController.swift
//  RxSwiftCounterSecondApp
//
//  Created by *石岡顕* on 2024/09/04.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CounterViewController: UIViewController {
    
    @IBOutlet private weak var countUpButton: UIButton!
    @IBOutlet private weak var countDownButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var countLabel: UILabel!
    let viewModel = counterViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension CounterViewController {
    func bind() {
        countUpButton.rx.tap
            .bind(to: viewModel.input.counterUpButton)
            .disposed(by: disposeBag)
        
        countDownButton.rx.tap
            .bind(to: viewModel.input.counterDowenButton)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .bind(to: viewModel.input.resetButton)
            .disposed(by: disposeBag)
        
        viewModel.output.counterLabel
            .map { String($0) }
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
