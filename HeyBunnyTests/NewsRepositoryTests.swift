//
//  NewsRepositoryTests.swift
//  HeyBunnyTests
//
//  Created by 김동준 on 2022/09/09.
//

@testable import HeyBunny
import XCTest
import RxSwift

class NewsRepositoryTests: XCTestCase {
    var newsService: NewsService!
    var repository: NewsRepository!
    let disposebag = DisposeBag()
    
    func test_NewsRepository에서_requestKoreaNewsAPI가_호출되면_성공하고_modelCount를_업데이트한다() throws {

        //give
        let didFinish = expectation(description: #function)
        newsService = NewsServiceStub(result: true)
        repository = NewsRepositoryImpl()
        repository.koreaNewsService = newsService
        var result = false
        var modelCount = 0
       
        //when
        let resultObservable = repository.requestKoreaNewsAPI()
        resultObservable.subscribe { news in
            modelCount = news.articles.count
            result = true
            didFinish.fulfill()
        } onFailure: { error in
            result = false
            didFinish.fulfill()
        }
        .disposed(by: disposebag)
        wait(for: [didFinish], timeout: 3.0)
        
        //then
        XCTAssertEqual(result, true)
        XCTAssertEqual(modelCount, 1)
    }
    
    func test_NewsRepository에서_requestKoreaNewsAPI가_호출되면_실패하고_failure를_호출한다() throws {

        //give
        let didFinish = expectation(description: #function)
        newsService = NewsServiceStub(result: false)
        repository = NewsRepositoryImpl()
        repository.koreaNewsService = newsService
        var result = false
        
        //when
        let resultObservable = repository.requestKoreaNewsAPI()
        resultObservable.subscribe { news in
            result = false
            didFinish.fulfill()
        } onFailure: { _ in
            result = true
            didFinish.fulfill()
        }
        .disposed(by: disposebag)
        wait(for: [didFinish], timeout: 1.0)
        
        //then
        XCTAssertEqual(result, true)
    }
}
