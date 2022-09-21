//
//  BunnyViewModel.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/11.
//

import RxSwift
import RxRelay

protocol BunnyViewModelType {
    var input: BunnyViewModel.Input { get }
    var output: BunnyViewModel.Output { get }
    var usecase: BunnyManagable { get set }
    func fetchNewsThumbnailImages(from articles: [ArticleEntity])
}

final class BunnyViewModel {
    var usecase: BunnyManagable
    private let disposeBag = DisposeBag()

    var input = Input()
    var output = Output()
    
    struct Input {
        var viewDidLoad = PublishRelay<Void>()
        var cellButtonTapped = PublishRelay<IndexPath>()
    }
    
    struct Output {
        var setViewAttribute = PublishRelay<Void>()
        var newsFetchError = PublishRelay<Error>()
        var articleRelay = PublishRelay<[ArticleEntity]>()
        var updateArticleImage = PublishRelay<Int>()
        var updateCell = PublishRelay<IndexPath>()
    }
    
    init(managable: BunnyManagable) {
        self.usecase = managable
        
        input.viewDidLoad
            .withUnretained(self)
            .map { (viewModel, _) in
                viewModel.usecase.fetchNewsSingle()
            }
            .withUnretained(self)
            .do(onNext: { (viewModel, single) in
                single.subscribe { news in
                    let articles = news.articles.map { $0.convertArticleEntity() }
                    viewModel.fetchNewsThumbnailImages(from: articles)
                    viewModel.output.articleRelay.accept(articles)
                } onFailure: { error in
                    viewModel.output.newsFetchError.accept(error)
                }.disposed(by: viewModel.disposeBag)
            })
            .map { _ in return () }
            .bind(to: output.setViewAttribute)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.articleRelay, input.cellButtonTapped)
            .bind { articles, index in
                articles[index.row].setMoreDescriptionMode(true)
            }
            .disposed(by: disposeBag)
    }
}
extension BunnyViewModel: BunnyViewModelType {
    func fetchNewsThumbnailImages(from articles: [ArticleEntity]) {
        let globalQueue = DispatchQueue(label: "serial")
        Task.init {
            for (index, article) in articles.enumerated() {
                let imageData = try await usecase.fetchNewsImages(from: article)
                if let imageData = imageData  {
                    globalQueue.async {
                        article.setThumbnailImage(data: imageData)
                        self.output.updateArticleImage.accept(index)
                    }
                }
            }
        }
    }
}
