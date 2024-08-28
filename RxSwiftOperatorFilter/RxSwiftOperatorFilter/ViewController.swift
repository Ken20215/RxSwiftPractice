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
            .map { return $0.count > 10 ? String($0.prefix(10)) : $0 }
            .bind(to: nameTextFild.rx.text)
            .disposed(by: disposeBag)
        
        /*
         *** MARK: .mapの$0はストリームから来たデータで、それを対象にしてデータを変換します。
         ここはnameTextFild.rx.textからきた文字データを.mapでルールを指定してます。文字が10文字超えたらラベルを表示させてます。
         nameTextFild.rx.textのデータです。nameTextFild.rx.textはObservable<String?>型の値が自動的に返却されます。
         
         *** MARK: bindメソッドはストリームの型に応じてプロパティやメソッドにデータバインディングできます。***
         　　 例えば.mapなどStringが来たらStrig、BoolならBoolの値をデータバインディングする。
         */
        
        /*
         一般的な流れとしては、以下のようになります：
            Observable: 最初に観測対象となるストリーム（例えば、テキストフィールドのテキストなど）を取得します。
                 .map : ストリームのデータを変換します。
            .bind(to:): 変換されたデータをプロパティやメソッドにバインドします。
         */
        nameTextFild.rx.text
            .map { $0?.count ?? 0 < 10 }
            .bind(to: alertLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

