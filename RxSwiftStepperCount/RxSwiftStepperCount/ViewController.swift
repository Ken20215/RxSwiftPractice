//
//  ViewController.swift
//  RxSwiftStepperCount
//
//  Created by *石岡顕* on 2024/09/04.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    @IBOutlet private weak var bannerlabel: UILabel!
    @IBOutlet private weak var counterlabel: UILabel!
    @IBOutlet private weak var countUpButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    let viewModel = ViewModel()
    let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ViewController {
    func bind() {
        countUpButton.rx.tap
            .bind(to: viewModel.input.tapButton)
            .disposed(by: disposedBag)
        
        resetButton.rx.tap
            .bind(to: viewModel.input.resetButton)
            .disposed(by: disposedBag)
        
        viewModel.output.tapLabel
            .map { String($0) }
            .drive(counterlabel.rx.text)
            .disposed(by: disposedBag)
        
        viewModel.output.bannerLabel
            .map { !$0 }
            .drive(bannerlabel.rx.isHidden)
            .disposed(by: disposedBag)
    }
}
