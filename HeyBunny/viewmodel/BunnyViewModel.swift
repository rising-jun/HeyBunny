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
    var cellButtonTapped = PublishRelay<IndexPath>()
    
    var setViewAttribute = PublishRelay<Void>()
    var newsFetchError = PublishRelay<Error>()
    var articleRelay = PublishRelay<[ArticleEntity]>()
    var updateArticleImage = PublishRelay<Int>()
    var updateCell = PublishRelay<IndexPath>()
    
    init() {
        viewDidLoad
            .withUnretained(self)
            .map { (viewModel, _) in
                viewModel.usecase.fetchNewsSingle()
            }
            .withUnretained(self)
            .do(onNext: { (viewModel, single) in
                single.subscribe { news in
                    let articles = news.articles.map { $0.convertArticleEntity() }
                    viewModel.fetchNewsThumbnailImages(from: articles)
                    viewModel.articleRelay.accept(articles)
                } onFailure: { error in
                    viewModel.newsFetchError.accept(error)
                }.disposed(by: viewModel.disposeBag)
            })
            .map { _ in return () }
            .bind(to: setViewAttribute)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(articleRelay, cellButtonTapped)
            .bind { articles, index in
                articles[index.row].setMoreDescriptionMode(true)
            }
            .disposed(by: disposeBag)
    }
}
extension BunnyViewModel {
    func fetchNewsThumbnailImages(from articles: [ArticleEntity]) {
        let globalQueue = DispatchQueue(label: "serial")
        Task.init {
            for (index, article) in articles.enumerated() {
                let imageData = try await usecase.fetchNewsImages(from: article)
                if let imageData = imageData  {
                    globalQueue.async {
                        article.setThumbnailImage(data: imageData)
                        self.updateArticleImage.accept(index)
                    }
                }
            }
        }
    }
}
