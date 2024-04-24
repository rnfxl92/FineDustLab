//
//  GeoSettingButtonView.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/24/24.
//

import UIKit

final class GeoSettingButtonView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: .crosshair)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "위치정보 설정"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray700
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        cornerRadius = 14
        backgroundColor = .gray200
        addSubViews([imageView, titleLabel])
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(14)
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
        
        snp.makeConstraints {
            $0.height.equalTo(28)
        }
    }
}
