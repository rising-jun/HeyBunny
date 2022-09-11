//
//  Entity.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/09.
//

import Foundation

final class ArticleEntity {
    init(title: String, description: String, url: String, urlToImage: String, publishedAt: String, content: String) {
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    private(set) var thumbnailImage: Data?
    private(set) var writeDate: String?
    
    func setThumbnailImage(data: Data) {
        self.thumbnailImage = data
    }
    
    func setWriteDate(_ date: String) {
        self.writeDate = date
    }
}
