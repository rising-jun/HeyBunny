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
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    
    func convertArticleEntity() -> ArticleEntity {
        return ArticleEntity(title: title, description: description, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
    }
}
