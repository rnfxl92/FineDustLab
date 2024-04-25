//
//  SignUpPasswordCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/21/24.
//

import UIKit
import Combine
import CombineCocoa

protocol SignUpPasswordCellDelegate: AnyObject {
    func passwordChanged(_ password: String)
    func passwordCheckChanged(_ passwordCheck: String)
    func passwordBeginFirstResponder()
}

final class SignUpPasswordCell: UITableViewCell {
    private let stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.distribution = .fill
        
        stackView.spacing = 12
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        label.text = "비밀번호"
        
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
        textField.attributedPlaceholder = NSAttributedString(string: "8자 이상 비밀번호를 설정해주세요", attributes: [.foregroundColor: UIColor.gray500])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textContentType = .newPassword
        textField.isSecureTextEntry = true
        
        textField.addHideKeyboardButton(title: "완료")
        return textField
    }()

    private let passwordCheckBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    private let passwordCheckTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 확인해주세요", attributes: [.foregroundColor: UIColor.gray500])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textContentType = .newPassword
        textField.isSecureTextEntry = true
        
        textField.addHideKeyboardButton(title: "완료")
        return textField
    }()
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red200
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.text = "비밀번호 조건에 맞게 비밀번호를 설정해 주세요."
        
        return label
    }()
    private let descriptonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "문자, 숫자, 특수문자를 혼합하여 8자 이상"
        
        return label
    }()
    
    private let passwordRegex: String = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]"
    
    weak var delegate: SignUpPasswordCellDelegate?
    private var cancellable = Set<AnyCancellable>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
        stackView.addArrangedSubViews([titleLabel, passwordBackground, passwordCheckBackground, warningLabel, descriptonLabel])
        warningLabel.isHidden = true
        passwordBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        passwordBackground.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        passwordCheckBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        passwordCheckBackground.addSubview(passwordCheckTextField)
        passwordCheckTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(80)
        }
        
        passwordTextField.textPublisher
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self, let text else { return }
                
                if text.isEmpty {
                    self.warningLabel.isHidden = true
                    return
                } else if !text.validateRegex(with: passwordRegex) {
                    self.warningLabel.isHidden = false
                    self.warningLabel.text = "비밀번호 조건에 맞게 비밀번호를 설정해 주세요."
                } else if text != passwordCheckTextField.text {
                    self.warningLabel.isHidden = false
                    self.warningLabel.text = "비밀번호가 일치하지 않습니다."
                } else {
                    self.warningLabel.isHidden = true
                }
                self.delegate?.passwordChanged(text)
            }
            .store(in: &cancellable)
        
        passwordCheckTextField.textPublisher
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self, let text else { return }
                
                if text.isEmpty {
                    self.warningLabel.isHidden = true
                } else if !(passwordTextField.text ?? "").validateRegex(with: passwordRegex) {
                    self.warningLabel.isHidden = false
                    self.warningLabel.text = "비밀번호 조건에 맞게 비밀번호를 설정해 주세요."
                } else if text != passwordTextField.text {
                    self.warningLabel.isHidden = false
                    self.warningLabel.text = "비밀번호가 일치하지 않습니다."
                } else {
                    self.warningLabel.isHidden = true
                }
                self.delegate?.passwordCheckChanged(text)
            }
            .store(in: &cancellable)
        
    }
}

extension SignUpPasswordCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.passwordBeginFirstResponder()
    }
}
