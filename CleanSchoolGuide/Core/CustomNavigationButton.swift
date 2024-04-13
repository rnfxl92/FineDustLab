//
//  CustomNavigationButton.swift
//  FineDustLab
//
//  Created by 박성민 on 4/4/24.
//

import UIKit

class CustomNavigationButton: UIButton {
    enum ButtonType {
//        case close
        case back
        case search
        case custom(UIImage?)
        case text(String)
        case attributedText(NSAttributedString)
        
        var image: UIImage? {
            switch self {
//            case .close:
//                return .ic24Close
            case .back:
                return .icLeft
            case .search:
                return .search
            case .custom(let image):
                return image
            case .text:
                return nil
            case .attributedText:
                return nil
            }
        }
    }
    
    convenience init(_ type: ButtonType, tintColor: UIColor = .gray900) {
        switch type {
        case let .text(text):
            self.init(text)
        case let .attributedText(text):
            self.init(text)
        default:
            self.init(type.image, tintColor: tintColor)
        }
    }
    
    private init(_ image: UIImage?, tintColor: UIColor = .gray900) {
        super.init(frame: .zero)
        self.tintColor = tintColor
        setImage(image, for: .normal)
        
        snp.makeConstraints { make in
            make.size.equalTo(40)
        }
    }
    
    private init(_ text: String) {
        super.init(frame: .zero)
        
        setTitle(text, for: .normal)
        setTitleColor(.gray900, for: .normal)
        titleLabel?.font = .body.regular
        
        snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(intrinsicContentSize.width + 16)
        }
    }
    
    private init(_ attStr: NSAttributedString) {
        super.init(frame: .zero)
        
        setAttributedTitle(attStr, for: .normal)
        titleLabel?.font = .body.regular
        
        snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(intrinsicContentSize.width + 16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
