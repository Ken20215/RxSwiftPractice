//
//  ViewController.swift
//  RxSwiftFirstPractice
//
//  Created by *石岡顕* on 2024/08/26.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension ViewController {
    func bind() {
        
        /*
        ここがSubscriber（サブスクライバー（購買者））と呼ばれており、実際に商品を購入する方々のイメージ。
        ここでは新商品が来るたびに通知され、その情報を受け取る役割があります。
         */
        viewModel.hellorWorldObservable
        
        /*
         実際にここで購入の手続きを行うイメージです。ここがいわゆるサブスクライバーと言われる挙動になります。
         手続きはonNextの他、onCompletedやonDisposedがありますが、これらは省略することが可能でonNextのみ記述でOKなものです。
         MARK: ここではObservableが新しくデータを発行し、その通知が問答無用でデータを受け取るイメージです。
         */
            .subscribe(onNext: { value in
                print("value = \(value)")
            })
            .disposed(by: disposeBag)
        
        /*
         ここではsubscribeのonNextでイベントの登録を行い、実際にイベントの発生をさせるviewModel.updateItem()を行なってます。
         これをイベントが発生する前に行なってしまうとデータを上手く取得できません。登録が先に行われ、その後にイベントが発生する必要があります。
         
         これを例えると
         ↓
         MARK: 「友達が結婚式に行かないのに招待状を送っても意味がないのに、その手順を指定しているのでおかしくね？」となってます。
         MARK: また商品を購入しないのに購入手続きをしてしまうと押売りのような形になってしまうので、システムがデータを上手く取れない現象が起きてます。
         */
        viewModel.updateItem()

    }
}

