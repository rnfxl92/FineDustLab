//
//  ResetViewController.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/9/24.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit

final class ResetViewController: BaseViewController {
    private let navigationBar = CustomNavigationBar()
    private let backButton = CustomNavigationButton(.back)
    
    private let resetButton = LargeFilledButton(title: "비밀번호 재설정", defaultTitleColor: .gray0, defaultColor: .green300, disabledTitleColor: .gray400, disabledColor: .gray200)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .gray900
        label.text = "비밀번호 재설정"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .gray600
        label.numberOfLines = 0
        label.text = "가입하신 이메일을 입력 후 비밀번호 재설정을 누르면 입력한 이메일로 비밀번호 재설정 이메일이 전송됩니다."
        return label
    }()

    private let emailStackView: UIStackView = {
        let stacView = UIStackView(axis: .vertical)
        stacView.spacing = 12
        return stacView
    }()
    
    private let emailBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
 
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.attributedPlaceholder = NSAttributedString(string: "이메일을 입력해주세요", attributes: [.foregroundColor: UIColor.gray500])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        
        textField.addHideKeyboardButton(title: "완료")
        return textField
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red200
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.text = "유효하지 않은 이메일 형식입니다."
        
        return label
    }()
    
    private let emailDescriptonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "이메일을 받지 못했다면 스팸메일함을 확인해주세요."
        
        return label
    }()
    
    private var cancellable = Set<AnyCancellable>()
    private var contentBottomConstraint: Constraint?
    private let emailRegex: String = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    private let emailCharRegex: String = "[@A-Z0-9a-z._-]"
    private let viewModel = ResetViewModel()
    
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
        navigationBar.setNavigation(title: "비밀번호 재설정", titleAlwaysVisible: true, leftItems: [backButton], rightItems: [UIView()])
        
        view.addSubViews([navigationBar, titleLabel, descriptionLabel, emailStackView, resetButton])
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        emailStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        emailStackView.addArrangedSubViews([emailBackground, warningLabel, emailDescriptonLabel])
        emailBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        emailBackground.addSubview(emailTextField)
        emailTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        warningLabel.isHidden = true
        
        emailTextField.textPublisher
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self, let text else { return }
                if text.isEmpty {
                    self.warningLabel.isHidden = true
                    self.resetButton.isEnabled = false
                    return
                }
                let validation = text.validateRegex(with: emailRegex)
                self.warningLabel.isHidden = validation
                self.resetButton.isEnabled = validation
            }
            .store(in: &cancellable)
        
        resetButton.tapPublisher.sink { [weak self] in
            guard let email = self?.emailTextField.text else { return }
            self?.viewModel.resetPassward(email: email)
        }
        .store(in: &cancellable)
        
        resetButton.snp.makeConstraints {
            contentBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16).constraint
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func bind() {
        viewModel.$state
            .sink { [weak self] state in
                guard let self else { return }
                state.isLoading ? CSGIndicator.shared.show() : CSGIndicator.shared.hide()
                switch state {
                case .sentPasswordReset(let success):
                    if success {
                        CSGToast.show("비밀번호 재설정 이메일을 발송했습니다.", view: UIApplication.shared.keyWindows?.last ?? self.view)
                    } else {
                        CSGToast.show("비밀번호 재설정 이메일 발송을 실패했습니다.", view: UIApplication.shared.keyWindows?.last ?? self.view)
                    }
                default:
                    break
                }
            }
            .store(in: &cancellable)
        
        backButton.tapPublisher.sink { [weak self] in
            self?.pop(animated: true)
        }
        .store(in: &cancellable)
    }
}

extension ResetViewController {
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
