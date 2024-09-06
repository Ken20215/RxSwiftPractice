//
//  TimerManager.swift
//  RxSwiftStopWhatchApp
//
//  Created by *石岡顕* on 2024/09/06.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TimerManager {
    private var timer: Timer?
    private var count: Int = 0
    private let countdownTime: BehaviorRelay<TimeInterval>
    
    // 初期化時にcountdownTimeを受け取る
    init(countdownTime: BehaviorRelay<TimeInterval>) {
        self.countdownTime = countdownTime
    }
    
    // タイマーが進行する時間を管理するObservable
    var countdownTimeObservable: Observable<TimeInterval> {
        return countdownTime.asObservable()
    }
    
    
    // タイマーを開始する処理
    func startTimer() {
        if let nowTimer = timer, nowTimer.isValid {
            return
        }
        
        // タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(timerInterrupt(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    // タイマーが1秒ごとに呼ばれる処理
    @objc private func timerInterrupt(_ timer: Timer) {
        count += 1
        let remainCount = countdownTime.value - Double(count)
        if remainCount <= 0 {
            count = 0
            // タイマー停止
            timer.invalidate()
        }
    }
    
    // タイマーを停止する処理
    func stopTimer() {
        if let nowTimer = timer, nowTimer.isValid {
            nowTimer.invalidate()
        }
    }
    
    // タイマーをリセットする処理
    func resetTimer() {
        count = 0
        countdownTime.accept(countdownTime.value) // 表示を更新
    }
    
    // タイマーの時間を設定する
    func setCountdownTime(_ time: TimeInterval) {
        countdownTime.accept(time)
    }
}

