//
//  NewsCardCell.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/13.
//

import RxSwift
import SnapKit
import RxRelay

final class NewsCardCell: UITableViewCell {
    static let id: String = String(describing: NewsCardCell.self)
    
    private let disposeBag = DisposeBag()
    private let rootView = UIView()
    private let thumbImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private(set) var moreButton = UIButton()
    lazy var viewModel = NewsCellViewModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
        registerRxEvent()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        moreButton.isHidden = false
        descriptionLabel.numberOfLines = 2
    }
    
}
extension NewsCardCell {
    private func layout() {
        contentView.addSubview(rootView)
        rootView.addSubview(thumbImageView)
        rootView.addSubview(titleLabel)
        rootView.addSubview(descriptionLabel)
        rootView.addSubview(moreButton)
        
        rootView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        thumbImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(thumbImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        moreButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-5)
            make.width.equalTo(60)
            
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
        }
    }
    
    private func attribute() {
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.clipsToBounds = true
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 2
        moreButton.setTitle("더보기", for: .normal)
        moreButton.setTitleColor(.blue, for: .normal)
        moreButton.backgroundColor = .systemGray6
        contentView.layoutIfNeeded()
    }
    
    private func moreDescriptionAttribute() {
        moreButton.isHidden = true
        descriptionLabel.numberOfLines = 0
        contentView.setNeedsLayout()
    }
    
    
    private func registerRxEvent() {
        moreButton.rx
            .tap
            .bind(to: viewModel.buttonTapRelay)
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configuration(with: (entity: ArticleEntity, indexPath: IndexPath)) {
        viewModel.setIndexPath(with.indexPath)
        titleLabel.text = with.entity.title
        descriptionLabel.text = with.entity.description
        if with.entity.moreDescriptionMode {
            moreDescriptionAttribute()
        }
    }
    
    func setThiumbnailImage(data: Data) {
        self.thumbImageView.image = UIImage(data: data)
        self.thumbImageView.setNeedsDisplay()
    }
}
