//
//  SignUpSchoolCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/20/24.
//

import UIKit
import Combine
import CombineCocoa

protocol SignUpSchoolCellDelegate: AnyObject {
    func schoolTextFieldTapped()
    func gradeChanged(_ grade: Int)
    func classNumChanged(_ classNum: Int)
}

final class SignUpSchoolCell: UITableViewCell {
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
        label.text = "학교"
        
        return label
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
    
    weak var delegate: SignUpSchoolCellDelegate?
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
        gradeTextField.delegate = self
        classTextField.delegate = self
        
        schoolBackground.addSubViews([schoolLabel])
        schoolLabel.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(schoolTapped))
        schoolBackground.addGestureRecognizer(tapGesture)
        
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
        
        infoStackView.addArrangedSubViews([gradeBackground, classBackground])
        gradeBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        classBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        stackView.addArrangedSubViews([titleLabel, schoolBackground, infoStackView])
        schoolBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
        
        gradeTextField.textPublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                if let text, let grade = Int(text) {
                    self?.delegate?.gradeChanged(grade)
                }
            }
            .store(in: &cancellable)
        
        classTextField.textPublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                if let text, let classNum = Int(text) {
                    self?.delegate?.classNumChanged(classNum)
                }
            }
            .store(in: &cancellable)
        
    }
    
    @objc private func schoolTapped(_ sender: UITapGestureRecognizer) {
        delegate?.schoolTextFieldTapped()
    }
    
    func setSchool(_ school: SchoolModel) {
        schoolLabel.text = school.schulNm
        schoolLabel.textColor = .gray900
    }
}

extension SignUpSchoolCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if textField == gradeTextField {
            return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) && updatedText.count <= 1
        }
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) && updatedText.count <= 2
    }
}
