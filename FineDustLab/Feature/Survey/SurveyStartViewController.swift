//
//  SurveyStartViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 4/2/24.
//

import UIKit
import CombineCocoa
import Combine

final class SurveyStartViewController: BaseViewController {
    private let navigationBar = CustomNavigationBar()
    private let backButton = CustomNavigationButton(.back)
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .mimunBackgound)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let titleStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 12
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "설문조사를 시작할게요!"
        label.textColor = .gray900
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "질문지를 통해서 미세먼지가\n잘 관리되고 있는지 살펴볼게요"
        label.textColor = .gray600
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 12
        return stackView
    }()
    private let nameBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.attributedPlaceholder = NSAttributedString(string: "이름을 입력해주세요", attributes: [.foregroundColor: UIColor.gray500])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        return textField
    }()
    private let schoolBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    private let schoolLabel: UILabel = {
        let label = UILabel()
        label.text = "학교를 입력해주세요"
        label.textColor = .gray500
        return label
    }()
    private let schoolTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.attributedPlaceholder = NSAttributedString(string: "학교를 입력해주세요", attributes: [.foregroundColor: UIColor.gray500])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        return textField
    }()
    private let infoStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.spacing = 10
        return stackView
    }()
    private let gradeBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    private let gradeTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.attributedPlaceholder = NSAttributedString(string: "학년", attributes: [.foregroundColor: UIColor.gray500])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        
        return textField
    }()
    private let classBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    private let classTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.attributedPlaceholder = NSAttributedString(string: "반", attributes: [.foregroundColor: UIColor.gray500])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        
        return textField
    }()
    private let numberBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    private let numberTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.attributedPlaceholder = NSAttributedString(string: "번호", attributes: [.foregroundColor: UIColor.gray500])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private let viewModel = SurveyStartViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func setUserInterface() {
        
        navigationBar.setNavigation(leftItems: [backButton])
        titleStackView.addArrangedSubViews([titleLabel, descriptionLabel])
        
        view.backgroundColor = .gray0
        view.addSubViews([navigationBar, backgroundImageView, titleStackView, textFieldStackView])
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview().dividedBy(1.2)
        }
      
    }
    
    override func bind() {
        backButton.tapPublisher.sink { [weak self] in
            self?.pop(animated: true)
        }
        .store(in: &cancellable)
    }
}
