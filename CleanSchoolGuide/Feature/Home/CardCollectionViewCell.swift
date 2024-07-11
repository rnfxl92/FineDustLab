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
        label.text = "쉬어 갈께요"
        return label
    }()
    
    private let startButton = SmallFilledButton(title: "설문 시작하기", font: .systemFont(ofSize: 14, weight: .medium))
  
    private let images: [UIImage] = [.character01, .character02, .character03, .character04, .character05, .character06, .character07, .character08]
    private let failImages: [UIImage] = [.characterFail01, .characterFail02, .characterFail03]
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
        startButton.setTitleColor(.gray0, for: .normal)
        startButton.setTitleColor(.gray0.withAlphaComponent(0.6), for: .disabled)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(24)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(6)
            $0.directionalHorizontalEdges.equalToSuperview().inset(32).priority(750)
            $0.centerX.equalToSuperview()
        }
        
        dayLabel.snp.makeConstraints {
            $0.center.equalTo(imageView)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(6)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.center.equalTo(startButton.snp.center)
        }
        
        descriptionLabel.isHidden = true
        mainView.backgroundColor = .gray200
        contentView.addSubview(mainView)
        mainView.layer.cornerRadius = 18
        
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
                imageView.image = images.randomElement() ?? UIImage.character01
                startButton.setTitle("설문 완료!", for: .disabled)
                startButton.setBackgroundColor(color: .blue400.withAlphaComponent(0.2), forState: .disabled)
                startButton.isEnabled = false
            } else if model.isDayOff {
                descriptionLabel.isHidden = false
                descriptionLabel.textColor = .gray0
                startButton.isHidden = true
                imageView.image = UIImage.characterHoliday
            } else {
                dayLabel.isHidden = false
                imageView.image = UIImage.imgEmptyBluecard
                mainView.bringSubviewToFront(dayLabel)
                startButton.isHidden = false
                descriptionLabel.isHidden = true
                startButton.isEnabled = true
                startButton.setAttributedTitle(getStartButtonTitle(), for: .normal)
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
                    descriptionLabel.textColor = .gray0
                } else { // 설문하고 오늘이 아닌경우
                    
                    imageView.image = images.randomElement() ?? UIImage.character01
                    startButton.isHidden = false
                    descriptionLabel.isHidden = true
                    startButton.setTitle("설문 완료!", for: .disabled)
                    startButton.setBackgroundColor(color: .green400.withAlphaComponent(0.2), forState: .disabled)
                }
                mainView.backgroundColor = .green300
            } else {
                dateLabel.textColor = .gray0
                imageView.image = failImages.randomElement() ?? UIImage.characterFail01
                mainView.backgroundColor = .gray600
                startButton.isHidden = false
                descriptionLabel.isHidden = true
                startButton.setTitle("설문 실패!", for: .disabled)
                startButton.setBackgroundColor(color: .gray800.withAlphaComponent(0.2), forState: .disabled)
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
                    descriptionLabel.textColor = .gray600
                }
            } else {
                imageView.image = UIImage.imgEmptyGreycard
                mainView.backgroundColor = .gray200
                startButton.isHidden = false
                descriptionLabel.isHidden = true
                startButton.setTitle("설문 준비중", for: .disabled)
                startButton.setBackgroundColor(color: .gray600.withAlphaComponent(0.2), forState: .disabled)
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
    
    private func getStartButtonTitle() -> NSAttributedString {
        if let count = Preferences.surveyData?.data.count, let tempSurvey = Preferences.surveyTemp, tempSurvey.date.isToday {
            let countStr = "(\(tempSurvey.lastIndex + 1)/\(count))"
            var str = NSAttributedString(string: "설문 진행중 \(countStr)")
                .addAttributes(countStr, attributes: [.foregroundColor: UIColor.gray500])
            
            return str
        }
        return NSAttributedString(string: "설문 시작하기")
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
