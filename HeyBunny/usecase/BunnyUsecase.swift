//
//  BunnyUsecase.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/09.
//

import RxSwift

protocol BunnyManagable {
    func fetchNewsSingle() -> Single<News>
    func fetchNewsImages(from entity: ArticleEntity) async throws -> Result<ArticleEntity, NetworkError> 
}

final class BunnyUsecase {
    let repository: NewsRepository = NewsRepositoryImpl()
    private let disposeBag = DisposeBag()
}
extension BunnyUsecase {
    func fetchNewsSingle() -> Single<News> {
        return repository.requestKoreaNewsAPI()
    }
    
    func fetchNewsImages(from entity: ArticleEntity) async throws -> Result<ArticleEntity, NetworkError> {
        guard let imageData = try? await repository.fetchImages(url: entity.urlToImage) else {
            return .failure(.network)
        }
        entity.setThumbnailImage(data: imageData)
        return .success(entity)
    }
}
