//
//  LargeFilledButton.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit

final class LargeFilledButton: UIButton {
    var isDimmed = false {
        didSet {
            setDimmed(isDimmed)
        }
    }
    
    init(title: String,
         defaultTitleColor: UIColor = .gray0,
         defaultColor: UIColor = .green400,
         font: UIFont = .body.bold
    ) {
        super.init(frame: .zero)
    
        setTitle(title, for: .normal)
        titleLabel?.font = font
        titleEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        
        setBackgroundColor(color: defaultColor, forState: .normal)
        setTitleColor(defaultTitleColor, for: .normal)
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.greaterThanOrEqualTo(intrinsicContentSize.width + 48)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDimmed(_ isDimmed: Bool) {
        setBackgroundColor(color: isDimmed ? .gray200 : .green400, forState: .normal)
        setBackgroundColor(color: isDimmed ? .gray200 : .green400, forState: .highlighted)
    }
}
