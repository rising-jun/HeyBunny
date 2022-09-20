//
//  NewsCellViewModel.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/19.
//

import Foundation
import RxRelay
import RxSwift

final class NewsCellViewModel {
    let disposeBag = DisposeBag()
    private(set) var indexPath: IndexPath?
    
    init() {
        buttonTapRelay
            .map { [weak self] _ in
                guard let self = self else { return nil }
                return self.indexPath
            }
            .compactMap { $0 }
            .bind(to: moreButtonTapped)
            .disposed(by: disposeBag)
    }
    var buttonTapRelay = PublishRelay<Void>()
    
    var moreButtonTapped = PublishRelay<IndexPath>()
}
extension NewsCellViewModel {
    func setIndexPath(_ indexPath: IndexPath) {
        self.indexPath = indexPath
    }
}
