//
//  LoginViewModel.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelInput {
    //loginID
    var idObserver: AnyObserver<String> { get }
    //password
    var passwordObserver: AnyObserver<String> { get }
}

protocol LoginViewModelOutput {
    var idValidation: Driver<ValidationResult> { get }
    var passwordValidation: Driver<ValidationResult> { get }
    var loginValidation: Driver<Bool> { get }
}

final class LoginViewModel: LoginViewModelInput, LoginViewModelOutput {
    
    private let disposeBag = DisposeBag()
    
    /*Input*/
    private let _idObserver = BehaviorRelay<String>(value: "")
    lazy var idObserver: AnyObserver<String> = .init { [weak self] event in
        guard let e = event.element else { return }
        self?._idObserver.accept(e)
    }
    
    private let _passwordObserver = BehaviorRelay<String>(value: "")
    lazy var passwordObserver: AnyObserver<String> = .init { [weak self] event in
        guard let e = event.element else { return }
        self?._passwordObserver.accept(e)
    }
    
    /*Output*/
    private let _idValidation = BehaviorRelay<ValidationResult>(value: .empty)
    lazy var idValidation: Driver<ValidationResult> = _idValidation.asDriver(onErrorDriveWith: .empty())
    
    private let _passwordValidation = BehaviorRelay<ValidationResult>(value: .empty)
    lazy var passwordValidation: Driver<ValidationResult> = _passwordValidation.asDriver(onErrorDriveWith: .empty())

    lazy var loginValidation: Driver<Bool> = Driver.just(false)
    
    init() {
        
        _idObserver
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest{ id -> Observable<ValidationResult> in
                Validation.shared.validate(id: id)
            }.bind(to: _idValidation).disposed(by: disposeBag)
        
        _passwordObserver
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { password -> Observable<ValidationResult> in
                Validation.shared.validate(password: password)
            }.bind(to: _passwordValidation).disposed(by: disposeBag)
        
        loginValidation = Driver.combineLatest(idValidation, passwordValidation){ id, password in
            return id.isValid && password.isValid
        }
    }
}
