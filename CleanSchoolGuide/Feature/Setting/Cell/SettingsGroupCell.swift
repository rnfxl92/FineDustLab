//
//  SettingsGroupCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/17/24.
//

import UIKit
import CombineCocoa
import Combine

protocol SettingsGroupCellDelegate: AnyObject {
    func changeButtonTapped()
}

final class SettingsGroupCell: UITableViewCell {
    
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
        label.text = "학습자"
        
        return label
    }()
    
    private let textFieldBackgroud: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        
        return view
    }()
    
    private let textFieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray900
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.text = Preferences.selectedUserType?.description
        
        return label
    }()
    
    private let changeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle(Preferences.selectedUserType ?? .elementary == .teacher ? "로그아웃" : "변경", for: .normal)
        button.setTitleColor(.blue300, for: .normal)
        
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "학습자 설정에 따라 설문지, 매뉴얼 내용이 달라요."
        
        return label
    }()
    weak var delegate: SettingsGroupCellDelegate?
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
        textFieldBackgroud.addSubViews([textFieldLabel, changeButton])
        textFieldLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        changeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        stackView.addArrangedSubViews([titleLabel, textFieldBackgroud, descriptionLabel])
        
        textFieldBackgroud.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        changeButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.changeButtonTapped()
            }
            .store(in: &cancellable)
    }
}
