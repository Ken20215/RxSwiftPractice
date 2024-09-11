//
//  TimerViewController.swift
//  RxSwiftStopWhatchApp
//
//  Created by *石岡顕* on 2024/09/05.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ActionSheetPicker_3_0

final class TimerViewController: UIViewController {
    
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var timePicker: UIPickerView!
    @IBOutlet private weak var countLabel: UILabel!
    let settingArray = [10, 20, 30, 40, 50, 60]
    let settingKey = "timer_value"
    let viewModel = TimerViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.delegate = self
        timePicker.dataSource = self
        bind(to: viewModel)
        timeSetting()
    }
}

private extension TimerViewController {
    func bind(to viewModel: TimerViewModel) {
        startButton.rx.tap
            .bind(to: viewModel.input.startButton)
            .disposed(by: disposeBag)
        
        stopButton.rx.tap
            .bind(to: viewModel.input.stopButton)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .bind(to: viewModel.input.resetButton)
            .disposed(by: disposeBag)
        
        viewModel.output.timerLabel
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    func timeSetting() {
        let settings = UserDefaults.standard
        let timerValue = settings.integer(forKey: settingKey)
        let initialTime = timerValue != 0 ? timerValue : 10
        countLabel.text = "残り\(initialTime)秒"
        viewModel.input.countdownTime.accept(TimeInterval(initialTime))
        
        for row in 0..<settingArray.count {
            if settingArray[row] == initialTime {
                timePicker.selectRow(row, inComponent: 0, animated: true)
            }
        }
    }
}

extension TimerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        UserDefaults.standard.set(selectedValue, forKey: settingKey)
        viewModel.input.countdownTime.accept(TimeInterval(selectedValue))
    }
    
}
