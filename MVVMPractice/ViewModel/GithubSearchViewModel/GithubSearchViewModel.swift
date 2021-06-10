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
    //RxDataSources
    var dataRelay: BehaviorRelay<[SectionModel]> { get }
}

final class GithubSearchViewModel: GithubSearchViewModelInput, GithubSearchViewModelOutput {
    
    private let disposeBag = DisposeBag()
    private let sectionModel: [SectionModel]!
    /*Inputに関する記述*/
    private let _searchText = PublishRelay<String?>()
    //これweak selfにしてないせいで循環参照して時間取られました。反省。
    lazy var searchTextObserver: AnyObserver<String?> = .init { [weak self] event in
        guard let element = event.element else { return }
        self?._searchText.accept(element)
    }
    
    /*Outputに関する記述*/
    lazy var dataRelay = BehaviorRelay<[SectionModel]>(value: [])
    
    init() {
        
        sectionModel = [SectionModel(items: [])]
        
        //dataRelayに初期設定のsectionModelを流す
        Observable.deferred { () -> Observable<[SectionModel]> in
            return Observable.just(self.sectionModel)
        }.bind(to: dataRelay)
        .disposed(by: disposeBag)
        
        _searchText
            //0.5秒新たなイベントが発行されなくなってから最後に発行されたイベントを使用する
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            //流れてくる値が前回と違う時のみイベントを流す
            .distinctUntilChanged()
            //アンラップ
            .filterNil()
            .filter{ $0.isNotEmpty }
            .flatMapLatest { searchText in
                GithubApiModel.shared.rx.request(searchWord: searchText)
                    .map { repositories -> [SectionModel] in
                        [SectionModel(items: repositories)]
                    }
                //dateRelayに新しいSectionModelを流すと勝手にreloadしてくれる
            }.bind(to: dataRelay)
            .disposed(by: disposeBag)
    }
}
