//
//  News.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/09.
//

import Foundation

struct News: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String
}
