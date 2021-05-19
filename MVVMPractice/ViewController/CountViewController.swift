//
//  ViewController.swift
//  MVVMCounterApp
//
//  Created by 肥沼英里 on 2021/05/15.
//

import UIKit
import RxSwift
import RxCocoa

final class CountViewController: UIViewController {
    
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var countUpButton: UIButton!
    @IBOutlet private weak var countDownButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    
    private var viewModel: CounterViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CounterViewModel(
            input: (
                countUpTaps: countUpButton.rx.tap.asSignal(),
                countDownTaps: countDownButton.rx.tap.asSignal(),
                resetTaps:resetButton.rx.tap.asSignal()
            ))
        bindInputStream()
    }

    private func bindInputStream(){
        //counterTextを購読
        //最新のイベントを流してくれる
        viewModel.counterText
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    static func makeFromStoryboard() -> CountViewController {
        UIStoryboard(name: "CountView", bundle: nil).instantiateInitialViewController() as! CountViewController
    }
}

