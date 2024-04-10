//
//  UITableView+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 11/27/23.
//  
//

import UIKit

public extension UITableView {
    func setEmptyView(title: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x,
                                             y: self.center.y,
                                             width: self.bounds.size.width,
                                             height: self.bounds.size.height))
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .gray400
        titleLabel.font = .body.regular
        titleLabel.text = title
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center

        emptyView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16).priority(.high)
            $0.centerY.equalToSuperview().dividedBy(1.2)
        }
        self.backgroundView = emptyView
    }

    func restore() {
        self.backgroundView = nil
    }
}

