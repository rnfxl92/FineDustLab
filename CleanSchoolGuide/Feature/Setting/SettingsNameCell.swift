//
//  SettingsNameCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/17/24.
//

import UIKit
import CombineCocoa
import Combine

protocol SettingsNameCellDelegate: AnyObject {
    func nameUpdated(_ name: String)
}

final class SettingsNameCell: UITableViewCell {
    
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
        label.text = "이름"
        
        return label
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
    
    weak var delegate: SettingsNameCellDelegate?
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
        nameTextField.delegate = self
        
        nameBackground.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        stackView.addArrangedSubViews([titleLabel, nameBackground])
        
        nameBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        nameTextField.textPublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let text, text.isNotEmpty else { return }
                self?.delegate?.nameUpdated(text)
            }
            .store(in: &cancellable)
        
    }
    
    func setName(_ name: String?) {
        nameTextField.text = name
    }
}

extension SettingsNameCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 5
    }
}
