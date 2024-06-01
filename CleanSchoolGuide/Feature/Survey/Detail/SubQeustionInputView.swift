//
//  SubQeustionInputView.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/1/24.
//

import UIKit

final class SubQeustionInputView: UIView {
    
    private let textViewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.attributedPlaceholder = NSAttributedString(string: "내용을 적어주세요.", attributes: [.foregroundColor: UIColor.gray500])
        
        textField.addHideKeyboardButton(title: "완료")
        return textField
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        textViewBackground.addSubview(textField)
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        addSubview(textViewBackground)
        textViewBackground.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        cornerRadius = 14
        snp.makeConstraints {
            $0.height.equalTo(56)
        }
    }
}
