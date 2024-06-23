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
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let helpContainerView: UIView = UIView()
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
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let helpImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private var buttonIsSelected: Bool = true {
        didSet {
            if buttonIsSelected {
                helpView.backgroundColor = .orange0
                helpLabel.textColor = .orange300
                helpImageView.isHidden = false
                reloadImageView()
            } else {
                helpView.backgroundColor = .gray100
                helpLabel.textColor = .gray700
                helpImageView.isHidden = true
            }
        }
    }
    private var imageUrl: URL?
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
        helpContainerView.addSubview(helpView)
        stackView.addArrangedSubViews([helpContainerView, helpImageView])
        
        helpView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        contentView.addSubViews([stackView])
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.directionalHorizontalEdges.bottom.equalToSuperview().inset(24)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        helpImageView.isUserInteractionEnabled = true
        helpImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let helpTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(helpButtonTapped))
        helpView.isUserInteractionEnabled = true
        helpView.addGestureRecognizer(helpTapGestureRecognizer)

    }
    
    @objc private func helpButtonTapped() {
        buttonIsSelected.toggle()
        delegate?.updateLayout()
    }
    
    @objc private func imageTapped() {
        if let image = helpImageView.image {
            delegate?.imageTapped(image: image)
        }
    }
    
    func setUIModel(imageUrl: String) {
        self.imageUrl = URL(string: imageUrl)
        reloadImageView()
    }
    
    private func reloadImageView() {
        helpImageView.loadImage(url: imageUrl) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
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
}

