//
//  SchoolListTableViewCell.swift
//  FineDustLab
//
//  Created by 박성민 on 4/6/24.
//

import UIKit

final class SchoolListTableViewCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray900
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray600
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray200
        
        return view
    }()
    
    private let stackView = UIStackView(axis: .vertical)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let backgoundView = UIView()
        backgoundView.backgroundColor = .gray100
        selectedBackgroundView = backgoundView
        stackView.spacing = 4
        stackView.addArrangedSubViews([nameLabel, addressLabel])
        
        contentView.addSubViews([stackView, divider])
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        divider.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(15)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
    }
    
    func setUIModel(_ model: Model) {
        nameLabel.text = model.name
        addressLabel.text = model.address
    }
    
}

extension SchoolListTableViewCell {
    struct Model {
        let name: String
        let address: String
    }
}
