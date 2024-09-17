//
//  ViewController.swift
//  RxSwiftNextPractice
//
//  Created by *石岡顕* on 2024/08/27.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet private weak var hogeButton: UIButton!
    @IBOutlet private weak var fooButton: UIButton!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ViewController {
    func bind() {
        /*
         *** MARK: ObservableとObserverの違いについて ***
         イベント発生元がObservableで、イベントの処理を行うのがObserverです。
         */
        hogeButton.rx.tap // Observable（イベントの発生元）
            .subscribe(onNext: {
                print("hogeButtonのsubscribe発火☀️") // Observer（イベントの処理）
            })
        /* 
         *** MARK: disposedの役割について ***
         ここでは購買をやめる手続きを行います。一度始めた購入を止め、不要なものを処分する手続きです。
         もう少しイメージを膨らますと、欲しい物を購入する際に「もういらないのでお会計をする」ようなイメージです。
         */
            .disposed(by: disposeBag)
        
        fooButton.rx.tap // Observable（イベントの発生元）
            .subscribe(onNext: {
                print("fooButtonのsubscribe発火☔️") // Observer（イベントの処理）
            })
            .disposed(by: disposeBag)
    }
}
