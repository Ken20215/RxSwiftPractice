//
//  ViewModel.swift
//  RxSwiftFirstPractice
//
//  Created by *石岡顕* on 2024/08/26.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ViewModel {
    /*
    Observable<String>はお店の掲示板のような存在です。
    お客はこの情報を元に商品購入して行きます。ここでは掲示板に文字（String型）が表示されています。
    */
    var hellorWorldObservable: Observable<String> {
        /*
        hellorWorldObservable変数はhelloSubject（商品）をasObservable(ショーウィンドウ)で陳列させるイメージ。
        商品情報を流すことはしますが、サブスクライバー（お客）が外部から直接操作をされたり商品に触れられたくない時に使います。
        例えるとお店の倉庫に入り勝手に商品を取られたくないようしたい時に実装します。
         */
        return helloSubject.asObservable()
    }
    /*
    helloSubjectはSubjectでString型のお店のような存在で、商品を棚に並べる役割で、この棚に商品を置いていくイメージです。
    商品を置く挙動は下の.onNextのようにHello Worldを追加する感じです。
     */
    private let helloSubject = PublishSubject<String>()
    
    /*
    実際にイベントを発行する挙動をここで登録。
     */
    func updateItem() {
        helloSubject.onNext("Hello World")
        helloSubject.onNext("Hello World!")
        helloSubject.onNext("Hello World!!")
        helloSubject.onCompleted()
    }
}
