//
//  UILabelExtensions.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/22.
//

import Foundation
import UIKit
import RxSwift

extension ValidationResult{
    var textColor: UIColor{
        switch self{
        case .ok:
            return UIColor.systemGreen
        case .empty:
            return UIColor.black
        case .failed:
            return UIColor.red
        }
    }
    
    var description: String{
        switch self{
        case .ok(let message):
            return message
        case .empty:
            return ""
        case .failed(let message):
            return message
        }
    }
}

extension Reactive where Base: UILabel{
    var validationResult: Binder<ValidationResult>{
        return Binder(base) { label, result in
            label.text = result.description
            label.textColor = result.textColor
        }
    }
}
