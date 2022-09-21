//
//  BunnyUsecase.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/09.
//

import RxSwift

protocol BunnyManagable {
    var repository: NewsRepository { get set }
    func fetchNewsSingle() -> Single<News>
    func fetchNewsImages(from entity: ArticleEntity) async throws -> Data?
}

final class BunnyUsecase {
    var repository: NewsRepository = NewsRepositoryImpl()
    private let disposeBag = DisposeBag()
}
extension BunnyUsecase: BunnyManagable {
    func fetchNewsSingle() -> Single<News> {
        return repository.requestKoreaNewsAPI()
    }
    
    func fetchNewsImages(from entity: ArticleEntity) async throws -> Data? {
        guard let imageData = try? await repository.fetchImages(url: entity.urlToImage) else {
            return nil
        }
        return imageData
    }
}
