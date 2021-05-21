//
//  LoginViewController.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

final class LoginViewController: UIViewController {

    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var idValidationLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordValidationLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    private lazy var input: LoginViewModelInput = viewModel
    private lazy var output: LoginViewModelOutput = viewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInputStream()
        bindOutputStream()
    }

    private func bindInputStream(){
        idTextField.rx.text.filterNil().bind(to: input.idObserver).disposed(by: disposeBag)
        passwordTextField.rx.text.filterNil()
            .bind(to: input.passwordObserver).disposed(by: disposeBag)
    }
    
    private func bindOutputStream(){
        output.idValidation
            .drive(idValidationLabel.rx.validationResult).disposed(by: disposeBag)
        output.passwordValidation
            .drive(passwordValidationLabel.rx.validationResult).disposed(by: disposeBag)
        output.loginValidation
            .drive(loginButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    static func makeFromStoryboard()->LoginViewController{
        UIStoryboard(name: "LoginView", bundle: nil).instantiateInitialViewController() as! LoginViewController
    }
}
