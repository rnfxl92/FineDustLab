//
//  TemperatureView.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/24/24.
//

import UIKit

final class TemperatureView: UIView {
    
    var text: String? {
        get { temperatureLabel.text }
        set { temperatureLabel.text = newValue }
    }
    
    private let temperatureImageView = UIImageView(image: .thermometer)
    private let temperatureTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "온도"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray700
        return label
    }()
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .gray800
        label.text = "24" // TODO
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
        
        addSubViews([temperatureImageView, temperatureTitleLabel, temperatureLabel])
        
        temperatureImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        
        temperatureTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(temperatureImageView.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.leading.equalTo(temperatureTitleLabel.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
        
        snp.makeConstraints {
            $0.height.equalTo(28)
        }
    }
}
