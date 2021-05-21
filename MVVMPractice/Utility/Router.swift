//
//  Router.swift
//  MVVMCounterApp
//
//  Created by 肥沼英里 on 2021/05/15.
//

import Foundation
import UIKit

final class Router {
    
    static let shared = Router()
    private init() {}
    
    private var window: UIWindow?
    
    func showRoot(window: UIWindow) {
        let vc = BaseViewController.makeFromStoryboard()
        let nav = UINavigationController(rootViewController: vc)
        window.makeKeyAndVisible()
        window.rootViewController = nav
        self.window = window
    }
    
    func showCountApp(from: UIViewController) {
        let vc = CountViewController.makeFromStoryboard()
        show(from: from, to: vc)
    }
    
    func showGithubSearchView(from: UIViewController) {
        let vc = GithubSearchViewController.makeFromStoryboard()
        show(from: from, to: vc)
    }
    
    func showDetailView(from: UIViewController, repository: GithubRepository) {
        let vc = DetailViewController.makeFromStoryboard()
        let viewModel = DetailViewModel(repository: repository)
        vc.inject(viewModel: viewModel)
        show(from: from, to: vc)
    }
    
    func showLoginView(from: UIViewController){
        let vc = LoginViewController.makeFromStoryboard()
        show(from: from, to: vc)
    }
    
    private func show(from: UIViewController, to: UIViewController, completion:(() -> Void)? = nil){
        if let nav = from.navigationController {
            nav.pushViewController(to, animated: true)
            completion?()
        } else {
            from.present(to, animated: true, completion: completion)
        }
    }
}
