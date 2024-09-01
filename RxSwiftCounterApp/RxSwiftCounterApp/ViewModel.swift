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
struct CounterVieModelInput {
    let countUpButton: Observable<Void>
    let countDownButton: Observable<Void>
    let countResetButton: Observable<Void>
}

/*
 *** MARK: DriverはUIの更新に使用する際に利用し、エラーを発生させず常に最新の状態を安全にメインスレッドに届けます。***
     Driverの概念は信号機やバス時刻表の概念に似てます。常に最新のデータ状況を届けることができます。
     そしてエラーとはnilの状態です。エラーを発生させず常に最新の状態を保つということは、バス停で例えるとバスが遅延し中々到着しない場合に「遅延してます」と電光掲示板のディスプレイに表示させます。
     エラーを発生させないとは実際にエラーを完全に発生させないという訳ではなく、「エラーが発生しても何かしらエラーを無視してデータを常に送り続けることができる」という意味です。
 */
protocol CounterViewmodelOutput {
    var counterText: Driver<String?> { get }
}

/*
 outputsはUI側への表示させるデータを纏めており、inputsはユーザーからの何かしらの動きにあたり、その動き次第で内部のデータを動かすようなイメージです。
 車で例えるとoutputsはダッシュボードのメーター類で,inputsはアクセルやハンドルなどの部品の動作に当たります。
 アクセルを踏むとメーターが動き、ブレーキを踏むとメーターが下がります。またハンドルを右に切ると右に車が動きます。
 */
protocol CounterViewModelType {
    var outputs: CounterViewmodelOutput? { get }
    func setup(input: CounterVieModelInput)
}

class CounterRxViewModel: CounterViewModelType {
    var outputs: CounterViewmodelOutput?
    
    /*
     ***  MARK: BehaviorRelayを使用することで常に最新の状態を確認することができる。 ***
          天気アプリに似てます。これはアプリの初期設定が'晴れ'だったとしても、アプリを開く直前に雨が降れば即座にUI側に雨の状態を届けるメリットがあります。
          Observableとの違いはerrorやcompleteの処理を書く必要がなく、シンプルに最新のデータのみ通知させることができます。
     */
    private let countRelay = BehaviorRelay<Int>(value: 0)
    private let initialcount = 0
    private let disposeBag = DisposeBag()
    
    init() {
        self.outputs = self
    }
    
    func setup(input: CounterVieModelInput) {
        input.countUpButton
            .subscribe( onNext: { _ in
                incrementCount()
            })
            .disposed(by: disposeBag)
        
        input.countDownButton
            .subscribe( onNext: { _ in
                decrementCount()
            })
            .disposed(by: disposeBag)
        
        input.countResetButton
            .subscribe( onNext: { _ in
                resetCount()
            })
            .disposed(by: disposeBag)
        
        func incrementCount() {
            let count = countRelay.value + 1
            countRelay.accept(count)
        }
        
        func decrementCount() {
            let count = countRelay.value - 1
            countRelay.accept(count)
        }
        
        func resetCount() {
            countRelay.accept(initialcount)
        }
    }
}

extension CounterRxViewModel: CounterViewmodelOutput {
    /*
     処理の流れは、Driver<String?>で定義しているcounterTextにデータを入れ込みます。
     DriverはUIをエラーを発生させず、常に最新の状態を届けます。Strig型の最新の値をUI側に流します。
     countRelayはInt型ですので、.mapでブロック内の「"Rxパターン\($0)"」というStrig型の文字列を返却します。
     そしてこれがStrig型のデータですので、asDriverでDriver型に変換し、counterTextにデータを流します。
    *** MARK: bindとの違い ***
     bindと違うのは、bindは実際にUI側でデータを入れるものです。これはあくまでUIバインディングに適した値に変換するためだけに使用されます。
     */
    var counterText: Driver<String?> {
        return countRelay
            .map { "Rxパターン\($0)" }
            .asDriver(onErrorJustReturn: nil)
    }
}
