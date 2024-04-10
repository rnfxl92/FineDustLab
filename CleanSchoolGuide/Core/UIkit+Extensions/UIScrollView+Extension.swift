//
//  UIScrollView+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 2023/06/23.
//  
//

import UIKit

public enum ScrollDirection {
    case top
    case center
    case bottom
}

extension UIScrollView {
    public func scrollToRight(_ animated: Bool = false) {
        let offset = CGPoint(x: contentSize.width - bounds.size.width + contentInset.right, y: 0)
        setContentOffset(offset, animated: animated)
    }
}

public extension UIScrollView {

    func scroll(to direction: ScrollDirection) {

        DispatchQueue.main.async {
            switch direction {
            case .top:
                self.scrollToTop()
            case .center:
                self.scrollToCenter()
            case .bottom:
                self.scrollToBottom()
            }
        }
    }

    private func scrollToTop() {
        setContentOffset(.zero, animated: true)
    }

    private func scrollToCenter() {
        let centerOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height) / 2)
        setContentOffset(centerOffset, animated: true)
    }

    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}

