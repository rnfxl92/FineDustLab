//
//  SignUpEmailCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/20/24.
//

import UIKit
import Combine
import CombineCocoa

protocol SignUpEmailCellDelegate: AnyObject {
    func emailChanged(_ email: String)
}

final class SignUpEmailCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        label.text = "이메일"
        
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
    
    private let descriptonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "학교 이메일로만 가입할 수 있어요"
        
        return label
    }()
    
    //    private let emailRegex = "^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9.-]+\\.)?ac\\.kr$"
        private let emailRegex: String = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        private let emailCharRegex: String = "[@A-Z0-9a-z._-]"
    weak var delegate: SignUpEmailCellDelegate?
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
        emailStackView.addArrangedSubViews([titleLabel, emailBackground, warningLabel, descriptonLabel])
        emailBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        emailBackground.addSubview(emailTextField)
        emailTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        warningLabel.isHidden = true
        contentView.addSubViews([emailStackView]) 
        emailStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(40)
        }
        
        emailTextField.textPublisher
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self, let text else { return }
                self.delegate?.emailChanged(text)
                if text.isEmpty {
                    self.warningLabel.isHidden = true
                    return
                }
                
                self.warningLabel.isHidden = text.validateRegex(with: emailRegex)
            }
            .store(in: &cancellable)
    }
    
}
