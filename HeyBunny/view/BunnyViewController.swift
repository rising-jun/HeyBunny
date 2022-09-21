//
//  ViewController.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/09.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa
import RxDataSources

final class BunnyViewController: UIViewController {
    var viewModel: BunnyViewModelType? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            bind(to: viewModel)
        }
    }
    private let disposeBag = DisposeBag()
    private let cellButtonTapped = PublishRelay<Void>()
    
    private let rootFlexContainer = UIView()
    private lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsCardCell.self, forCellReuseIdentifier: NewsCardCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        viewModel?.input.viewDidLoad.accept(())
    }
}
extension BunnyViewController {
    func bind(to viewModel: BunnyViewModelType) {
        viewModel.output.setViewAttribute
            .withUnretained(self)
            .subscribe { (viewController, _) in
                viewController.setLayout()
            }.disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
            configureCell: { dataSource, tableView, indexPath, item in
                if let cell = tableView.dequeueReusableCell(withIdentifier: NewsCardCell.id, for: indexPath) as? NewsCardCell {
                    cell.configuration(with: (item, indexPath))
                    if let data = item.thumbnailImage {
                        cell.setThiumbnailImage(data: data)
                    }
                    
                    cell.viewModel
                        .moreButtonTapped
                        .bind(to: viewModel.input.cellButtonTapped)
                        .disposed(by: self.disposeBag)
                    
                    return cell
                }
                return UITableViewCell()
            })
        
        viewModel.output.articleRelay
            .map { [SectionOfCustomData(items: $0)] }
            .bind(to: newsTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.newsFetchError
            .bind { error in
                print("error!! \(error)")
            }.disposed(by: disposeBag)
        
        viewModel.output.updateArticleImage
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { (viewController, item) in
                viewController.newsTableView.reloadRows(at: [IndexPath(row: item, section: 0)], with: .automatic)
            }.disposed(by: disposeBag)
        
        viewModel.input.cellButtonTapped
            .withUnretained(self)
            .bind { (viewController, indexPath) in
                viewModel.output.articleRelay.do { articles in
                    articles[indexPath.row].setMoreDescriptionMode(true)
                }
                viewController.newsTableView.reconfigureRows(at: [indexPath])
            }.disposed(by: disposeBag)
        
        newsTableView.delegate = self
        newsTableView.allowsSelection = false
        newsTableView.allowsSelectionDuringEditing = true
    }
    
    private func setLayout() {
        view.addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem(self.newsTableView).width(100%).height(100%)
        }
        
        newsTableView.estimatedRowHeight = 400
        newsTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.all() // 1)
        self.rootFlexContainer.flex.layout() // 2)
    }
}

struct SectionOfCustomData {
    var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
    typealias Item = ArticleEntity
    
    init(original: SectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}

extension BunnyViewController: UITableViewDelegate {
    
}
