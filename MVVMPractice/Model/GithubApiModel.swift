//
//  URLRequest.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/18.
//

import Foundation
import RxSwift

final class GithubApiModel {
    
    static let shared = GithubApiModel()
    private init () {}
    
    func request(searchWord: String, completion: @escaping(Result<[GithubRepository], Error>)->Void) {
        
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)") else { return }
        let task: URLSessionTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do{
                let repository = try JSONDecoder().decode(Repository.self, from: data)
                let items = repository.items
                completion(.success(items))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension GithubApiModel: ReactiveCompatible{}
//Reactive Programmingを行うための拡張
extension Reactive where Base: GithubApiModel {
    func request (searchWord:String) -> Observable<[GithubRepository]> {
        return Observable.create { observer in
            GithubApiModel.shared.request(searchWord: searchWord) { result in
                switch result {
                case .success(let repository):
                    observer.onNext(repository)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }.share(replay: 1, scope: .whileConnected)
    }
}
