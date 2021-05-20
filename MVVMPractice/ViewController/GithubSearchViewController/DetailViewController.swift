//
//  DetailViewController.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/19.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    private var viewModel: DetailViewModel!
    private let disposeBag = DisposeBag()
    
    //viewModelを外部から渡す
    func inject(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //webViewの進捗とprogressViewのprogressをbindする
        webView.rx.observe(Double.self, "estimatedProgress")
            .filterNil()
            .map{ return Float($0)}
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        //webViewのloadingをprogressViewにbind
        webView.rx.observe(Bool.self, "loading")
            .filterNil()
            .map { !$0 }
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.navigationBarTitle
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
        
        webView.load(viewModel.request)
        
    }
    
    static func makeFromStoryboard()->DetailViewController {
        UIStoryboard(name: "DetailView", bundle: nil).instantiateInitialViewController() as! DetailViewController
    }
}
