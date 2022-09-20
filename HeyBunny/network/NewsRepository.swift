//
//  NewsRepository.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/09.
//

import RxSwift

final class NewsRepositoryImpl {
    var koreaNewsService: NewsService = NewsServiceImpl()
}
extension NewsRepositoryImpl: NewsRepository {
    func requestKoreaNewsAPI() -> Single<News> {
        koreaNewsService.getKoreaNewsAPI()
    }
    
    func fetchImages(url: String) async throws -> Data {
        guard let url = URL(string: url) else { return Data() }
        let imageData = try await ImageManager.shared.fetchImage(from: url)
        return imageData
    }
}

protocol NewsRepository {
    var koreaNewsService: NewsService { get set }
    func requestKoreaNewsAPI() -> Single<News>
    func fetchImages(url: String) async throws -> Data
}
