//
//  HomeSurveyButtonView.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/4/24.
//

import UIKit

final class HomeSurveyButtonView: UIView {
   
    private let surveyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray0
        label.textAlignment = .left
        let str1 = "🪠 청소 후 점검 설문조사"
        let highlighted = "설문조사"
        
        label.attributedText = str1.emphasized(.systemFont(ofSize: 16, weight: .bold), string: highlighted)
        
        return label
    }()
  
    private let surveyImageView: UIImageView = UIImageView(image: .chevronRight.withRenderingMode(.alwaysTemplate))
    private var touchHandler: (() -> Void)?
    
    init(touchHandler: (() -> Void)?) {
        self.touchHandler = touchHandler
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        layer.cornerRadius = 14
        backgroundColor = .blue300
        isUserInteractionEnabled = true
        
        addSubViews([surveyTitleLabel, surveyImageView])
        let surveyTapGesture = UITapGestureRecognizer(target: self, action: #selector(surveyButtonTapped))
        addGestureRecognizer(surveyTapGesture)
        surveyTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(surveyImageView.snp.leading).offset(6).priority(.high)
        }
        surveyImageView.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc private func surveyButtonTapped(_ sender: UITapGestureRecognizer) {
        touchHandler?()
    }
    
    func updateState(isHoliday: Bool) {
        if isHoliday || Date.isWeekend(.now) {
            surveyTitleLabel.textColor = .gray500
            surveyTitleLabel.text = "휴일은 설문조사를 쉬었다 갈게요"
            surveyImageView.tintColor = .gray500
            backgroundColor = .gray200
            isUserInteractionEnabled = false
        } else if Preferences.surveyCompletedDates.first(where: { $0.isSameDay(from: .now) }) != nil {
            surveyTitleLabel.textColor = .gray500
            surveyTitleLabel.text = "오늘의 설문조사를 완료했어요"
            surveyImageView.tintColor = .gray500
            backgroundColor = .gray200
            isUserInteractionEnabled = false
        } else if let surveyData = Preferences.surveyData, let tempSurvey = Preferences.surveyTemp, tempSurvey.date.isToday {
            let str1 = "설문조사 작성중"
            let str2 = "설문조사 작성중 (\(tempSurvey.lastIndex + 1)/\(surveyData.data.count))"
            
            surveyTitleLabel.attributedText = str2.emphasized(.systemFont(ofSize: 16, weight: .bold), string: str1)
            surveyTitleLabel.textColor = .gray0
            surveyImageView.tintColor = .gray0
            backgroundColor = .blue300
            isUserInteractionEnabled = true
        } else {
            surveyTitleLabel.textColor = .gray0
            
            let str1 = "🪠 청소 후 점검 설문조사"
            let highlighted = "설문조사"
            
            surveyTitleLabel.attributedText = str1.emphasized(.systemFont(ofSize: 16, weight: .bold), string: highlighted)
            surveyImageView.tintColor = .gray0
            backgroundColor = .blue300
            isUserInteractionEnabled = true
        }
    }
    
}
