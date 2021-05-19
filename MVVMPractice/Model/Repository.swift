//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by 肥沼英里 on 2021/04/01.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Repository: Codable{
    let items: [GithubRepository]
}

struct GithubRepository: Codable{
    let fullName: String
    let htmlUrl: URL
    
    enum CodingKeys: String, CodingKey{
        case fullName = "full_name"
        case htmlUrl = "html_url"
    }
}
