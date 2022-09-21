//
//  BunnyUsecaseTests.swift
//  HeyBunnyTests
//
//  Created by 김동준 on 2022/09/20.
//

@testable import HeyBunny
import XCTest
import RxSwift

class BunnyUsecaseTests: XCTestCase {
    var usecase: BunnyManagable!
    let disposeBag = DisposeBag()
   
    func test_BunnyUsecase에서_fetchNewsSingle가_호출되면_성공하고_newsModel을_업데이트한다() throws {
        //give
        let didFinish = expectation(description: #function)
        let expectResult = true
        var testResult = false
        var newsModel: News?
        let repository: NewsRepository = NewsRepositoryStub(expectResult: expectResult, service: NewsServiceStub(result: expectResult))
        usecase = BunnyUsecase()
        usecase.repository = repository

        //when
        let newsSingle = usecase.fetchNewsSingle()
        newsSingle.subscribe { news in
            newsModel = news
            testResult = true
            didFinish.fulfill()
        } onFailure: { error in
            testResult = false
            didFinish.fulfill()
        }.disposed(by: disposeBag)
        wait(for: [didFinish], timeout: 1.0)
        
        //then
        XCTAssertNotNil(newsModel)
        XCTAssertTrue(testResult)
    }
    
    func test_BunnyUsecase에서_fetchNewsSingle가_호출되면_실패하고_error를_반환한다() throws {
        //give
        let didFinish = expectation(description: #function)
        let expectResult = false
        var testResult = false
        let repository: NewsRepository = NewsRepositoryStub(expectResult: expectResult, service: NewsServiceStub(result: expectResult))
        usecase = BunnyUsecase()
        usecase.repository = repository
        
        //when
        let newsSingle = usecase.fetchNewsSingle()
        newsSingle.subscribe { news in
            testResult = false
            didFinish.fulfill()
        } onFailure: { error in
            testResult = true
            didFinish.fulfill()
        }.disposed(by: disposeBag)
        wait(for: [didFinish], timeout: 1.0)
        
        //then
        XCTAssertTrue(testResult)
    }
}
