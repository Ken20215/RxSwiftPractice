//
//  ViewController.swift
//  RxSwiftFlatMapPractice
//
//  Created by *石岡顕* on 2024/09/18.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {

    @IBOutlet private weak var displayLabel: UILabel!
    @IBOutlet private weak var firstTapButton: UIButton!
    @IBOutlet private weak var secondTapButton: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ViewController {
    func bind() {
        let buttanTapA = firstTapButton.rx.tap.map { "ファーストボタンが押されました。" }
        let buttanTapB = secondTapButton.rx.tap.map { "セカンドボタンが押されました。" }
        Observable.of(buttanTapA, buttanTapB)
            .flatMap { $0 }
            .asDriver(onErrorJustReturn: "データないよ")
            .drive(displayLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
