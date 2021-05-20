//
//  DetailViewModel.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/19.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

protocol DetailViewModelOutput {
    //URLRequest
    var request: URLRequest { get }
    //navigationbarTitle
    var navigationBarTitle: Observable<String> { get }
}

final class DetailViewModel: DetailViewModelOutput {
    
    /*Outputに関する記述*/
    let request: URLRequest
    let navigationBarTitle: Observable<String>
    
    init(repository: GithubRepository) {
        
        self.request = URLRequest(url: repository.htmlUrl)
        self.navigationBarTitle = Observable.just(repository.fullName)
        
    }
}
