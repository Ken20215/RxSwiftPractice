//
//  ViewController.swift
//  RxSwiftStopWhatchApp
//
//  Created by *石岡顕* on 2024/09/05.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var datePicker: UIPickerView!
    @IBOutlet private weak var countLabel: UILabel!
    let settingArray = [10, 20, 30, 40, 50, 60]
    let viewModel = TimerViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countLabel.text = "残り\(settingArray[0])秒"
        datePicker.delegate = self
        datePicker.dataSource = self
    }
}

extension ViewController {
    func bind() {
        stopButton.rx.tap
            .bind(to: viewModel.input.startButton)
            .disposed(by: disposeBag)
        
        stopButton.rx.tap
            .bind(to: viewModel.input.stopButton)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .bind(to: viewModel.input.resetButton)
            .disposed(by: disposeBag)
        
        viewModel.output.timerLabel
            .map { String($0) }
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // pickerの列を指定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // pickerの行数を指定
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return settingArray.count
    }
    // pickerの中身を表示させる内容を指定
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(settingArray[row])
    }
    // pickerの選択時に実行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = settingArray[row]
        countLabel.text = "残り\(selectedValue)秒"
    }
    
}
