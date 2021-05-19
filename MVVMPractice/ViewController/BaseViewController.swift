//
//  BaseViewController.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/17.
//

import UIKit
import RxSwift
import RxCocoa

final class BaseViewController: UIViewController {

    @IBOutlet private weak var countAppButton: UIButton!
    @IBOutlet private weak var githubSearchButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        show()
    }
    
    private func show() {
        //画面遷移
        countAppButton.rx.tap
            .asSignal()
            .emit (onNext: { _ in
                Router.shared.showCountApp(from: self)
            }).disposed(by: disposeBag)

        githubSearchButton.rx.tap
            .asSignal()
            .emit(onNext: {_ in
                Router.shared.showGithubSearchView(from: self)
            }).disposed(by: disposeBag)
    }
    
    static func makeFromStoryboard()->BaseViewController {
        UIStoryboard(name: "BaseView", bundle: nil).instantiateInitialViewController() as! BaseViewController
    }
}
