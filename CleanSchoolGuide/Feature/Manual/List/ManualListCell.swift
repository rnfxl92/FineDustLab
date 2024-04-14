//
//  ManualListCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/14/24.
//

import UIKit

final class ManualListCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray800
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: .icRight)
        imageView.tintColor = .gray500
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        containerView.addSubViews([titleLabel, arrowImageView])
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.size.equalTo(20)
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    func setUIModel(_ title: String) {
        self.titleLabel.text = title
    }
}

