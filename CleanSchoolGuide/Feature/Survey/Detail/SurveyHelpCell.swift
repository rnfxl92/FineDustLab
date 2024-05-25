//
//  SurveyHelpCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 5/25/24.
//

import UIKit

final class SurveyHelpCell: UITableViewCell {
    
    private let helpView: UIView = {
        let view = UIView()
        
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
       
       
    }
    
}

