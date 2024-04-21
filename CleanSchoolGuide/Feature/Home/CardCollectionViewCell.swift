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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .gray0
        label.text = "오늘은 쉬어 갈께요"
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
        mainView.addSubViews([dateLabel, imageView, dayLabel, startButton, descriptionLabel])
        
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
        
        descriptionLabel.snp.makeConstraints {
            $0.center.equalTo(startButton.snp.center)
        }
        
        descriptionLabel.isHidden = true
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
        dayLabel.isHidden = model.isSuveyed || model.isDayOff
        dayLabel.text = model.date.toString(dateFormat: .E)
        
        if model.isToday {
            dateLabel.textColor = .gray0
            dayLabel.textColor = .gray0
            startButton.setBackgroundColor(color: .blue400, forState: .normal)
            mainView.backgroundColor = .blue300
            if model.isSuveyed {
                startButton.isHidden = false
                descriptionLabel.isHidden = true
                imageView.image = UIImage.character02
                startButton.setTitle("설문 완료!", for: .disabled)
                startButton.setBackgroundColor(color: .blue400.withAlphaComponent(0.2), forState: .disabled)
                startButton.isEnabled = false
            } else if model.isDayOff {
                descriptionLabel.isHidden = false
                startButton.isHidden = true
                imageView.image = UIImage.characterHoliday
            } else {
                dayLabel.isHidden = false
                imageView.image = UIImage.cloud
                mainView.bringSubviewToFront(dayLabel)
                startButton.isHidden = false
                descriptionLabel.isHidden = true
                startButton.isEnabled = true
            }
        } else if Date.now > model.date { // 이전일
            dayLabel.isHidden = true
            startButton.isEnabled = false
           
            if model.isSuveyed || model.isDayOff {
                dateLabel.textColor = .gray0
                if model.isDayOff {
                    imageView.image = UIImage.characterHoliday
                    startButton.isHidden = true
                    descriptionLabel.isHidden = false
                } else { // 설문하고 오늘이 아닌경우
                    imageView.image = UIImage.character01
                    startButton.isHidden = false
                    descriptionLabel.isHidden = true
                    startButton.setTitle("설문 완료!", for: .disabled)
                    startButton.setBackgroundColor(color: .green400.withAlphaComponent(0.2), forState: .disabled)
                }
                mainView.backgroundColor = .green300
            } else {
                dateLabel.textColor = .gray500
                imageView.image = UIImage.character05
                mainView.backgroundColor = .gray200
                startButton.isHidden = false
                descriptionLabel.isHidden = true
                startButton.setTitle("설문 작성을 못했어요", for: .disabled)
                startButton.setBackgroundColor(color: .gray300, forState: .disabled)
            }
        } else {
            dateLabel.textColor = .gray500
            dayLabel.textColor = .gray500
            startButton.isEnabled = false
            dayLabel.isHidden = false
           
            if model.isSuveyed || model.isDayOff {
                if model.isDayOff {
                    dayLabel.isHidden = true
                    imageView.image = UIImage.characterHoliday
                    startButton.isHidden = true
                    descriptionLabel.isHidden = false
                }
            } else {
                imageView.image = UIImage.cloud
                mainView.backgroundColor = .gray200
                startButton.isHidden = false
                descriptionLabel.isHidden = true
                startButton.setTitle("설문시작하기", for: .disabled)
                startButton.setBackgroundColor(color: .gray300, forState: .disabled)
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
            date.isToday
        }
        var isDayOff: Bool {
            isHoliday || Date.isWeekend(date)
        }
    }
}
