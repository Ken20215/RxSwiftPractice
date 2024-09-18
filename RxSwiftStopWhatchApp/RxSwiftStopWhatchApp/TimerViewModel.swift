//
//  TimerViewModel.swift
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

final class TimerViewModel: TimerViewModelType, TimerViewModelInputs, TimerViewModelOutputs {
    
    var input: TimerViewModelInputs { return self }
    var output: TimerViewModelOutputs { return self }
    
    var startButton = PublishRelay<Void>()
    var stopButton = PublishRelay<Void>()
    var resetButton = PublishRelay<Void>()
    var countdownTime = BehaviorRelay<TimeInterval>(value: 0)
    
    var timerLabel: Driver<String>
    
    private let timerManager: TimerManager
    let disposeBag = DisposeBag()
    
    init() {
        timerManager = TimerManager(countdownTime: countdownTime)
        timerLabel = countdownTime
            .map { "残り \(Int($0)) 秒" }
            .asDriver(onErrorJustReturn: "Error")
        
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
                self?.countdownTime.accept(TimeInterval(self?.timerManager.displayUpdate() ?? 0))
            })
            .disposed(by: disposeBag)
    }
}
