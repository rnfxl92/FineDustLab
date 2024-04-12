//
//  SurveySubQuestionNumberPickerCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/12/24.
//

import UIKit

protocol SurveySubQuestionNumberPickerCellDelegate: AnyObject {
    func numberPicked(subQuestionId: Int, optionId: Int)
}

final class SurveySubQuestionNumberPickerCell: UITableViewCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    private let textFieldBackgroud: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        return view
    }()
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .gray900
        return textField
    }()
    private lazy var numberPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        
        return label
    }()
    
    private var numbers: [Int] = []
    private var subQuestion: SubQuestion?
    private weak var delegate: SurveySubQuestionNumberPickerCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        textField.inputView = numberPickerView
        textFieldBackgroud.addSubview(textField)
        textField.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        
        stackView.addArrangedSubViews([textFieldBackgroud, descriptionLabel])
        textFieldBackgroud.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.width.equalTo(120)
        }
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.directionalVerticalEdges.equalToSuperview().inset(12)
        }
    }
    
    func setUIModel(_ subQuestion: SubQuestion, delegate: SurveySubQuestionNumberPickerCellDelegate?) {
        self.subQuestion = subQuestion
        self.delegate = delegate
        
        guard let option = subQuestion.options.first,
              let range = option.range
        else { return }
        descriptionLabel.text = option.unit
        numbers = Array(range.min...range.max)
        numberPickerView.reloadAllComponents()
        
    }
}

extension SurveySubQuestionNumberPickerCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // 1개의 컴포넌트 반환
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(numbers[row]) // 각 행에 해당하는 숫자 반환
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = "\(numbers[safe: row] ?? 0)"
        delegate?.numberPicked(subQuestionId: subQuestion?.subQuestionID ?? 0, optionId: numbers[safe: row] ?? 0)
        endEditing(true)
    }
}
