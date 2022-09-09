//
//  NewsRepository.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/09.
//

import RxSwift

final class NewsRepository {
    let koreaNewsService: NewsService = NewsServiceImpl()
}
extension NewsRepository {
    func requestKoreaNewsAPI() -> Single<News> {
        koreaNewsService.getKoreaNewsAPI()
    }
}
