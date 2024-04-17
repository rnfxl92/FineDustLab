//
//  SettingsUpdateInfoCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/17/24.
//

import UIKit

final class SettingsUpdateInfoCell: UITableViewCell {
    private let stackView = UIStackView(axis: .vertical)
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray0
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray900
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.text = "업데이트 내용"
        
        return label
    }()
    
    private let arrRightImageView: UIImageView = {
        let imageView = UIImageView(image: .icRight)
        imageView.tintColor = .gray600
        return imageView
    }()
    private let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
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
        
        infoView.addSubViews([titleLabel, arrRightImageView])
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        arrRightImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
        stackView.addArrangedSubViews([infoView, bottomDivider])
        infoView.snp.makeConstraints {
            $0.height.equalTo(64)
        }
        bottomDivider.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}
