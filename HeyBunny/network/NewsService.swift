//
//  NewsService.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/09.
//

import RxSwift
import Moya

protocol NewsService {
    var provider: MoyaProvider<NewsAPI> { get }
    func getKoreaNewsAPI() -> Single<News>
}
extension NewsService {
    func decode<T: Decodable>(from data: Data, parsingType: T.Type) throws -> T {
        guard let decodeData = try? JSONDecoder().decode(parsingType, from: data) else {
            throw NetworkError.parsing
        }
        return decodeData
    }
}

final class NewsServiceImpl: NewsService {
    var provider = MoyaProvider<NewsAPI>()

    func getKoreaNewsAPI() -> Single<News> {
        return Single<News>.create { [weak self] single in
            guard let self = self else { return Disposables.create { } }
            let task = self.provider.request(.topHeadlines, completion: { result in
                switch result {
                case .success(let response):
                    print(String(data: response.data,encoding: .utf8))
                    if let decodeData = try? self.decode(from: response.data, parsingType: News.self) {
                        single(.success(decodeData))
                    } else { single(.failure(NetworkError.parsing)) }
                case .failure(_):
                    single(.failure(NetworkError.network))
                }
            })
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

enum NetworkError: Error {
    case network
    case parsing
}
