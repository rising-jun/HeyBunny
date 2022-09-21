//
//  DependencyContainer.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/21.
//

import Foundation

final class DependencyInjector {
    private let service = NewsServiceImpl()
    private lazy var repository = NewsRepositoryImpl(service: service)

    func injectBunnyDependency() -> BunnyDependency {
        return BunnyDependency(viewModel: BunnyViewModel(managable: BunnyUsecase(repository: repository)))
    }
}
extension DependencyInjector: BunnyDependencyInjectable {
    
}
protocol BunnyDependencyInjectable {
    func injectBunnyDependency() -> BunnyDependency
}

struct BunnyDependency {
    var viewModel: BunnyViewModelType
}
