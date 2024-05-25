//
//  SurveyHelpCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 5/25/24.
//

import UIKit

final class SurveyHelpCell: UITableViewCell {
    
    private let helpView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange0
        view.cornerRadius = 18
        return view
    }()
    
    private let helpLabel: UILabel = {
        let label = UILabel()
        label.text = "💡도움말"
        label.textColor = .orange300
        return label
    }()
    
    private let helpImageView: UIImageView = {
       let imageView = UIImageView()
        
        return imageView
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
       
        helpView.addSubview(helpLabel)
        helpLabel.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(14)
        }
        contentView.addSubViews([helpView, helpImageView])
        
        helpView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        
        helpImageView.snp.makeConstraints {
            $0.top.equalTo(helpView.snp.bottom).offset(8)
            $0.bottom.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    func setUIModel(imageUrl: String) {
        helpImageView.loadImage(url: URL(string: imageUrl))
    }
}

