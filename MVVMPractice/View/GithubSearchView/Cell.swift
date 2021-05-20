//
//  Cell.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/19.
//

import Foundation
import UIKit

final class Cell: UITableViewCell {
    
    static let identifier = "cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: Cell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
