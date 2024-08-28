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
    }
}

extension ViewController {
    func bind() {
        
    }
}

