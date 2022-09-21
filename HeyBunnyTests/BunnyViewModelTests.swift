//
//  Bunny.swift
//  HeyBunnyTests
//
//  Created by 김동준 on 2022/09/21.
//

@testable import HeyBunny
import XCTest
import RxSwift
import RxTest

class BunnyViewModelTests: XCTestCase {
    var viewModel: BunnyViewModelType!
    let disposeBag = DisposeBag()
    
    func test_BunnyViewModel에서_viewDidload가_호출되면_attrubute가_호출되며_성공하고_article이_업데이트된다() throws {
        //give
        let scheduler = TestScheduler(initialClock: 0)
        let articleObserver = scheduler.createObserver(Int.self)
        let attributeObserver = scheduler.createObserver(Bool.self)
        
        let expectResult = true
        let service = NewsServiceStub(result: expectResult)
        
        let repository = NewsRepositoryStub(expectResult: expectResult, service: service)
        let usecase = BunnyUsecaseStub(expectResult: expectResult, repository: repository)
        
        viewModel = BunnyViewModel()
        viewModel.usecase = usecase
        
        //when
        viewModel.output.articleRelay
            .map { $0.count }
            .bind(to: articleObserver)
            .disposed(by: disposeBag)

        viewModel.output
            .setViewAttribute
            .map { true }
            .bind(to: attributeObserver)
            .disposed(by: disposeBag)
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        scheduler.start()
    
        
        //then
        XCTAssertEqual(articleObserver.events, [.next(10, 1)])
        XCTAssertEqual(attributeObserver.events, [.next(10, true)])
    }
    
    func test_BunnyViewModel에서_viewDidload가_호출되면_attrubute가_호출되며_실패하고_networkerror가_반환된다() throws {
        //give
        let scheduler = TestScheduler(initialClock: 0)
        let attributeObserver = scheduler.createObserver(Bool.self)
        let errorObserver = scheduler.createObserver(NetworkError.self)
        
        let expectResult = false
        let service = NewsServiceStub(result: expectResult)
        
        let repository = NewsRepositoryStub(expectResult: expectResult, service: service)
        let usecase = BunnyUsecaseStub(expectResult: expectResult, repository: repository)
        
        viewModel = BunnyViewModel()
        viewModel.usecase = usecase
        
        //when
        viewModel.output
            .newsFetchError
            .map { $0 as? NetworkError }
            .compactMap { $0 }
            .bind(to: errorObserver)
            .disposed(by: disposeBag)

        viewModel.output
            .setViewAttribute
            .map { true }
            .bind(to: attributeObserver)
            .disposed(by: disposeBag)
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        scheduler.start()
    
        
        //then
        XCTAssertEqual(errorObserver.events, [.next(10, .network)])
        XCTAssertEqual(attributeObserver.events, [.next(10, true)])
    }
}
