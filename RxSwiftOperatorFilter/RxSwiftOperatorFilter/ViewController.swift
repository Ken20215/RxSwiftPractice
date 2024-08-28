//
//  ViewController.swift
//  RxSwiftOperatorFilter
//
//  Created by *石岡顕* on 2024/08/28.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet private weak var alertLabel: UILabel!
    @IBOutlet private weak var nameTextFild: UITextField!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ViewController {
    func bind() {
        alertLabel.isHidden = true
        nameTextFild.rx.text
            .orEmpty
            .map { text -> String in
                if text.count > 10 {
                    return String(text.prefix(10))
                }
                return text
            }
            .bind(to: nameTextFild.rx.text)
            .disposed(by: disposeBag)
        
        nameTextFild.rx.text
            .map { $0?.count ?? 0 < 10 }
            .bind(to: alertLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

