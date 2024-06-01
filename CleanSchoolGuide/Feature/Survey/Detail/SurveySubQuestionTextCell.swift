//
//  SurveySubQuestionTextCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/1/24.
//

import UIKit
import Combine
import CombineCocoa

protocol SurveySubQuestionTextCellDelegate: AnyObject {
    func textChanged(subQuestionId: Int, answer: String)
}

final class SurveySubQuestionTextCell: UITableViewCell {
    
    private let containerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        
        return label
    }()
    
    private let textViewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.attributedPlaceholder = NSAttributedString(string: "내용을 적어주세요.", attributes: [.foregroundColor: UIColor.gray500])
        
        textField.addHideKeyboardButton(title: "완료")
        return textField
    }()
    
    private var subQuestion: SubQuestion?
    private weak var delegate: SurveySubQuestionTextCellDelegate?
    
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
        textViewBackground.addSubview(textField)
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        containerView.addSubViews([titleLabel, textViewBackground])
        
        titleLabel.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
        }
        
        textViewBackground.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.height.equalTo(56)
            $0.bottom.directionalHorizontalEdges.equalToSuperview()
        }
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        textField
            .textPublisher
            .sink { [weak self] text in
                guard let self, let text else { return }
                self.delegate?.textChanged(subQuestionId: self.subQuestion?.subQuestionID ?? 0, answer: text)
        }
            .store(in: &cancellable)
    }
    
    func setUIModel(_ subQuestion: SubQuestion, answer: String? = nil, delegate: SurveySubQuestionTextCellDelegate?) {
        self.subQuestion = subQuestion
        self.delegate = delegate
        
        titleLabel.text = subQuestion.text
        if let option = subQuestion.options.first, let placeHolder = option.placeholder {
            textField.attributedPlaceholder =  NSAttributedString(string: placeHolder, attributes: [.foregroundColor: UIColor.gray500])
        }
        textField.text = answer
    }
}
