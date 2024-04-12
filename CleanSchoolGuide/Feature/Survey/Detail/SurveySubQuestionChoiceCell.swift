//
//  SurveySubQuestionChoiceCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/12/24.
//

import UIKit

protocol SurveySubQuestionChoiceCellDelegate: AnyObject {
    func choiceButtonTapped(subQuestionId: Int, optionId: Int)
}

final class SurveySubQuestionChoiceCell: UITableViewCell {
    
    private let containerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    private var buttons: [SurveyChoiceButton] = []
    private var subQuestion: SubQuestion?
    private weak var delegate: SurveySubQuestionChoiceCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        containerView.addSubViews([titleLabel, stackView])
        
        titleLabel.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.bottom.directionalHorizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        // 선택된 버튼을 제외한 나머지 버튼의 isSelected 속성을 false로 설정
        for index in 0..<buttons.count {
            guard let button = buttons[safe: index] else { return }
            
            if button == sender {
                button.isSelected = true
                if let option = subQuestion?.options[safe: index] {
                    delegate?.choiceButtonTapped(subQuestionId: subQuestion?.subQuestionID ?? 0, optionId: option.id ?? 0)
                }
            } else {
                button.isSelected = false
            }
        }
    }
    
    func setUIModel(_ subQuestion: SubQuestion, delegate: SurveySubQuestionChoiceCellDelegate?) {
        self.subQuestion = subQuestion
        self.delegate = delegate
        
        buttons.removeAll()
        stackView.removeAllArrangedSubviews()
        titleLabel.text = subQuestion.text
        for option in subQuestion.options {
            let button = SurveyChoiceButton(title: option.text ?? "")
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
}

final class SurveyChoiceButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            borderWidth = isSelected ? 2 : 0
            titleLabel?.font = isSelected ? .systemFont(ofSize: 16, weight: .bold) : .systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        setTitle(title, for: .normal)
        setTitleColor(.gray900, for: .normal)
        setTitleColor(.green300, for: .selected)
        setBackgroundColor(color: .gray100, forState: .normal)
        borderColor = .green300
        
        layer.cornerRadius = 14
        layer.masksToBounds = true
        
        snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.greaterThanOrEqualTo(intrinsicContentSize.width + 48)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}