//
//  ViewController.swift
//  RxSwiftWeatherAPIApp
//
//  Created by *石岡顕* on 2024/09/20.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet private weak var weatherLabel: UILabel!
    @IBOutlet private weak var weatherTextField: UITextField!
    @IBOutlet private weak var tapButton: UIButton!
    private let viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ViewController {
    func bind() {
        // `weatherTextField`のテキストを`viewModel`の`textField`にバインド
        weatherTextField.rx.text.orEmpty
            .bind(to: viewModel.inputs.textField)
            .disposed(by: disposeBag)
        
        // ボタンタップで`viewModel`の`loadAction`を実行
        tapButton.rx.tap
            .withLatestFrom(viewModel.inputs.textField) // 最新のテキストフィールドの値を取得
            .bind(to: viewModel.loadAction.inputs) // `loadAction`の入力にバインド
            .disposed(by: disposeBag)
        
        // `viewModel`の`weatherText`を`weatherLabel`にバインド
        viewModel.outputs.weatherText
            .drive(weatherLabel.rx.text)
            .disposed(by: disposeBag)
    }
}


