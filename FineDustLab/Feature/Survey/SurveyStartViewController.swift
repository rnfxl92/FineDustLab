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
    
    private let termsAgreeView: UIView = UIView()
    private let termsStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.spacing = 8
        return stackView
    }()
    private let termsAgreeCheckImageView: UIImageView = {
        let imageView = UIImageView(image: .checkN)
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    private let agreeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        let str = NSAttributedString(string: "개인정보 동의(필수)")
            .addAttributes("(필수)", attributes: [.foregroundColor: UIColor.gray400])
            .addAttributes("개인정보 동의", attributes: [.foregroundColor: UIColor.gray700])
        label.attributedText = str
        return label
    }()
    private let viewTermsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitle("내용 보기", for: .normal)
        button.setTitleColor(.gray600, for: .normal)
        
        button.setUnderlined()
        
        return button
    }()
    
    private let startButton = LargeFilledButton(title: "시작하기", defaultTitleColor: .gray0, defaultColor: .green300, disabledTitleColor: .gray400, disabledColor: .gray200)
    
    private let viewModel = SurveyStartViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func setUserInterface() {
        
        navigationBar.setNavigation(leftItems: [backButton])
        titleStackView.addArrangedSubViews([titleLabel, descriptionLabel])
        let schoolTapGesture = UITapGestureRecognizer(target: self, action: #selector(showSchoolSearchBottomSheet))
        schoolBackground.addGestureRecognizer(schoolTapGesture)
        let agreeTapGesture = UITapGestureRecognizer(target: self, action: #selector(agreeTerms))
        termsAgreeView.addGestureRecognizer(agreeTapGesture)
        
        view.backgroundColor = .gray0
        view.addSubViews([navigationBar, backgroundImageView, titleStackView, textFieldStackView, termsAgreeView, startButton])
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
        
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
      
        termsStackView.addArrangedSubViews([termsAgreeCheckImageView, agreeLabel])
        termsAgreeCheckImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        termsAgreeView.addSubViews([termsStackView, viewTermsButton])
        termsStackView.snp.makeConstraints {
            $0.directionalVerticalEdges.leading.equalToSuperview()
        }
        viewTermsButton.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(termsStackView).inset(12)
            $0.trailing.centerY.equalToSuperview()
        }
        termsAgreeView.snp.makeConstraints {
            $0.bottom.equalTo(startButton.snp.top).offset(-16)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        nameBackground.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        schoolBackground.addSubViews([schoolLabel])
        schoolLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        textFieldStackView.addArrangedSubViews([nameBackground, schoolBackground])
        
        nameBackground.snp.makeConstraints {
            $0.height.equalTo(62)
        }
        schoolBackground.snp.makeConstraints {
            $0.height.equalTo(62)
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(termsAgreeView.snp.top).offset(-150)
        }
    }
    
    override func bind() {
        backButton.tapPublisher.sink { [weak self] in
            self?.pop(animated: true)
        }
        .store(in: &cancellable)
        
        startButton.tapPublisher.sink { [weak self] in
            print("start")
        }
        .store(in: &cancellable)
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .schoolUpdated(let school):
                    self?.schoolLabel.textColor = .gray900
                    self?.schoolLabel.text = school?.schulNm
                case .agreeUpdated(let isAgree):
                    self?.termsAgreeCheckImageView.image = isAgree ? .checkS : .checkN
                default:
                    break
                }
                self?.updateStartButton()
            }
            .store(in: &cancellable)
    }
    
    @objc private func showSchoolSearchBottomSheet() {
        let vc = SchoolSearchBottomSheetController { [weak self] school in
            self?.viewModel.schoolUpdated(school)
        }
        
        presentBottomSheet(vc)
    }
    
    @objc private func agreeTerms() {
        viewModel.agreeButtonTapped()
    }
    
    private func updateStartButton() {
        startButton.isEnabled = viewModel.canStart
    }
}
