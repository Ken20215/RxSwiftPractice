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
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var selectTimeButton: UIButton!
    
    let settingArray = [10, 20, 30, 40, 50, 60]
    let settingKey = "timer_value"
    let viewModel = TimerViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        timeSetting()
    }
}

private extension TimerViewController {
    func bind(to viewModel: TimerViewModel) {
        startButton.rx.tap
            .bind(to: viewModel.input.startButton)
            .disposed(by: disposeBag)
        
        selectTimeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showTimePicker()
            })
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
    
    func showTimePicker() {
        let alertController = UIAlertController(title: "時間を選択", message: nil, preferredStyle: .actionSheet)
        
        for time in settingArray {
            let action = UIAlertAction(title: "\(time)秒", style: .default) { [weak self] _ in
                self?.updateTimeSelection(with: time)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateTimeSelection(with time: Int) {
        countLabel.text = "残り\(time)秒"
        UserDefaults.standard.set(time, forKey: settingKey)
        viewModel.input.countdownTime.accept(TimeInterval(time))
    }
    
    func timeSetting() {
        let settings = UserDefaults.standard
        let timerValue = settings.integer(forKey: settingKey)
        let initialTime = timerValue != 0 ? timerValue : 10
        countLabel.text = "残り\(initialTime)秒"
        viewModel.input.countdownTime.accept(TimeInterval(initialTime))
    }
}
