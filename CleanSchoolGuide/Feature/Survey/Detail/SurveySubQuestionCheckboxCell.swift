//
//  SurveySubQuestionCheckboxCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/12/24.
//

import UIKit

protocol SurveySubQuestionCheckboxCellDelegate: AnyObject {
    func checkboxTapped(subQuestionId: Int, answer: String)
}

final class SurveySubQuestionCheckboxCell: UITableViewCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 12

        return stackView
    }()
    
    private var buttons: [SurveyCheckboxButton] = []
    private var subQuestion: SubQuestion?
    private weak var delegate: SurveySubQuestionCheckboxCellDelegate?
    
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
    }
    
    @objc private func toggleCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let subQuestion else { return }
        var answer = ""
        for idx in 0..<buttons.count {
            if buttons[safe: idx]?.isSelected ?? false {
                answer += "\(subQuestion.options[safe: idx]?.id ?? 0),"
            }
        }
        delegate?.checkboxTapped(subQuestionId: subQuestion.subQuestionID, answer: answer)
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
        
        contentHorizontalAlignment = .leading
        titleEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 0)
        
        snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(intrinsicContentSize.width + 14)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
