//
//  HumidityView.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/24/24.
//

import UIKit

final class HumidityView: UIView {
    
    var text: String? {
        get { humidityLabel.text }
        set { humidityLabel.text = newValue }
    }
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .gray800
        label.text = "90"
        return label
    }()
    private let humidityImageView = UIImageView(image: .waterDrop)
    private let humidityTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "습도"
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
        backgroundColor = .gray200
        cornerRadius = 14
        
        addSubViews([humidityImageView, humidityTitleLabel, humidityLabel])
        
        humidityImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        
        humidityTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(humidityImageView.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
        }
        
        humidityLabel.snp.makeConstraints {
            $0.leading.equalTo(humidityTitleLabel.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
        
        snp.makeConstraints {
            $0.height.equalTo(28)
        }
    }
   
}
