//
//  SectionModel.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/06/11.
//

import RxDataSources

struct SectionModel{
    var items: [GithubRepository]
}

extension SectionModel: SectionModelType{
    init(original: SectionModel, items: [GithubRepository]) {
        self = original
        self.items = items
    }
}

