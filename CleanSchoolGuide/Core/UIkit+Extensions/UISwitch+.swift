//
//  UISwitch+.swift
//  FineDustLab
//
//  Created by 박성민 on 2023/06/15.
//  
//

import UIKit

public extension UISwitch {
    func setOnTintColor(_ color: UIColor) {
        onTintColor = color
    }
    
    func setOffTintColor(_ color: UIColor) {
        tintColor = color
        layer.cornerRadius = bounds.height / 2.0
        backgroundColor = color
        clipsToBounds = true
    }
}
