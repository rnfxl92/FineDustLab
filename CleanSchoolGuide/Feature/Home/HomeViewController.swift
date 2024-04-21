//
//  HomeViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit
import CoreLocation
import Combine

final class HomeViewController: BaseViewController {
    
    private let searchStackView = UIStackView(axis: .horizontal)
    
    private let searchBar: CSGSearchBar = {
        let searchBar = CSGSearchBar()
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
        label.text = Preferences.selectedUserType == .teacher ? "오늘의 미세먼지 정보": "오늘도 청소했다면?"
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray700
        label.numberOfLines = 2
        label.text = Preferences.selectedUserType == .teacher ? "등록된 정보는 학생들에게 공유됩니다." : "설문조사를 완료해 주세요!"
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
    
    private lazy var ultraFineDustView = HomeFineDustView(type: .ultraFineDust, selectedIndex: Preferences.ultraFineData?.selectedIndex)
    private lazy var fineDustView = HomeFineDustView(type: .fineDust, selectedIndex: Preferences.fineData?.selectedIndex)
    
    private let surveyButtonView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 14
        view.backgroundColor = .blue300
        view.isUserInteractionEnabled = true
        
        return view
    }()
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
    private let surveyImageView: UIImageView = UIImageView(image: .chevronRight)
    
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
    private let externalVstack: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    private let externalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray600
        label.text = "학교 외부"
        return label
    }()
    private let externalStackView = UIStackView(axis: .horizontal)
    private let externalImageView: UIImageView = {
        let imageView = UIImageView(image: .imgGood)
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    private let externalDustLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray800
        label.text = "좋아요!"
        return label
    }()
    
    private let internalView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange0
        return view
    }()
    private let internalVstack: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    private let internalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray600
        label.text = "학교 내부"
        return label
    }()
    private let internalStackView = UIStackView(axis: .horizontal)
    private let internalImageView: UIImageView = {
        let imageView = UIImageView(image: .imgBad)
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    private let internalDustLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray800
        label.text = "안좋아요"
        return label
    }()
    
    private let regionDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray600
        label.text = "서울 코인초등학교 날짜 땡땡" // TODO imageAttributed
        return label
    }()
    private var locationManager =  CLLocationManager()
    private var viewModel = HomeViewModel()
    
    private let fetchWeatherPublisher = PassthroughSubject<(lat: Double?, lng: Double?), Never>()
    private let fetchFineDustPublisher = PassthroughSubject<Void, Never>()
    private let postFineDustPublisher = PassthroughSubject<(Int, Int), Never>() // 개선 필요
    private let postUltraFineDustPublisher = PassthroughSubject<(Int, Int), Never>() // 개선 필요
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkUserCurrentLocationAuthorization()
        fetchFineDustPublisher.send()
    }
    
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
        
        surveyButtonView.addSubViews([surveyTitleLabel, surveyImageView])
        let surveyTapGesture = UITapGestureRecognizer(target: self, action: #selector(surveyButtonTapped))
        surveyButtonView.addGestureRecognizer(surveyTapGesture)
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
        
        if Preferences.selectedUserType == .teacher {
            mainSurveyView.addSubViews([titleStackView, ultraFineDustView, fineDustView, surveyButtonView, manualButtonView])
            ultraFineDustView.delegate = self
            fineDustView.delegate = self
        } else {
            mainSurveyView.addSubViews([titleStackView, cardCollectionView, manualButtonView])
        }
        mainSurveyView.backgroundColor = .gray0
        mainSurveyView.layer.cornerRadius = 20
        
        titleStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalToSuperview().inset(24)
        }
        
        if Preferences.selectedUserType == .teacher {
            ultraFineDustView.snp.makeConstraints {
                $0.top.equalTo(titleStackView.snp.bottom).offset(32)
                $0.directionalHorizontalEdges.equalToSuperview().inset(24)
                
            }
            fineDustView.snp.makeConstraints {
                $0.top.equalTo(ultraFineDustView.snp.bottom)
                $0.directionalHorizontalEdges.equalToSuperview().inset(24)
                
            }
            
            surveyButtonView.snp.makeConstraints {
                $0.top.equalTo(fineDustView.snp.bottom).offset(20)
                $0.directionalHorizontalEdges.equalToSuperview().inset(24)
                $0.height.equalTo(56)
            }
            
            manualButtonView.snp.makeConstraints {
                $0.height.equalTo(56)
                $0.top.equalTo(surveyButtonView.snp.bottom).offset(8)
                $0.bottom.equalToSuperview().inset(24)
                $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            }
        } else {
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
        externalVstack.addArrangedSubViews([externalTitleLabel, externalStackView])
        externalView.addSubViews([externalVstack])
        externalVstack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        internalStackView.spacing = 12
        internalStackView.addArrangedSubViews([internalImageView, internalDustLabel])
        internalImageView.snp.makeConstraints {
            $0.size.equalTo(32)
        }
        internalVstack.addArrangedSubViews([internalTitleLabel, internalStackView])
        internalView.addSubViews([internalVstack])
        internalVstack.snp.makeConstraints {
            $0.center.equalToSuperview()
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
            
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        regionDateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dustStackView.snp.bottom).offset(24)
            $0.bottom.equalTo(todayWeatherView.safeAreaLayoutGuide).inset(12)
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
        AppRouter.shared.route(to: .manualList)
    }
    
    @objc private func surveyButtonTapped(_ sender: UITapGestureRecognizer) {
        AppRouter.shared.route(to: .surveyStart)
    }
    
    @objc private func settingButtonTapped(_ sender: UITapGestureRecognizer) {
        AppRouter.shared.route(to: .setting)
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { _ in }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
    
    func checkUserCurrentLocationAuthorization() {
        guard !viewModel.isChecked else { return }
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
                
        case .denied, .restricted:
            showRequestLocationServiceAlert()
            fetchWeatherPublisher.send((lat: nil, lng: nil))
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("Default")
        }
        viewModel.isChecked = true
    }
    
    override func bind() {
        viewModel.bind(
            .init(
                fetchWeather: fetchWeatherPublisher.eraseToAnyPublisher(),
                fetchFineDust: fetchFineDustPublisher.eraseToAnyPublisher(),
                postFineDust: postFineDustPublisher.eraseToAnyPublisher(),
                postUltraFineDust: postUltraFineDustPublisher.eraseToAnyPublisher()
            )
        )
        
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .wetherUpdated(let humidity, let temperature, let date):
                    self?.humidityLabel.text = humidity
                    self?.temperatureLabel.text = temperature
                    // TODO: date
                case .externalFineUpdate(let state):
                    self?.externalDustLabel.text = state.description
                    self?.externalImageView.image = state == .bad ? .imgBad : .imgGood
                case .internalFineUpdate(let state):
                    self?.internalDustLabel.text = state.description
                    self?.internalImageView.image = state == .bad ? .imgBad : .imgGood
                case .fineDustPosted:
                    self?.fetchFineDustPublisher.send()
                default:
                    break
                }
            }
            .store(in: &cancellable)
            
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

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            fetchWeatherPublisher.send((lat: latitude, lng: longitude))
            
            // 현재 위치를 얻은 후 위치 업데이트 중지
            locationManager.stopUpdatingLocation()
        }
    }
}

extension HomeViewController: HomeFineDustViewDelegate {
    func buttonTapped(type: HomeFineDustView.ViewType, value: Int, selectedIndex: Int) {
        switch type {
        case .fineDust:
            postFineDustPublisher.send((value, selectedIndex))
        case .ultraFineDust:
            postUltraFineDustPublisher.send((value, selectedIndex))
        }
    }
}
