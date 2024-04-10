//
//  UIView+Layout.swift
//  FineDustLab
//
//  Created by 박성민 on 2022/09/23.
//

import SnapKit
import UIKit

// MARK: - builder 
public extension UIView {
    @discardableResult
    func addSubViews(_ views: [UIView]) -> Self {
        views.forEach { self.addSubview($0) }
        return self
    }

    @discardableResult
    func embed(in superview: UIView) -> Self {
        superview.addSubview(self)
        return self
    }
    
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    @discardableResult
    func withGradient(
        top: UIColor,
        bottom: UIColor,
        start: NSNumber = 0.0,
        end: NSNumber = 1.0,
        isHorizontal: Bool = false
    ) -> Self {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [top.cgColor, bottom.cgColor]
        gradientLayer.locations = [start, end]
        gradientLayer.frame = bounds
        if isHorizontal {
            gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        }
        
        layer.insertSublayer(gradientLayer, at: 0)
        return self
    }
    
    @discardableResult
    func addDashedBorder(color: UIColor, radius: CGFloat = 0, pattern: [NSNumber]? = [2, 2]) -> UIView {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineDashPattern = pattern
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.addSublayer(borderLayer)
        return self
    }

    func setVerticalGradient(startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        layer.addSublayer(gradientLayer)
    }
}

// MARK: - frame
public extension UIView {
    var origin: CGPoint {
        get {
            frame.origin
        }
        
        set {
            frame.origin = newValue
        }
    }
    
    var size: CGSize {
        get {
            frame.size
        }
        
        set {
            frame.size = newValue
        }
    }
    
    var top: CGFloat {
        get {
            frame.origin.y
        }
        
        set {
            frame.origin.y = newValue
        }
    }
    
    var left: CGFloat {
        get {
            frame.origin.x
        }
        
        set {
            frame.origin.x = newValue
        }
    }
    
    var right: CGFloat {
        get {
            frame.maxX
        }
        
        set {
            frame.origin.x = newValue - width
        }
    }
    
    var bottom: CGFloat {
        get {
            frame.maxY
        }
        
        set {
            frame.origin.y = newValue - height
        }
    }
    
    var width: CGFloat {
        get {
            frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
}

// MARK: - layer
public extension UIView {
    var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
