//
//  SurveySubQuestionSliderCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 5/27/24.
//

import UIKit

protocol SurveySubQuestionSliderCellDelegate: AnyObject {
    func radioButtonTapped(subQuestionId: Int, optionId: Int)
}

final class SurveySubQuestionSliderCell: UITableViewCell {
    private let containerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let connectView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        
        return view
    }()
    
    private var buttons: [SurveyRadioView] = []
    private var subQuestion: SubQuestion?
    private weak var delegate: SurveySubQuestionSliderCellDelegate?
    
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
        
        stackView.addSubview(connectView)
        connectView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(8)
            $0.top.equalToSuperview().inset(11)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        // 선택된 버튼을 제외한 나머지 버튼의 isSelected 속성을 false로 설정
        for index in 0..<buttons.count {
            guard let button = buttons[safe: index] else { return }
            
            if button == sender.view as? SurveyRadioView {
                button.isSelected = true
                if let option = subQuestion?.options[safe: index] {
                    delegate?.radioButtonTapped(subQuestionId: subQuestion?.subQuestionID ?? 0, optionId: option.id ?? 0)
                }
            } else {
                button.isSelected = false
            }
        }
    }
    
    func setUIModel(_ subQuestion: SubQuestion, answer: String? = nil, delegate: SurveySubQuestionSliderCellDelegate?) {
        self.subQuestion = subQuestion
        self.delegate = delegate
        
        buttons.removeAll()
        stackView.removeAllArrangedSubviews()
        titleLabel.text = subQuestion.text
        
        for (idx, option) in subQuestion.options.enumerated() {
            let button = SurveyRadioView()
            button.setUIModel(title: option.text ?? "")
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
            tapGesture.view?.tag = idx
            button.addGestureRecognizer(tapGesture)
            button.isUserInteractionEnabled = true
            stackView.addArrangedSubview(button)
            buttons.append(button)
            
            if let answer, let answerInt = Int(answer), let id = option.id, answerInt == id {
                button.isSelected = true
            }
        }
    }
    
}

final class SurveyRadioView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: .icUnselectRadio)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray700
        label.textAlignment = .center
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 10
        
        return stackView
    }()
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                imageView.image = .icSelectRadio
                titleLabel.textColor = .blue300
                titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
            } else {
                imageView.image = .icUnselectRadio
                titleLabel.textColor = .gray700
                titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        stackView.addArrangedSubViews([imageView, titleLabel])
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(57)
        }
    }
    
    func setUIModel(title: String) {
        titleLabel.text = title
    }
    
}
