//
//  DividerCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/2/24.
//

import UIKit

final class DividerCell: UITableViewCell {
    let view: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(view)
        view.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
            $0.height.equalTo(10)
        }
    }
}
