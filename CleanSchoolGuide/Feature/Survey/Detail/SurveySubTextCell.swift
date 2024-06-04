//
//  SurveySubTextCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/4/24.
//

import UIKit

final class SurveySubTextCell: UITableViewCell {
    
    private let subText: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray600
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(subText)
        subText.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.directionalVerticalEdges.equalToSuperview()
        }
    }
    
    func setUIModel(_ text: String) {
        subText.text = text
    }
}
