//
//  ViewModel.swift
//  RxSwiftCounterApp
//
//  Created by *石岡顕* on 2024/09/01.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/*
 *** MARK: CounterVieModelInputはカウンターボタンの入力を管理する構造体です。 ***
 例えるならリモンコンとリモコンに登録されているチャンネルです。
 CounterVieModelInputというリモコンの中に、カウンターをup、douwn、resetするボタンが配置されているイメージです。
 テレビのリモコンと同様に配置したボタンを押すことで、テレビの画面の動作が変わるように、ここでもObservableによってボタンイベントを発火させる。
 */
protocol CounterVieModelInput: AnyObject {
    var countUpButton: PublishRelay<Void> { get }
    var countDownButton: PublishRelay<Void> { get }
    var countResetButton: PublishRelay<Void> { get }
}

/*
 *** MARK: DriverはUIの更新に使用する際に利用し、エラーを発生させず常に最新の状態を安全にメインスレッドに届けます。***
 Driverの概念は信号機やバス時刻表の概念に似てます。常に最新のデータ状況を届けることができます。
 そしてエラーとはnilの状態です。エラーを発生させず常に最新の状態を保つということは、バス停で例えるとバスが遅延し中々到着しない場合に「遅延してます」と電光掲示板のディスプレイに表示させます。
 エラーを発生させないとは実際にエラーを完全に発生させないという訳ではなく、「エラーが発生しても何かしらエラーを無視してデータを常に送り続けることができる」という意味です。
 */
protocol CounterViewmodelOutput: AnyObject {
    var counterText: Driver<Int> { get }
}

/*
 outputsはUI側への表示させるデータを纏めており、inputsはユーザーからの何かしらの動きにあたり、その動き次第で内部のデータを動かすようなイメージです。
 車で例えるとoutputsはダッシュボードのメーター類で,inputsはアクセルやハンドルなどの部品の動作に当たります。
 アクセルを踏むとメーターが動き、ブレーキを踏むとメーターが下がります。またハンドルを右に切ると右に車が動きます。
 */
protocol CounterViewModelType {
    var inputs: CounterVieModelInput { get }
    var outputs: CounterViewmodelOutput { get }
}

final class CounterRxViewModel: CounterViewModelType, CounterVieModelInput, CounterViewmodelOutput {
    
    var inputs: CounterVieModelInput { return self }
    var outputs: CounterViewmodelOutput { return self }
    
    // MARK: - Input Sources
    var countUpButton = PublishRelay<Void>()
    var countDownButton = PublishRelay<Void>()
    var countResetButton = PublishRelay<Void>()
    
    // MARK: - Outputs Sources
    /*
     *** MARK: Driverの概念 ***
     ユーザーがボタンをタップしたとき、そのアクションに応じてラベルのテキストやボタンの状態を更新する際に使います。
     UI要素の更新を安全に行いたい場合に使われます。例えば、Driverを使用してボタンの有効化/無効化を行う場合など。
     */
    var counterText: Driver<Int>
    
    /*
     ***  MARK: BehaviorRelayの概念 ***
     BehaviorRelayを使用することで常に最新の状態を確認することができる。
     天気アプリに似てます。これはアプリの初期設定が'晴れ'だったとしても、アプリを開く直前に雨が降れば即座にUI側に雨の状態を届けるメリットがあります。
     Observableとの違いはerrorやcompleteの処理を書く必要がなく、シンプルに最新のデータのみ通知させることができます。
     */
    private let countRelay = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    init() {
        countUpButton
            .withLatestFrom(countRelay)
            .map { $0 + 1 }
            .bind(to: countRelay)
            .disposed(by: disposeBag)
        
        countDownButton
            .withLatestFrom(countRelay)
            .map { $0 - 1 }
            .bind(to: countRelay)
            .disposed(by: disposeBag)
        
        countResetButton
            .map { 0 }
            .bind(to: countRelay)
            .disposed(by: disposeBag)
        
        counterText = countRelay
            .asDriver(onErrorJustReturn: 0)
            .distinctUntilChanged()
    }
    /*
     // *** MARK: bindとdriveの違い ***
     bindはObservableのメソッドdriveはDriveのメソッドです。もう少し詳細に書くとdriveはObservableの一種です。
     bind vs drive
     
     *** bind ***
     bindはUI要素に限らず、BehaviorSubjectやRelayなどにもデータをバインディングすることができる。
     API呼び出しや非同期処理の結果を扱う際にも使用でき、幅広く利用することができます。
     
     **** drive ***
     対してdriveはUI要素に特化してます。エラー処理を無視して、データを流すことができます。
     ボタンを押したらテキストやボタンなど状態を変更させ、何かしらUIの更新に向いているメソッドです。
     
     */
    
}
