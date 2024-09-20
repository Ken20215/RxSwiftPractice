//
//  ViewModel.swift
//  RxSwiftCompactMapPractice
//
//  Created by *石岡顕* on 2024/09/19.
//  Copyright (c) 2024 *ReNKCHANNEL*. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelInputs: AnyObject {
    var inputTextFild: PublishRelay<String> { get }
    var tapButton: PublishRelay<Void> { get }
}

protocol ViewModelOutputs: AnyObject {
    var displayLabel: Driver<String> { get }
}

protocol ViewModelType: AnyObject {
    var inputs: ViewModelInputs { get }
    var outpusts: ViewModelOutputs { get }
}

class ViewModel: ViewModelInputs, ViewModelOutputs, ViewModelType {
    
    var inputs: any ViewModelInputs { return self }
    var outpusts: any ViewModelOutputs { return self }
    
    var inputTextFild = PublishRelay<String>()
    var tapButton = PublishRelay<Void>()
    
    var displayLabel: Driver<String>

    let disposeBag = DisposeBag()
    
    init() {
        /*
         MARK: filterとcompactMapの違い。
         ***明確に違う箇所***
         　　 filter ⇨ 各要素に対して条件が合うものだけを通過させて要素の型変換など行えない。
         compactMap ⇨ 各要素に対して条件が合うものを通過させて要素の型変換を行い返却する。
         

         ***nilの扱い方***
             filter ⇨ nilを扱うことができない。Observable＜Strign？＞のようなnilを含む可能性のあるデータストリームは扱えない。
         compactMap ⇨ nilが来た場合は削除することができる。nilを除去し、フィルターを通った値をStrignやIntなどに変換することができる。
         
         使い分けとしては、nilがありそうな場合はアンラップを行なってからfilterを使用するか、そのままcompactMapを利用して型変換を行う。
         */
        displayLabel = tapButton
            .withLatestFrom(inputTextFild)
            .compactMap { text in
                // 文字列が空でなければ表示 (compactMapでnilを排除)
                return text.isEmpty ? nil : text
            }
            .asDriver(onErrorJustReturn: "")
    }
    
}
