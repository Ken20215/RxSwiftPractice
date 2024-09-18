//
//  ViewController.swift
//  RxSwiftCombineLatestPractice
//
//  Created by *石岡顕* on 2024/09/18.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var firstTextFiled: UITextField!
    @IBOutlet private weak var secondTextFild: UITextField!
    let disposeBaag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ViewController {
    func bind() {
        let firstText = firstTextFiled.rx.text.orEmpty.asObservable()
            .map { $0.filter { $0.isNumber } }  // 数字以外の文字をフィルタ
            .share(replay: 1, scope: .whileConnected)
        let secondText = secondTextFild.rx.text.orEmpty.asObservable()
            .map { $0.filter { $0.isNumber } }  // 数字以外の文字をフィルタ
            .share(replay: 1, scope: .whileConnected)
        
        firstText
            .bind(to: firstTextFiled.rx.text)
            .disposed(by: disposeBaag)
        secondText
            .bind(to: secondTextFild.rx.text)
            .disposed(by: disposeBaag)
        
        Observable.combineLatest(firstText, secondText) { text1, text2 -> String in
            let value1 = Int(text1) ?? 0
            let value2 = Int(text2) ?? 0
            return "\(value1 + value2)"
        }
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposeBaag)
    }
}

