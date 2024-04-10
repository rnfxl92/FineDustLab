//
//  SurveyDetailViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 4/10/24.
//

import UIKit
import Combine
import CombineCocoa

final class SurveyDetailViewController: BaseViewController {
    private let navigationBar = CustomNavigationBar()
    private let backButton = CustomNavigationButton(.back)
    private let titleStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 12
        
        return stackView
    }()
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .gray900
        label.numberOfLines = 0
        return label
    }()
        
    private let viewModel: SurveyDetailViewModel
    
    
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: SurveyDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUserInterface() {
        var str = NSAttributedString("")
        if viewModel.totalCount > 0 {
            str = NSAttributedString(string: "\(viewModel.currentIndex + 1)/\(viewModel.totalCount)", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
                .addAttributes("\(viewModel.currentIndex + 1)", attributes: [.foregroundColor: UIColor.blue300])
                .addAttributes("/\(viewModel.totalCount)", attributes: [.foregroundColor: UIColor.gray400])
                
        }
        let totalButton = CustomNavigationButton(.attributedText(str))
        
        navigationBar.setNavigation(title: "설문조사", titleAlwaysVisible: true, leftItems: [backButton], rightItems: [totalButton])
        
        categoryLabel.text = viewModel.survey?.categoryName
        categoryLabel.textColor = UIColor(hex: viewModel.survey?.categoryColor ?? "")
        questionLabel.text = viewModel.survey?.question
        
        titleStackView.addArrangedSubViews([categoryLabel, questionLabel])
        
   
        view.backgroundColor = .gray0
        view.addSubViews([navigationBar, titleStackView])
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
    }
    
    override func bind() {
        backButton.tapPublisher.sink { [weak self] in
            self?.pop(animated: true)
        }
        .store(in: &cancellable)
    }
    
}

