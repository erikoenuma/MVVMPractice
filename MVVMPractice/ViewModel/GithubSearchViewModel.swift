//
//  WebKitViewModel.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/18.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

protocol GithubSearchViewModelInput {
    //Input: searchBar.textに何か入力されたよ
    var searchTextObserver: AnyObserver<String?> { get }
}

protocol GithubSearchViewModelOutput {
    //Output: githubRepositoryの中身が変更された通知、中身
    var repositoryChanged: Observable<Void> { get }
    var repositories: [items] { get }
}

final class GithubSearchViewModel: GithubSearchViewModelInput, GithubSearchViewModelOutput {
    
    private let disposeBag = DisposeBag()
    /*Inputに関する記述*/
    private let _searchText = PublishRelay<String?>()
    lazy var searchTextObserver: AnyObserver<String?> = .init { event in
        guard let element = event.element else { return }
        self._searchText.accept(element)
    }
    
    /*Outputに関する記述*/
    private let _repositoryChanged = PublishRelay<Void>()
    lazy var repositoryChanged: Observable<Void> = _repositoryChanged.asObservable()
    
    private (set) var repositories: [items] = []
    
    init() {
        
        let apiRequest: Observable<Void> = _searchText
            //0.5秒新たなイベントが発行されなくなってから最後に発行されたイベントを使用する
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            //流れてくる値が前回と違う時のみイベントを流す
            .distinctUntilChanged()
            //アンラップ
            .filterNil()
            .filter{ $0.isNotEmpty }
            .flatMapLatest { searchText in
            GithubApiModel.shared.rx.request(searchWord: searchText)
                .map { [weak self] repositories -> Void in
                    self?.repositories = repositories
                    return
                }
        }
        //apiリクエストを投げて[item]が変わったら_repositoryChangedに伝える
        apiRequest.bind(to: _repositoryChanged).disposed(by: disposeBag)
    }
}
