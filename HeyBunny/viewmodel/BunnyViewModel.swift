//
//  BunnyViewModel.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/11.
//

import RxSwift
import RxRelay

final class BunnyViewModel {
    let usecase: BunnyManagable = BunnyUsecase()
    private let disposeBag = DisposeBag()
    var viewDidLoad = PublishRelay<Void>()
    
    var newsFetchError = PublishRelay<Error>()
    var articleRelay = PublishRelay<[ArticleEntity]>()
    
    init() {
        viewDidLoad
            .withUnretained(self)
            .map { (viewModel, _) in
                viewModel.usecase.fetchNewsSingle()
            }
            .withUnretained(self)
            .subscribe(onNext: { (viewModel, single) in
                single.subscribe { news in
                    let articles = news.articles.map { $0.convertArticleEntity() }
                    viewModel.fetchNewsThumbnailImages(from: articles)
                    viewModel.articleRelay.accept(articles)
                } onFailure: { error in
                    viewModel.newsFetchError.accept(error)
                }.disposed(by: viewModel.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
extension BunnyViewModel {
    func fetchNewsThumbnailImages(from articles: [ArticleEntity]) {
        Task.init {
            for article in articles {
                let imageData = try await usecase.fetchNewsImages(from: article)
                guard let imageData = imageData else {
                    return
                }
                article.setThumbnailImage(data: imageData)
            }
        }
    }
}
