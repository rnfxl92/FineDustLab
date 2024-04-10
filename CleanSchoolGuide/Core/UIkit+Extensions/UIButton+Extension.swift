//
//  UIButton+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 2023/03/09.
//  
//

import UIKit

extension UIButton {
    public func setVertical(with spacing: CGFloat = 0) {
        let titleSize = titleLabel?.frame.size ?? .zero
        let imageSize = imageView?.frame.size ?? .zero
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
    }

}
