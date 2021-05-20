//
//  WebKitViewController.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/18.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift
import RxOptional

final class GithubSearchViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        }
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = GithubSearchViewModel()
    private lazy var input: GithubSearchViewModelInput = viewModel
    private lazy var output: GithubSearchViewModelOutput = viewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInputStream()
        bindOutputStream()
    }
    
    private func bindInputStream() {
        searchBar.rx.text.bind(to: input.searchTextObserver).disposed(by: disposeBag)
    }
    
    private func bindOutputStream() {
        //repositoryの中身が変わったらtableViewをreloadする
        output.repositoryChanged.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    static func makeFromStoryboard() -> GithubSearchViewController {
        UIStoryboard(name: "GithubSearchView", bundle: nil).instantiateInitialViewController() as! GithubSearchViewController
    }
}

extension GithubSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath)
        cell.textLabel?.text = viewModel.repositories[indexPath.row].fullName
        cell.detailTextLabel?.text = viewModel.repositories[indexPath.row].htmlUrl.absoluteString
        return cell
    }
}

extension GithubSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.shared.showDetailView(from: self, repository: output.repositories[indexPath.row])
    }
}
