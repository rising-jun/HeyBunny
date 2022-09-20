//
//  BunnyUsecaseStub.swift
//  HeyBunnyTests
//
//  Created by 김동준 on 2022/09/20.
//

@testable import HeyBunny
import RxSwift

final class BunnyUsecaseStub {
    var result: Bool
    var repository: NewsRepository
    
    init(expectResult: Bool, repository: NewsRepository) {
        result = expectResult
        self.repository = repository
    }
}
extension BunnyUsecaseStub: BunnyManagable {
    func fetchNewsSingle() -> Single<News> {
        repository.requestKoreaNewsAPI()
    }
    
    func fetchNewsImages(from entity: ArticleEntity) async throws -> Data? {
        result ? Data() : nil
    }
}
