//
//  CardCollectionViewCell.swift
//  FineDustLab
//
//  Created by 박성민 on 3/31/24.
//

import UIKit
import Combine

protocol CardCollectionViewCellDelegate: AnyObject {
    func surveyStartButtonTapped()
}

final class CardCollectionViewCell: UICollectionViewCell {
    
    private let mainView = UIView()
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        label.textColor = .gray0
        
        return label
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textColor = .gray500
        
        return label
    }()
    
    private let startButton = SmallFilledButton(title: "설문 시작하기", font: .systemFont(ofSize: 14, weight: .medium))
    
    weak var delegate: CardCollectionViewCellDelegate?
    private var cancellable = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bind()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        mainView.addSubViews([dateLabel, imageView, dayLabel, startButton])
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(24)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).inset(-6)
            $0.centerX.equalToSuperview()
        }
        
        dayLabel.snp.makeConstraints {
            $0.center.equalTo(imageView)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).inset(-6)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        mainView.backgroundColor = .gray200
        contentView.addSubview(mainView)
        mainView.layer.cornerRadius = 18
        mainView.clipsToBounds = true
        mainView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
    }
    
    func setUIModel(_ model: CardUIModel) {
        dateLabel.text = model.date.toString(dateFormat: .Md)
        
        dayLabel.isHidden = model.isSuveyed || model.isHoliday
        dayLabel.text = model.date.toString(dateFormat: .E)
        if model.isToday {
            dateLabel.textColor = .gray0
            dayLabel.textColor = .gray0
            startButton.setBackgroundColor(color: .blue400, forState: .normal)
            mainView.backgroundColor = .blue300
            if model.isSuveyed {
                imageView.image = UIImage.mainCharacter
            } else {
                imageView.image = UIImage.cloud
                mainView.bringSubviewToFront(dayLabel)
            }
        } else {
            dateLabel.textColor = .gray500
            dayLabel.textColor = .gray500
            startButton.setBackgroundColor(color: .green400.withAlphaComponent(0.2), forState: .disabled)
            startButton.setBackgroundColor(color: .green400.withAlphaComponent(0.2), forState: .normal)
            startButton.setBackgroundColor(color: .green400.withAlphaComponent(0.2), forState: .highlighted)
            if model.isSuveyed {
                imageView.image = UIImage.mainCharacter
                mainView.backgroundColor = .green300
            } else {
                imageView.image = UIImage.failCharacter
                mainView.backgroundColor = .gray200
            }
        } 
    }
    
    private func bind() {
        startButton
            .tapPublisher
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .sink { [weak self] _ in
                self?.delegate?.surveyStartButtonTapped()
            }
            .store(in: &cancellable)
    }
    
}

extension CardCollectionViewCell {
    struct CardUIModel {
        let date: Date
        let isSuveyed: Bool
        let isHoliday: Bool
        
        var isToday: Bool {
            true
//            date.isToday
        }
    }
}
