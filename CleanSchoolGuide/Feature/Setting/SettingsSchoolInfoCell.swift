//
//  SettingsSchoolInfoCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/17/24.
//

import UIKit
import CombineCocoa
import Combine

protocol SettingsSchoolInfoCellDelegate: AnyObject {
    func schoolChangeButtonTapped()
}

final class SettingsSchoolInfoCell: UITableViewCell {
    
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
        label.textColor = .gray900
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.text = Preferences.userInfo?.school.schulNm
        
        return label
    }()
    
    private let changeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("변경", for: .normal)
        button.setTitleColor(.blue300, for: .normal)
        
        return button
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
        if let grade = Preferences.userInfo?.grade {
            textField.text = String(grade)
        }
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
        if let classNum = Preferences.userInfo?.classNum {
            textField.text = String(classNum)
        }
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
        if let studentNum = Preferences.userInfo?.studentNum {
            textField.text = String(studentNum)
        }
        textField.addHideKeyboardButton(title: "완료")
        return textField
    }()
    
    weak var delegate: SettingsSchoolInfoCellDelegate?
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
        numberTextField.delegate = self
        
        schoolBackground.addSubViews([schoolLabel, changeButton])
        schoolLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        changeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        schoolBackground.snp.makeConstraints {
            $0.height.equalTo(56)
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
            $0.height.equalTo(56)
        }
        classBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        numberBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        stackView.addArrangedSubViews([titleLabel, schoolBackground, infoStackView])
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        changeButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.schoolChangeButtonTapped()
            }
            .store(in: &cancellable)
        
    }
    
    func setSchool(_ school: SchoolModel) {
        schoolLabel.text = school.schulNm
    }
    
    func getSchoolInfo() -> (grade: Int?, classNum: Int?, studentNum: Int?)  {
        var grade: Int?
        var classNum: Int?
        var studentNum: Int?
        
        if let gStr = gradeTextField.text {
            grade = Int(gStr)
        }
        if let cStr = classTextField.text {
            classNum = Int(cStr)
        }
        if let sStr = numberTextField.text {
            studentNum = Int(sStr)
        }
        
        return (grade: grade, classNum: classNum, studentNum: studentNum)
    }
}

extension SettingsSchoolInfoCell: UITextFieldDelegate {
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
