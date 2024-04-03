//
//  HomeViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    private let searchStackView = UIStackView(axis: .horizontal)
    
    private let searchBar: FDSearchBar = {
        let searchBar = FDSearchBar()
        searchBar.setPlaceHolderText("미세먼지에 대해 검색해 보세요")
        
        return searchBar
    }()
    
    private let settingButtonView: UIView = {
        
        let view = UIView()
        
        let imageView = UIImageView(image: .settings.withTintColor(.gray0, renderingMode: .alwaysTemplate))
        imageView.tintColor = .gray0
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }
        imageView.contentMode = .scaleAspectFit
        view.backgroundColor = .blue200
        view.cornerRadius = 14
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .gray900
        label.text = "오늘도 청소했다면?"
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray700
        label.numberOfLines = 2
        label.text = "설문조사를 완료해 주세요!"
        label.textAlignment = .left
        return label
    }()
    private let titleStackView = UIStackView(axis: .vertical)
    private let mainSurveyView: UIView = UIView()
    
    private let cardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(CardCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let manualButtonView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 14
        view.backgroundColor = .green300
        view.isUserInteractionEnabled = true
        
        return view
    }()
    private let manualTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray0
        label.textAlignment = .left
        let str1 = "📚 한 눈에 보는 미세먼지 매뉴얼"
        let highlighted = "미세먼지 매뉴얼"
        
        label.attributedText = str1.emphasized(.systemFont(ofSize: 16, weight: .bold), string: highlighted)
        
        return label
    }()
    private let manualImageView: UIImageView = UIImageView(image: .chevronRight)
    
    private let todayWeatherView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray0
        view.cornerRadius = 20
        view.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        
        return view
    }()
    
    private let todayTitleView = UIView()
    private let todayTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 미세먼지"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .gray1000
        
        return label
    }()
    let humidityView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        return view
    }()
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .gray800
        label.text = "32" // TODO
        return label
    }()
    private let humidityImageView = UIImageView(image: .waterDrop)
    private let humidityTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "습도"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray700
        return label
    }()
    
    private let temperatureView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        return view
    }()
    private let temperatureImageView = UIImageView(image: .thermometer)
    private let temperatureTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "온도"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray700
        return label
    }()
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .gray800
        label.text = "11" // TODO
        return label
    }()
    
    private let dustStackView = UIStackView(axis: .horizontal)
    private let externalView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue0
        return view
    }()
    private let externalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray600
        label.text = "학교 외부"
        return label
    }()
    private let externalStackView = UIStackView(axis: .horizontal)
    private let externalImageView = UIImageView()
    private let externalDustLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray800
        label.text = "좋아요!" // TODO
        return label
    }()
    
    private let internalView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange0
        return view
    }()
    private let internalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray600
        label.text = "학교 내부"
        return label
    }()
    private let internalStackView = UIStackView(axis: .horizontal)
    private let internalImageView = UIImageView()
    private let internalDustLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray800
        label.text = "안좋아요 ㅠ" // TODO
        return label
    }()
    
    private let regionDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray600
        label.text = "서울 코인초등학교 날짜 땡땡" // TODO imageAttributed
        return label
    }()
    
    private var viewModel = HomeViewModel()
    
    override func setUserInterface() {
        
        searchStackView.addArrangedSubViews([searchBar, settingButtonView])
        searchStackView.spacing = 8
        searchBar.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        settingButtonView.snp.makeConstraints {
            $0.size.equalTo(48)
        }
        let settingTapGesture = UITapGestureRecognizer(target: self, action: #selector(settingButtonTapped))
        settingButtonView.addGestureRecognizer(settingTapGesture)
        
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        
        titleStackView.spacing = 4
        titleStackView.addArrangedSubViews([titleLabel, descriptionLabel])
        
        manualButtonView.addSubViews([manualTitleLabel, manualImageView])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(manualButtonTapped))
        manualButtonView.addGestureRecognizer(tapGesture)
        
        manualTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(manualImageView.snp.leading).offset(6).priority(.high)
        }
        manualImageView.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        mainSurveyView.addSubViews([titleStackView, cardCollectionView, manualButtonView])
        mainSurveyView.backgroundColor = .gray0
        mainSurveyView.layer.cornerRadius = 20
        
        titleStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalToSuperview().inset(24)
        }
        
        cardCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).inset(-32)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(floor((UIScreen.main.bounds.width - 16) / 2) * 1.2)
            
        }
        
        manualButtonView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.top.equalTo(cardCollectionView.snp.bottom).inset(-24)
            $0.bottom.equalToSuperview().inset(24)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        humidityView.addSubViews([humidityImageView, humidityTitleLabel, humidityLabel])
        
        humidityImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.leading.equalToSuperview().inset(8)
            $0.directionalVerticalEdges.equalToSuperview().inset(6)
        }
        
        humidityTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(humidityImageView.snp.trailing).offset(2)
            $0.centerY.equalTo(humidityImageView.snp.centerY)
        }
        
        humidityLabel.snp.makeConstraints {
            $0.leading.equalTo(humidityTitleLabel.snp.trailing).offset(2)
            $0.centerY.equalTo(humidityImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        temperatureView.addSubViews([temperatureImageView, temperatureTitleLabel, temperatureLabel])
        
        temperatureImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.leading.equalToSuperview().inset(8)
            $0.directionalVerticalEdges.equalToSuperview().inset(6)
        }
        
        temperatureTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(temperatureImageView.snp.trailing).offset(2)
            $0.centerY.equalTo(temperatureImageView.snp.centerY)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.leading.equalTo(temperatureTitleLabel.snp.trailing).offset(2)
            $0.centerY.equalTo(temperatureImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        todayTitleView.addSubViews([todayTitleLabel, humidityView, temperatureView])
        todayTitleLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(4)
            $0.trailing.lessThanOrEqualTo(humidityView.snp.leading).inset(8)
        }
        
        humidityView.snp.makeConstraints {
            $0.centerY.equalTo(todayTitleView.snp.centerY)
            $0.trailing.equalTo(temperatureView.snp.leading).inset(-8)
        }
        temperatureView.snp.makeConstraints {
            $0.centerY.equalTo(todayTitleView.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        externalStackView.spacing = 12
        externalStackView.addArrangedSubViews([externalImageView, externalDustLabel])
        externalImageView.snp.makeConstraints {
            $0.size.equalTo(32)
        }
        externalView.addSubViews([externalTitleLabel, externalStackView])
        externalTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(18)
        }
        externalStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(externalTitleLabel.snp.bottom).offset(12)
        }
        internalStackView.spacing = 12
        internalStackView.addArrangedSubViews([internalImageView, internalDustLabel])
        internalImageView.snp.makeConstraints {
            $0.size.equalTo(32)
        }
        internalView.addSubViews([internalTitleLabel, internalStackView])
        internalTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(18)
        }
        internalStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(internalTitleLabel.snp.bottom).offset(12)
        }
        
        dustStackView.clipsToBounds = true
        dustStackView.distribution = .fillEqually
        dustStackView.cornerRadius = 16
        dustStackView.addArrangedSubViews([externalView, internalView])
        
        todayWeatherView.addSubViews([todayTitleView, dustStackView, regionDateLabel])
        
        todayTitleView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        dustStackView.snp.makeConstraints {
            $0.top.equalTo(todayTitleView.snp.bottom).offset(16)
            $0.height.equalTo(102)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        regionDateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dustStackView.snp.bottom).offset(24)
        }
        
        view.addSubViews([searchStackView, mainSurveyView, todayWeatherView])
        searchStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        mainSurveyView.snp.makeConstraints {
            $0.top.equalTo(searchStackView.snp.bottom).offset(16)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        todayWeatherView.snp.makeConstraints {
            $0.top.equalTo(mainSurveyView.snp.bottom).offset(16)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        view.backgroundColor = .blue100
        
    }
    
    @objc private func manualButtonTapped(_ sender: UITapGestureRecognizer) {
        print("manual button tapped")
    }
    
    @objc private func settingButtonTapped(_ sender: UITapGestureRecognizer) {
        print("setting button tapped")
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let uiModel = viewModel.dataSource[safe: indexPath.item]  else {
            return .init()
        }
        let cell: CardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        cell.setUIModel(uiModel)
        
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((UIScreen.main.bounds.width - 16) / 2)
        
        return .init(width: width, height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 24, bottom: 0, right: 24)
    }
}

extension HomeViewController: CardCollectionViewCellDelegate {
    func surveyStartButtonTapped() {
        AppRouter.shared.route(to: .surveyStart)
    }
}
