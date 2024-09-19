//
//  ViewController.swift
//  RxSwiftCompactMapPractice
//
//  Created by *石岡顕* on 2024/09/19.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet private weak var displayLabel: UILabel!
    @IBOutlet private weak var inputTextFild: UITextField!
    @IBOutlet private weak var tapButton: UIButton!
    private let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    
}

extension ViewController {
    func bind() {
        inputTextFild.rx.text.orEmpty
            .bind(to: viewModel.inputs.inputTextFild)
            .disposed(by: disposeBag)
        
        tapButton.rx.tap
            .bind(to: viewModel.inputs.tapButton)
            .disposed(by: disposeBag)
        
        viewModel.outpusts.displayLabel
            .drive(displayLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

