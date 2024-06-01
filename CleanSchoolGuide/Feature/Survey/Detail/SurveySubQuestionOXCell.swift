//
//  SurveySubQuestionCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/11/24.
//

import UIKit

protocol SurveySubQuestionOXCellDelegate: AnyObject {
    func oxButtonTapped(subQuestionId: Int, optionId: Int, showOptional: Int?)
}

final class SurveySubQuestionOXCell: UITableViewCell {
    enum OX: Int {
        case O = 1
        case X = 2
    }
    
    private let oxStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let oStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 10
        return stackView
    }()
    private let oView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        return view
    }()
    private let oLabel: UILabel = {
        let label = UILabel()
        label.text = "알고 있어요"
        label.textColor = .green300
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        
        return label
    }()
    private let oImageView: UIImageView = {
        let imageView = UIImageView(image: .O)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let xStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 10
        return stackView
    }()
    private let xView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        return view
    }()
    private let xLabel: UILabel = {
        let label = UILabel()
        label.text = "몰랐어요"
        label.textColor = .red300
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        
        return label
    }()
    private let xImageView: UIImageView = {
        let imageView = UIImageView(image: .X)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private weak var delegate: SurveySubQuestionOXCellDelegate?
    private var subQuestion: SubQuestion?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        oStackView.addArrangedSubViews([oImageView, oLabel])
        oView.addSubview(oStackView)
        let oTapGesture = UITapGestureRecognizer(target: self, action: #selector(oButtonTapped))
        oView.addGestureRecognizer(oTapGesture)
        oView.isUserInteractionEnabled = true
        oStackView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        oView.borderColor = .green300
        xStackView.addArrangedSubViews([xImageView, xLabel])
        xView.addSubview(xStackView)
        let xTapGesture = UITapGestureRecognizer(target: self, action: #selector(xButtonTapped))
        xView.addGestureRecognizer(xTapGesture)
        xView.isUserInteractionEnabled = true
        xStackView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        xView.borderColor = .red300
        oxStackView.addArrangedSubViews([oView, xView])
        contentView.addSubview(oxStackView)
        oxStackView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview()
            $0.height.equalTo(oxStackView.snp.width).multipliedBy(0.5).priority(.high)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    func setUIModel(_ subQuestion: SubQuestion, answer: String? = nil, delegate: SurveySubQuestionOXCellDelegate?) {
        self.delegate = delegate
        self.subQuestion = subQuestion
        
        oLabel.text = subQuestion.options[safe: 0]?.text
        xLabel.text = subQuestion.options[safe: 1]?.text
        
        if let answer, let anserInt = Int(answer), let ox = OX(rawValue: anserInt) {
            oxButtonUpdate(answer: ox)
        }
    }
    
    private func oxButtonUpdate(answer: OX) {
        switch answer {
        case .O:
            oLabel.font = .systemFont(ofSize: 16, weight: .bold)
            oView.borderWidth = 2
            oView.backgroundColor = .green0
            
            xLabel.font = .systemFont(ofSize: 16, weight: .regular)
            xView.borderWidth = 0
            xView.backgroundColor = .gray100
        case .X:
            oLabel.font = .systemFont(ofSize: 16, weight: .regular)
            oView.borderWidth = 0
            oView.backgroundColor = .gray100
            
            xLabel.font = .systemFont(ofSize: 16, weight: .bold)
            xView.borderWidth = 2
            xView.backgroundColor = .red0
        }
    }
    
    @objc private func oButtonTapped(_ sender: UITapGestureRecognizer) {
        oxButtonUpdate(answer: .O)
        delegate?.oxButtonTapped(subQuestionId: subQuestion?.subQuestionID ?? 0, optionId: subQuestion?.options[safe: 0]?.id ?? 0, showOptional: subQuestion?.options[safe: 0]?.next_sub_question_id)
    }
    
    @objc private func xButtonTapped(_ sender: UITapGestureRecognizer) {
        oxButtonUpdate(answer: .X)
        
        delegate?.oxButtonTapped(subQuestionId: subQuestion?.subQuestionID ?? 0, optionId: subQuestion?.options[safe: 1]?.id ?? 0, showOptional: subQuestion?.options[safe: 1]?.next_sub_question_id)
    }
}
