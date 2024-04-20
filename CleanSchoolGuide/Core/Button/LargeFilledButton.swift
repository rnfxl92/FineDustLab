//
//  LargeFilledButton.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit

final class LargeFilledButton: UIButton {
    private let defaultTitleColor: UIColor
    private let defaultColor: UIColor
    private let disabledColor: UIColor
    private let disabledTitleColor: UIColor

    init(title: String,
         defaultTitleColor: UIColor = .gray0,
         defaultColor: UIColor = .green400,
         disabledTitleColor: UIColor = .gray400,
         disabledColor: UIColor = .gray200,
         font: UIFont = .systemFont(ofSize: 16, weight: .semibold)
    ) {
        self.defaultColor = defaultColor
        self.defaultTitleColor = defaultTitleColor
        self.disabledTitleColor = disabledTitleColor
        self.disabledColor = disabledColor
        
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        titleLabel?.font = font
        titleEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        
        setBackgroundColor(color: defaultColor, forState: .normal)
        setBackgroundColor(color: disabledColor, forState: .disabled)
        setTitleColor(defaultTitleColor, for: .normal)
        setTitleColor(disabledTitleColor, for: .disabled)
        
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
    
}
