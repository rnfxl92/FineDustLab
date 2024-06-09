//
//  FindEmailViewController.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/1/24.
//

import UIKit
import Combine
import SnapKit

final class FindEmailViewController: BaseViewController {
    private let navigationBar = CustomNavigationBar()
    private let backButton = CustomNavigationButton(.back)
    
    private let findButton = LargeFilledButton(title: "이메일 찾기", defaultTitleColor: .gray0, defaultColor: .green300, disabledTitleColor: .gray400, disabledColor: .gray200)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .gray900
        label.text = "이메일 찾기"
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.distribution = .fill
        
        stackView.spacing = 12
        return stackView
    }()
    
    private let nameTextFieldBackgroud: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        
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
        
        return view
    }()
    
    private let schoolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.text = "학교를 입력해 주세요"
        
        return label
    }()
    
    private let viewModel = FindEmailViewModel()
    private var cancellable = Set<AnyCancellable>()
    private var contentBottomConstraint: Constraint?
    
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
        view.backgroundColor = .gray0
        hideKeyboardWhenTappedAround()
        
        navigationBar.setNavigation(title: "이메일 찾기", titleAlwaysVisible: true, leftItems: [backButton], rightItems: [UIView()])
        
        view.addSubViews([navigationBar, titleLabel, stackView, findButton])
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        stackView.addArrangedSubViews([nameTextFieldBackgroud, schoolBackground])
        nameTextFieldBackgroud.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        schoolBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        let schoolTapGesture = UITapGestureRecognizer(target: self, action: #selector(showSchoolSearchBottomSheet))
        schoolBackground.addGestureRecognizer(schoolTapGesture)
        
        schoolBackground.addSubViews([schoolLabel])
        schoolLabel.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        nameTextFieldBackgroud.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        nameTextField.textPublisher.sink { [weak self] text in
            self?.viewModel.nameUpdate(text ?? "")
        }
        .store(in: &cancellable)
        
        findButton.tapPublisher.sink { [weak self] in
            self?.viewModel.findEmailRequst()
        }
        .store(in: &cancellable)
        
        findButton.snp.makeConstraints {
            contentBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16).constraint
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func bind() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                state.isLoading ? CSGIndicator.shared.show() : CSGIndicator.shared.hide()
                switch state {
                case .schoolSelected(let school):
                    self.schoolLabel.textColor = .gray900
                    self.schoolLabel.text = school?.schulNm
                case .findSuccessed(let email):
                    let vc = PopupViewController(
                        type: .single,
                        title: "등록된 이메일",
                        description: email,
                        defualtTitle: "확인",
                        completion: { [weak self] in
                        self?.pop(animated: true)
                    })
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc: vc, animated: true)
                    
                case .findFailed:
                    CSGToast.show("아래 정보로 등록된 계정이 없습니다.", view: UIApplication.shared.keyWindows?.last ?? self.view)
                default:
                    break
                }
                self.updateStartButton()
            }
            .store(in: &cancellable)
        
        backButton.tapPublisher.sink { [weak self] in
            self?.pop(animated: true)
        }
        .store(in: &cancellable)
    }
    
    @objc private func showSchoolSearchBottomSheet() {
        let vc = SchoolSearchBottomSheetController { [weak self] school in
            self?.viewModel.schoolUpdated(school)
        }
        
        presentBottomSheet(vc)
    }
    
    private func updateStartButton() {
        findButton.isEnabled = viewModel.canFind
    }
    
}

extension FindEmailViewController {
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
