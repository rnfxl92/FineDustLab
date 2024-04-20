//
//  LoginBottomSheetController.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/18/24.
//

import UIKit
import Combine
import CombineCocoa

final class LoginBottomSheetController: BaseViewController, BottomSheetPresentable {
    
    private let titleStackView: UIStackView = {
        let stacView = UIStackView(axis: .vertical)
        stacView.spacing = 12
        return stacView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray900
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.text = "로그인"
        
        return label
    }()
    
    private let decriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        
        let str = "회원가입 후 만드신 이메일로 로그인해 주세요.".underlined(string: "회원가입")
        label.attributedText = str.addAttributes(
            "회원가입 후 만드신 이메일로 로그인해 주세요.",
            attributes: [.foregroundColor: UIColor.gray500]
        )
        return label
    }()
    
    private let emailStackView: UIStackView = {
        let stacView = UIStackView(axis: .vertical)
        stacView.spacing = 8
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

    private let passwordBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력해주세요", attributes: [.foregroundColor: UIColor.gray500])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        
        textField.addHideKeyboardButton(title: "완료")
        return textField
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.spacing = 12
        return stackView
    }()
    private let signUpButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.gray700, for: .normal)
        
        return button
    }()
    private let findEmailButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitle("이메일 찾기", for: .normal)
        button.setTitleColor(.gray700, for: .normal)
        
        return button
    }()
    private let resetPasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitle("비밀번호 재설정", for: .normal)
        button.setTitleColor(.gray700, for: .normal)
        
        return button
    }()
    private let divider1: UIView = {
        let view = UIView()
        view.backgroundColor = .gray400
        
        return view
    }()
    private let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray400
        
        return view
    }()
    
    private let logInButton = LargeFloatingButtonView(.single, defaultTitle: "로그인")
    
//    private let emailRegex = "^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9.-]+\\.)?ac\\.kr$"
    private let emailRegex: String = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    private let emailCharRegex: String = "[@A-Z0-9a-z._-]"
    
    private var cancellable = Set<AnyCancellable>()
    private let viewModel = LoginBottomSheetViewModel()
    
    override func setUserInterface() {
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .gray0
        titleStackView.addArrangedSubViews([titleLabel, decriptionLabel])
        
        emailStackView.addArrangedSubViews([emailBackground, warningLabel])
        emailBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        emailBackground.addSubview(emailTextField)
        emailTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        buttonStackView.addArrangedSubViews([signUpButton, divider1, findEmailButton, divider2, resetPasswordButton])
        
        divider1.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(14)
        }
        divider2.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(14)
        }
        
        view.addSubViews([titleStackView, emailStackView, passwordBackground, buttonStackView, logInButton])
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        emailStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(36)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        passwordBackground.addSubview(passwordTextField)
        passwordBackground.snp.makeConstraints {
            $0.top.equalTo(emailStackView.snp.bottom).offset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
        passwordTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(passwordBackground.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        logInButton.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        warningLabel.isHidden = true
        logInButton.isEnable = false
    }
    
    override func bind() {
        emailTextField.textPublisher
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self, let text else { return }
                if text.isEmpty {
                    self.warningLabel.isHidden = true
                    return
                }
                
                self.warningLabel.isHidden = text.validateRegex(with: emailRegex)
                self.checkLogin()
            }
            .store(in: &cancellable)
        
        passwordTextField.textPublisher
            .debounce(for: 1, scheduler:  DispatchQueue.main)
            .sink { [weak self] text in
                guard let self, let text else { return }
                self.checkLogin()
            }
            .store(in: &cancellable)
        
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                state.isLoading ? CSGIndicator.shared.show() : CSGIndicator.shared.hide()
                switch state {
                case .loginSuccessed:
                    Preferences.selectedUserType = .teacher
                    AppRouter.shared.route(to: .home)
                case .loginFailed:
                    let vc = PopupViewController(type: .single, description: "아이디 또는 비밀번호가\n잘못되었습니다.", defualtTitle: "확인")
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self?.present(vc: vc, animated: true)
                default:
                    break
                }
            }
            .store(in: &cancellable)
        
        logInButton
            .defaultTapPublisher
            .sink { [weak self] in
                guard let self,
                      let email = emailTextField.text,
                      let password = passwordTextField.text else { return }
                self.viewModel.requestLogin(email: email, password: password)
            }
            .store(in: &cancellable)
        
        signUpButton.tapPublisher
            .sink { [weak self] in
                self?.dismiss(animated: true) {
                    AppRouter.shared.route(to: .signUp)
                }
            }
            .store(in: &cancellable)
    }
    
    private func checkLogin() {
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        logInButton.isEnable = email.validateRegex(with: emailRegex) && password.count > 7
    }
}

extension LoginBottomSheetController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.isEmpty && !string.validateRegex(with: emailCharRegex) { return false }
        return true
    }
}
