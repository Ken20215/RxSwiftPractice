//
//  ViewController.swift
//  RxSwiftBindPractice
//
//  Created by *石岡顕* on 2024/08/27.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    @IBOutlet private weak var nameTextFild: UITextField!
    @IBOutlet private weak var nameLabel: UILabel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ViewController {
    func bind() {
        nameTextFild.rx.text
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
