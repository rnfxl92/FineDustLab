//
//  ManualListHeaderView.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/14/24.
//

import UIKit

final class ManualListHeaderView: UIView {
    
    private let chapterView: UIView = {
        let view = UIView()
        view.backgroundColor = .green0
        view.cornerRadius = 6
        return view
    }()
    
    private let chapterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .green400
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .gray700
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        chapterView.addSubview(chapterLabel)
        chapterLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(8)
        }
        
        addSubViews([chapterView, titleLabel])
        
        chapterView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(chapterView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setUIModel(chapter: String, title: String) {
        chapterLabel.text = chapter
        titleLabel.text = title
    }
}
