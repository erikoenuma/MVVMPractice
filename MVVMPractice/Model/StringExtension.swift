//
//  StringExtension.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/21.
//

import Foundation

extension String {
    //半角英数かどうかを判定するメソッド
    func isAlphanumeric() -> Bool {
        self.range(of: "[a-z,A-Z,0-9]", options: .regularExpression) != nil
      }
}

extension Substring {
    //大文字かどうかを判定するメソッド
    func isUpper() -> Bool {
        self.range(of: "[A-Z]", options: .regularExpression) != nil
    }
}
