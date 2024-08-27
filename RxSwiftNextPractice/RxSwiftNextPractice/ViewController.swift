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
        hogeButton.rx.tap
            .subscribe(onNext: {
                print("hogeButtonのsubscribe発火☀️")
            })
            .disposed(by: disposeBag)
        
        fooButton.rx.tap
            .subscribe(onNext: {
                print("fooButtonのsubscribe発火☔️")
            })
            .disposed(by: disposeBag)
    }
}
