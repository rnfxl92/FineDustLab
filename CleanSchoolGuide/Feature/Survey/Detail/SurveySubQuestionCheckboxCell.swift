//
//  SurveySubQuestionCheckboxCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/12/24.
//

import UIKit
import Combine

protocol SurveySubQuestionCheckboxCellDelegate: AnyObject {
    func checkboxTapped(subQuestionId: Int, answer: String, needInput: Bool)
    func textUpdated(subQuestionId: Int, optionId: Int, text: String)
    func updateLayout()
}

final class SurveySubQuestionCheckboxCell: UITableViewCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 12

        return stackView
    }()
    
    private let textField = SubQeustionInputView ()
    private var buttons: [SurveyCheckboxButton] = []
    private var subQuestion: SubQuestion?
    private weak var delegate: SurveySubQuestionCheckboxCellDelegate?
    private var selectedOptionId: Int?
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
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview().inset(24)
        }
        
        textField.textField.textPublisher.sink { [weak self] text in
            guard let self, let text, let selectedOptionId else { return }
            self.delegate?.textUpdated(subQuestionId: subQuestion?.subQuestionID ?? 0, optionId: selectedOptionId, text: text)
        }
        .store(in: &cancellable)
    }
    
    @objc private func toggleCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let subQuestion else { return }
        var answer = ""
        var needInput = false
        for idx in 0..<buttons.count {
            if buttons[safe: idx]?.isSelected ?? false {
                answer += "\(subQuestion.options[safe: idx]?.id ?? 0),"
                if let option = subQuestion.options[safe: idx], option.input ?? false {
                    selectedOptionId = option.id
                    if let placeHolder = option.placeholder {
                        textField.textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [.foregroundColor: UIColor.gray500])
                    }
                    stackView.insertArrangedSubview(textField, at: idx + 1)
                    needInput = true
                }
            } else if let option = subQuestion.options[safe: idx], option.input ?? false {
                textField.textField.text = ""
                if let selectedOptionId = option.id {
                    self.delegate?.textUpdated(subQuestionId: subQuestion.subQuestionID, optionId: selectedOptionId, text: textField.textField.text ?? "")
                }
                
                textField.removeFromSuperview()
            }
        }
        delegate?.updateLayout()
        
        delegate?.checkboxTapped(subQuestionId: subQuestion.subQuestionID, answer: answer, needInput: needInput)
    }
    
    func setUIModel(_ subQuestion: SubQuestion, answer: String? = nil, delegate: SurveySubQuestionCheckboxCellDelegate?) {
        self.subQuestion = subQuestion
        self.delegate = delegate
        
        buttons.removeAll()
        stackView.removeAllArrangedSubviews()
        let defaultAnswer = answer?.components(separatedBy: ",")
            .map { Int($0) }
            .filter { $0 != nil }
            .map { $0! }
        
        for option in subQuestion.options {
            let button = SurveyCheckboxButton(title: option.text ?? "")
            button.addTarget(self, action: #selector(toggleCheckBox), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
            if let id = option.id, let defaultAnswer, defaultAnswer.contains(id) {
                button.isSelected = true
            }
        }
    }
}

final class SurveyCheckboxButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        setTitle(title, for: .normal)
        setTitleColor(.gray900, for: .normal)
        setImage(.checkN, for: .normal)
        setImage(.checkS, for: .selected)
        
        setBackgroundColor(color: .gray100, forState: .normal)
        contentHorizontalAlignment = .leading
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 8, left: 28, bottom: 8, right: 0)
        
        snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.greaterThanOrEqualTo(intrinsicContentSize.width + 14)
        }
        cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
