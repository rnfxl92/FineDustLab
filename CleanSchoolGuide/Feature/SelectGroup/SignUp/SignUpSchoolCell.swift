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
        schoolBackground.addSubViews([schoolLabel])
        schoolLabel.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(schoolTapped))
        schoolBackground.addGestureRecognizer(tapGesture)
        
        stackView.addArrangedSubViews([titleLabel, schoolBackground])
        schoolBackground.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    @objc private func schoolTapped(_ sender: UITapGestureRecognizer) {
        delegate?.schoolTextFieldTapped()
    }
    
    func setSchool(_ school: SchoolModel) {
        schoolLabel.text = school.schulNm
        schoolLabel.textColor = .gray900
    }
}
