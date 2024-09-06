//
//  ViewModel.swift
//  RxSwiftStopWhatchApp
//
//  Created by *石岡顕* on 2024/09/05.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TimerViewModelInputs: AnyObject {
    var startButton: PublishRelay<Void> { get }
    var stopButton: PublishRelay<Void> { get }
    var resetButton: PublishRelay<Void> { get }
    var countdownTime: BehaviorRelay<TimeInterval> { get }
}

protocol TimerViewModelOutputs: AnyObject {
    var timerLabel: Driver<String> { get }
}

protocol TimerViewModelType: AnyObject {
    var input: TimerViewModelInputs { get }
    var output: TimerViewModelOutputs { get }
}

class TimerViewModel: TimerViewModelType, TimerViewModelInputs, TimerViewModelOutputs {
    
    var input: TimerViewModelInputs { return self }
    var output: TimerViewModelOutputs { return self }
    
    var startButton = PublishRelay<Void>()
    var stopButton = PublishRelay<Void>()
    var resetButton = PublishRelay<Void>()
    var countdownTime = BehaviorRelay<TimeInterval>(value: 0)
    
    var timerLabel: Driver<String>
    
    private let timerManager : TimerManager
    let disposeBag = DisposeBag()
    
    init() {
        // TimerManagerを初期化し、countdownTimeを渡す
        timerManager = TimerManager(countdownTime: countdownTime)
        timerLabel = Driver.empty()
        timerLabel = timerManager.countdownTimeObservable
            .map { [weak self] time in
                guard let self = self else { return "" }
                let remainCount = time - self.countdownTime.value
                return "残り \(Int(remainCount)) 秒"
            }
            .asDriver(onErrorJustReturn: "")

        // タイマーを開始する
        startButton
            .subscribe(onNext: { [weak self] in
                self?.timerManager.startTimer()
            })
            .disposed(by: disposeBag)
        
        // タイマーを停止する
        stopButton
            .subscribe(onNext: { [weak self] in
                self?.timerManager.stopTimer()
            })
            .disposed(by: disposeBag)
        
        // タイマーをリセットする
        resetButton
            .subscribe(onNext: { [weak self] in
                self?.timerManager.resetTimer()
            })
            .disposed(by: disposeBag)
    }
}
