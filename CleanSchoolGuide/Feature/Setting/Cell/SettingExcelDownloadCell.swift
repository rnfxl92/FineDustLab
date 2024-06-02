//
//  SettingExcelDownloadCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/3/24.
//

import UIKit

final class SettingsExcelDownloadCell: UITableViewCell {
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
        label.text = "설문 조사 다운로드"
        
        return label
    }()
    
    private let downloadImageView: UIImageView = {
        let imageView = UIImageView(image: .icDownload)
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
        infoView.addSubViews([titleLabel, downloadImageView])
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        downloadImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        stackView.addArrangedSubViews([infoView, bottomDivider])
        
        if Preferences.selectedUserType == .teacher {
            infoView.snp.makeConstraints {
                $0.height.equalTo(64)
            }
        } else {
            infoView.snp.makeConstraints {
                $0.height.equalTo(0.1)
            }
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
