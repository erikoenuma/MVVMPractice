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
import RxDataSources

final class GithubSearchViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!{
        didSet{
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
        setUpTableView()
    }
    
    private func bindInputStream() {
        searchBar.rx.text.bind(to: input.searchTextObserver).disposed(by: disposeBag)
    }
    
    private func setUpTableView() {
        
        //RxDataSources
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath)
            cell.textLabel?.text = item.fullName
            cell.detailTextLabel?.text = item.htmlUrl.absoluteString
            return cell
        })
        
        //dateRelayの変更を感知してdataSourceにデータを流す
        output.dataRelay.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //tableViewのセルをタップした時の処理
        tableView.rx.modelSelected(GithubRepository.self)
            .subscribe(onNext: { item in
                Router.shared.showDetailView(from: self, repository: item)
            }).disposed(by: disposeBag)
    }
    
    static func makeFromStoryboard() -> GithubSearchViewController {
        UIStoryboard(name: "GithubSearchView", bundle: nil).instantiateInitialViewController() as! GithubSearchViewController
    }
}
