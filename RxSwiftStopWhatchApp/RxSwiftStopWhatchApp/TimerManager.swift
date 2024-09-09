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

final class TimerManager {
    
    private var countdownTime: BehaviorRelay<TimeInterval>
    private var timer: Timer?
    private var count: Int = 0
    let settingKey = "timer_value"
    
    init(countdownTime: BehaviorRelay<TimeInterval>) {
        self.countdownTime = countdownTime
    }
    
    // タイマーを開始する処理
    func startTimer() {
        if let nowTimer = timer {
            if nowTimer.isValid {
                return
            }
        }
        // タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(timerInterrupt(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    // タイマーが1秒ごとに呼ばれる処理
    @objc func timerInterrupt(_ timer: Timer) {
        count += 1
        
        let remainingTime = displayUpdate()
        if remainingTime <= 0 {
            count = 0
            // タイマー停止
            timer.invalidate()
        }
        countdownTime.accept(TimeInterval(remainingTime))
    }
    
    // タイマーを停止する処理
    func stopTimer() {
        if let nowTimer = timer {
            if nowTimer.isValid {
                nowTimer.invalidate()
            }
        }
    }
    
    // タイマーをリセットする処理
    func resetTimer() {
        count = 0
        let initialValue = UserDefaults.standard.integer(forKey: settingKey)
        countdownTime.accept(TimeInterval(initialValue))
        _ = displayUpdate()
    }
    
    func displayUpdate() -> Int {
        let settings = UserDefaults.standard
        let timerValue = settings.integer(forKey: settingKey)
        let remainCount = timerValue - count
        return remainCount
    }
}

