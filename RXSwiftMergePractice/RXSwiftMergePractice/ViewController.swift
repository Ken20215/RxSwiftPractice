//
//  ViewController.swift
//  RXSwiftMergePractice
//
//  Created by *石岡顕* on 2024/09/19.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var firstButton: UIButton!
    @IBOutlet private weak var secondButton: UIButton!
    private let disposeBag = DisposeBag()
    private var count = BehaviorRelay<Int>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ViewController {
    func bind() {
        // ボタン1とボタン2のタップイベントをマージ
        let button1Tap = firstButton.rx.tap.asObservable()
        let button2Tap = secondButton.rx.tap.asObservable()
        
        // Observable.mergeを使って、ボタン1とボタン2のイベントを一つにまとめる
        Observable.merge(button1Tap, button2Tap)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                // カウントを増加
                let newCount = self.count.value + 1
                self.count.accept(newCount)
            })
            .disposed(by: disposeBag)
        
        // カウントが更新されるたびにラベルに反映
        count
            .map { "Count: \($0)" }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
