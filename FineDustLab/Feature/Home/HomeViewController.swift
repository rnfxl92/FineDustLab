//
//  HomeViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit

final class HomeViewController: BaseViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .gray900
        label.text = "오늘도 청소했다면?"
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray700
        label.numberOfLines = 2
        label.text = "설문조사를 완료해 주세요!"
        label.textAlignment = .center
        return label
    }()
    
    private let titleStackView = UIStackView(axis: .vertical)
    
    private let mainSurveyView: UIView = UIView()
    
    
    override func setUserInterface() {
        titleStackView.spacing = 12
        titleStackView.addArrangedSubViews([titleLabel, descriptionLabel])
        
        mainSurveyView.addSubViews([titleStackView])
        mainSurveyView.backgroundColor = .gray0
        mainSurveyView.layer.cornerRadius = 20
        
        titleStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(24) // 제거
        }
        
        view.addSubViews([mainSurveyView])
        view.backgroundColor = .blue100
        
    }
    
}

