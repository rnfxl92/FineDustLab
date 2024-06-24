//
//  SignUpButtonCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/21/24.
//

import UIKit
import Combine
import CombineCocoa

protocol SignUpButtonCellDelegate: AnyObject {
    func termsAgreeTapped()
    func signUpButtonTapped()
}

final class SignUpButtonCell: UITableViewCell {
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
    
    private let signUpButton = LargeFilledButton(title: "가입하기", defaultTitleColor: .gray0, defaultColor: .green300, disabledTitleColor: .gray400, disabledColor: .gray200)
    
    weak var delegate: SignUpButtonCellDelegate?
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
        let agreeTapGesture = UITapGestureRecognizer(target: self, action: #selector(agreeTerms))
        termsAgreeView.addGestureRecognizer(agreeTapGesture)
        signUpButton.isEnabled = false
        
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
        
        contentView.addSubViews([termsAgreeView, signUpButton])
        termsAgreeView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(termsAgreeView.snp.bottom).offset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        signUpButton.tapPublisher
            .sink { [weak self] in
                self?.delegate?.signUpButtonTapped()
            }
            .store(in: &cancellable)
        
        viewTermsButton
            .tapPublisher
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .sink {
                AppRouter.shared.route(to: .terms)
        }
        .store(in: &cancellable)
    }
    
    @objc private func agreeTerms() {
        delegate?.termsAgreeTapped()
    }
    
    func setUIModel(_ isSignUpable: Bool, isTermsAgreed: Bool) {
        signUpButton.isEnabled = isSignUpable
        termsAgreeCheckImageView.image = isTermsAgreed ? .checkS : .checkN
    }
}
