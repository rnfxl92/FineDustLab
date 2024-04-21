//
//  FineDustCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/21/24.
//

import UIKit
import Combine

final class FineDustCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.cornerRadius = 20
        view.borderWidth = 1
        view.borderColor = .gray200
        view.backgroundColor = .gray0
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray700
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
    
    func setUIModel(_ indexPath: Int, isSelected: Bool, viewType: HomeFineDustView.ViewType) {
        containerView.backgroundColor = isSelected
        ? viewType.selectedColor.withAlphaComponent(0.2)
        : .gray0
        
        containerView.borderColor = isSelected ? viewType.selectedColor : .gray200
        titleLabel.font = isSelected ? .systemFont(ofSize: 13, weight: .bold) : .systemFont(ofSize: 13, weight: .regular)
        titleLabel.textColor = isSelected ? viewType.selectedColor : .gray700
        titleLabel.text = viewType.valueTitle[safe: indexPath]
    }
}
