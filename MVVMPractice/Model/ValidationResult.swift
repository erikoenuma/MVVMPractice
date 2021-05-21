//
//  ValidationResult.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/21.
//

import Foundation
import RxSwift
import RxCocoa

enum ValidationResult {
    case ok(message: String)
    case empty
    case failed(message: String)
}

extension ValidationResult {
    
    var isValid: Bool {
        switch self{
        case .ok: return true
        default: return false
        }
    }
}

final class Validation{
    
    private init() {}
    static let shared = Validation()
    
    func validate(id: String) -> Observable<ValidationResult> {
        
        if id.isEmpty{
            return Observable.just(.empty)
        //文字数が5文字未満だった場合
        }else if id.count < 5{
            return Observable.just(.failed(message: "UserID should be more than 5 letters."))
        //文字列に半角英数以外が入っている場合
        }else if !id.isAlphanumeric(){
            return Observable.just(.failed(message: "Please use alphanumerics only."))
        }else{
            return Observable.just(.ok(message: "OK"))
        }
    }
    
    func validate(password: String)->Observable<ValidationResult> {
        if password.isEmpty{
            return Observable.just(.empty)
        //文字数が8文字未満だった場合
        }else if password.count < 8 {
            return Observable.just(.failed(message: "Password should be more than 8 letters."))
        //文字列が正しくない場合（先頭が大文字じゃないまたは半角英数以外が入っている）
        }else if !(password.prefix(1).isUpper() && password.isAlphanumeric()){
            return Observable.just(.failed(message: "First letter of password should be UPPERCASE LETTER. Please use alphanumerics only."))
        }else{
            return Observable.just(.ok(message: "OK"))
        }
    }
}
