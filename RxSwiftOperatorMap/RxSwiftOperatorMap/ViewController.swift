//
//  ViewController.swift
//  RxSwiftOperatorMap
//
//  Created by *石岡顕* on 2024/08/28.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nameTaxtFild: UITextField!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ViewController {
    func bind() {
        /*
         ここの処理を説明すると、まずテキストフィールドから入ってきた言葉を.mapを使用して特定のルールを追加し、新しくデータを生成し次に流します。
         .map内のルールは
         「テキストフィールドに入った文字（text）をアンラップし、値があればtextの文字をカウントするcountメソッドで数えて "あと\(text.count)文字"の文章を返却する。」です。
         その返却された文字データをbindでLabelにデータバインディングし、モニターに表示をさせます。
         */
        nameTaxtFild.rx.text
            .map { text -> String? in
                guard let text = text else { return nil }
                return "あと\(text.count)文字"
            }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
