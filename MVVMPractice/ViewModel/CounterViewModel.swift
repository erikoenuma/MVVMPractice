//
//  CounterViewModel.swift
//  MVVMCounterApp
//
//  Created by 肥沼英里 on 2021/05/15.
//

import Foundation
import RxCocoa
import RxSwift

//viewModelの出力に関するOutput
protocol CounterViewModelOutput {
    var counterText: Driver<String> { get }
}

final class CounterViewModel: CounterViewModelOutput{
    
    private let disposeBag = DisposeBag()
    //イベントの検知+イベントの発生もできるクラス Relay Subject
    private let countRelay = BehaviorRelay<Int>(value: 0)
    private let initialCount = 0
   
    /*outputについての記述*/
    //ラベル用のテキストに関するシーケンス
    //これが変化したらviewControllerに通知する
    var counterText: Driver<String> {
        let counterText = countRelay
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "failed")
        return counterText
    }
    
    init(
        input:(
            countUpTaps: Signal<Void>,
                 countDownTaps: Signal<Void>,
                 resetTaps: Signal<Void>)
    ){
        //countUpの処理内容
        let countUp = input.countUpTaps.asObservable().withLatestFrom(countRelay)
            .map{ $0+1 }
            .asSignal(onErrorJustReturn: initialCount)
        
        //countDownの処理内容
        let countDown = input.countDownTaps.asObservable().withLatestFrom(countRelay)
            .map{ $0-1 }
            .asSignal(onErrorJustReturn: initialCount)
        
        //resetの処理内容
        let reset = input.resetTaps.asObservable().withLatestFrom(countRelay)
            .map{ _ in 0 }
            .asSignal(onErrorJustReturn: initialCount)
        
        //それぞれの処理の後countRelayの値を更新する
        countUp.asObservable().bind(to: countRelay).disposed(by: disposeBag)
        countDown.asObservable().bind(to: countRelay).disposed(by: disposeBag)
        reset.asObservable().bind(to: countRelay).disposed(by: disposeBag)
    }
}
