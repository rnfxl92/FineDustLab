//
//  SurveyStartViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 4/2/24.
//

import UIKit
import CombineCocoa
import Combine
import SnapKit

final class SurveyStartViewController: BaseViewController {
    private let navigationBar = CustomNavigationBar()
    private let backButton = CustomNavigationButton(.back)
    
    private let backgroundColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue100
        return view
    }()
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .imgSurvey)
        imageView.contentMode = .scaleAspectFill
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
        textField.addHideKeyboardButton(title: "완료")
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
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let infoStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let gradeBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    private let gradeLabel: UILabel = {
        let label = UILabel()
        label.text = "학년"
        label.textColor = .gray700
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    private let gradeTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.addHideKeyboardButton(title: "완료")
        return textField
    }()
    private let classBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    private let classLabel: UILabel = {
        let label = UILabel()
        label.text = "반"
        label.textColor = .gray700
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    private let classTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.addHideKeyboardButton(title: "완료")
        return textField
    }()
    private let numberBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "번"
        label.textColor = .gray700
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    private let numberTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.addHideKeyboardButton(title: "완료")
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
    private var contentBottomConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchSurveyData()
        viewModel.getUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setUserInterface() {
        hideKeyboardWhenTappedAround()
        navigationBar.setNavigation(leftItems: [backButton])
        titleStackView.addArrangedSubViews([titleLabel, descriptionLabel])
        let schoolTapGesture = UITapGestureRecognizer(target: self, action: #selector(showSchoolSearchBottomSheet))
        schoolBackground.addGestureRecognizer(schoolTapGesture)
        let agreeTapGesture = UITapGestureRecognizer(target: self, action: #selector(agreeTerms))
        nameTextField.delegate = self
        gradeTextField.delegate = self
        classTextField.delegate = self
        numberTextField.delegate = self
        termsAgreeView.addGestureRecognizer(agreeTapGesture)
        startButton.isEnabled = false
        
        backgroundColorView.addSubview(backgroundImageView)
        view.backgroundColor = .gray0
        view.addSubViews([backgroundColorView, navigationBar, titleStackView, textFieldStackView, termsAgreeView, startButton])
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        backgroundColorView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(1.9)
        }
        backgroundImageView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            contentBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16).constraint
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
        textFieldStackView.addArrangedSubViews([nameBackground, schoolBackground, infoStackView])
        
        nameBackground.snp.makeConstraints {
            $0.height.equalTo(62)
        }
        schoolBackground.snp.makeConstraints {
            $0.height.equalTo(62)
        }
        gradeBackground.addSubViews([gradeTextField, gradeLabel])
        gradeTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        gradeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(gradeTextField.snp.trailing).offset(8).priority(.high)
            $0.trailing.equalToSuperview().inset(16)
        }
        classBackground.addSubViews([classTextField, classLabel])
        classTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        classLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(classTextField.snp.trailing).offset(8).priority(.high)
            $0.trailing.equalToSuperview().inset(16)
        }
        numberBackground.addSubViews([numberTextField, numberLabel])
        numberTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        numberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(numberTextField.snp.trailing).offset(8).priority(.high)
            $0.trailing.equalToSuperview().inset(16)
        }
        if Preferences.selectedUserType == .teacher {
            infoStackView.addArrangedSubViews([gradeBackground, classBackground])
        } else {
            infoStackView.addArrangedSubViews([gradeBackground, classBackground, numberBackground])
        }
        gradeBackground.snp.makeConstraints {
            $0.height.equalTo(62)
        }
        classBackground.snp.makeConstraints {
            $0.height.equalTo(62)
        }
        numberBackground.snp.makeConstraints {
            $0.height.equalTo(62)
        }
        infoStackView.isHidden = true
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
        
        viewTermsButton
            .tapPublisher
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .sink {
                AppRouter.shared.route(to: .terms)
        }
        .store(in: &cancellable)
        
        startButton.tapPublisher
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.saveUserData()
            }
            .store(in: &cancellable)
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .schoolSelected(let school):
                    self?.schoolLabel.textColor = .gray900
                    self?.schoolLabel.text = school?.schulNm
                    self?.infoStackView.isHidden = false
                case .agreeUpdated(let isAgree):
                    self?.termsAgreeCheckImageView.image = isAgree ? .checkS : .checkN
                case .userDataSaved(let success):
                    if success {
                        AppRouter.shared.route(to: .surveyDetail(currentIndex: 0))
                    }
                case .getUserInfo(let userInfo):
                    self?.nameTextField.text = userInfo.name
                    self?.schoolLabel.text = userInfo.school.schulNm
                    self?.schoolLabel.textColor = .gray900
                    self?.infoStackView.isHidden = false
                    self?.classTextField.text = "\(userInfo.classNum)"
                    self?.gradeTextField.text = "\(userInfo.grade)"
                    if let number = userInfo.studentNum {
                        self?.numberTextField.text = "\(number)"
                    }
                default:
                    break
                }
                self?.updateStartButton()
            }
            .store(in: &cancellable)
        
        nameTextField.textPublisher.sink { [weak self] text in
            self?.viewModel.nameUpdate(text ?? "")
        }
        .store(in: &cancellable)
        
        gradeTextField.textPublisher.sink { [weak self] text in
            self?.viewModel.gradeUpdate(Int(text ?? ""))
        }
        .store(in: &cancellable)
        
        classTextField.textPublisher.sink { [weak self] text in
            self?.viewModel.classUpdate(Int(text ?? ""))
        }
        .store(in: &cancellable)
        
        numberTextField.textPublisher.sink { [weak self] text in
            self?.viewModel.numberUpdate(Int(text ?? ""))
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

extension SurveyStartViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if textField == nameTextField {
            return updatedText.count <= 5
        } else if textField == gradeTextField {
            return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) && updatedText.count <= 1
        }
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) && updatedText.count <= 2
    }
}

extension SurveyStartViewController {
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            contentBottomConstraint?.update(inset: (keyboardSize.height * 1 / 3) - view.safeAreaInsets.bottom)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        contentBottomConstraint?.update(inset: 16)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
