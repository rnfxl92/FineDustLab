//
//  SurveyHelpCell.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 5/25/24.
//

import UIKit

protocol SurveyHelpCellDelegate: AnyObject {
    func updateLayout()
    func imageTapped(image: UIImage)
}

final class SurveyHelpCell: UITableViewCell {
    
    private let helpView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange0
        view.cornerRadius = 18
        return view
    }()
    
    private let helpLabel: UILabel = {
        let label = UILabel()
        label.text = "💡도움말"
        label.textColor = .orange300
        return label
    }()
    
    private let helpImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    weak var delegate: SurveyHelpCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
       
        helpView.addSubview(helpLabel)
        helpLabel.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(14)
        }
        contentView.addSubViews([helpView, helpImageView])
        
        helpView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        
        helpImageView.snp.makeConstraints {
            $0.top.equalTo(helpView.snp.bottom).offset(8)
            $0.height.equalTo(1)
            $0.bottom.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        helpImageView.isUserInteractionEnabled = true
        helpImageView.addGestureRecognizer(tapGestureRecognizer)

    }
    @objc private func imageTapped() {
        if let image = helpImageView.image {
            delegate?.imageTapped(image: image)
        }
    }
    
    func setUIModel(imageUrl: String) {
        helpImageView.loadImage(url: URL(string: imageUrl)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let image):
                helpImageView.snp.updateConstraints {
                    $0.height.equalTo(floor(self.helpImageView.width * image.size.height / image.size.width))
                }
                delegate?.updateLayout()
            case .failure(let error):
                Logger.info(error)
                
            }
        }
    }
}

