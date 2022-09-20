//
//  NewsRepositoryStub.swift
//  HeyBunnyTests
//
//  Created by 김동준 on 2022/09/20.
//

@testable import HeyBunny
import RxSwift

class NewsRepositoryStub {
    var expectResult: Bool = false
    var koreaNewsService: NewsService
    init(expectResult: Bool, service: NewsService) {
        self.expectResult = expectResult
        self.koreaNewsService = service
    }
}
extension NewsRepositoryStub: NewsRepository {
    func requestKoreaNewsAPI() -> Single<News> {
        koreaNewsService.getKoreaNewsAPI()
    }
    
    func fetchImages(url: String) async throws -> Data {
        return Data()
    }
}
