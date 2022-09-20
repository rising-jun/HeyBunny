//
//  NewServiceStub.swift
//  HeyBunnyTests
//
//  Created by 김동준 on 2022/09/09.
//

@testable import HeyBunny
import RxSwift
import Moya

final class NewsServiceStub: NewsService {
    var provider = MoyaProvider<NewsAPI>(stubClosure: MoyaProvider.immediatelyStub)
    
    var result: Bool
    init(result: Bool) {
        self.result = result
    }
    
    func getKoreaNewsAPI() -> Single<News> {
        return Single<News>.create { [weak self] single in
            guard let self = self else { return Disposables.create { } }
            if self.result {
                let task = self.provider.request(.topHeadlines, completion: { result in
                    switch result {
                    case .success(let response):
                        if let decodeData = try? self.decode(from: response.data, parsingType: News.self) {
                            single(.success(decodeData))
                        } else { single(.failure(NetworkError.parsing)) }
                    case .failure(_):
                        single(.failure(NetworkError.network))
                    }
                })
            } else {
                single(.failure(NetworkError.network))
            }
            return Disposables.create { }
        }
    }
}

