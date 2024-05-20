//
//  HomeBottomDustViewController.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 5/19/24.
//

import UIKit
import Combine
import CoreLocation

final class HomeBottomDustViewController: BaseViewController {
    private let todayTitleView = UIView()
    private let todayTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 미세먼지"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray1000
        
        return label
    }()
    
    private let weatherStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.spacing = 8
        
        return stackView
    }()
    private let humidityView = HumidityView()
    private let temperatureView = TemperatureView()
    private let geoSettingButtonView = GeoSettingButtonView()
    
    let segmentedControl: CustomSegmentedControl = {
        let control = CustomSegmentedControl(items: ["학교 내부", "학교 외부"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let regionDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray600
        label.text = Preferences.userInfo?.school.schulNm
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
        stackView.spacing = 12
        return stackView
    }()
    private let externalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray600
        label.text = "학교 외부"
        return label
    }()
    private let externalDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray500
        label.numberOfLines = 2
        label.text = "설정에서 학교 정보를\n입력 후 확인 가능해요."
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
        stackView.spacing = 12
        return stackView
    }()
    private let internalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray600
        label.text = "학교 내부"
        return label
    }()
    private let internalDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray500
        label.numberOfLines = 2
        label.text = "아직 등록된 미세먼지\n정보가 없어요."
        label.textAlignment = .center
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
    
    private var locationManager =  CLLocationManager()
    private var viewModel = HomeBottomDustViewModel()
    private let fetchWeatherPublisher = PassthroughSubject<(lat: Double?, lng: Double?), Never>()
    private let fetchFineDustPublisher = PassthroughSubject<Void, Never>()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkUserCurrentLocationAuthorization()
        fetchFineDustPublisher.send()
        locationManager.startUpdatingLocation()
    }
    
    override func setUserInterface() {
        let geoSettingTapGesture = UITapGestureRecognizer(target: self, action: #selector(geoSettingButtonViewTapped))
        geoSettingButtonView.addGestureRecognizer(geoSettingTapGesture)
        geoSettingButtonView.isUserInteractionEnabled = true
        
        weatherStackView.addArrangedSubViews([humidityView, temperatureView, geoSettingButtonView])
        todayTitleView.addSubViews([todayTitleLabel, weatherStackView])
        
        todayTitleLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(4)
            $0.trailing.lessThanOrEqualTo(humidityView.snp.leading).inset(8)
        }
        weatherStackView.snp.makeConstraints {
            $0.centerY.equalTo(todayTitleView.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        humidityView.isHidden = true
        temperatureView.isHidden = true
        
        view.addSubViews([todayTitleView, segmentedControl])
        
        todayTitleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
        }
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(todayTitleView.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(34)
            $0.height.lessThanOrEqualTo(44)
        }
    }
    
    override func bind() {
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                state.isLoading ? CSGIndicator.shared.show() : CSGIndicator.shared.hide()
                
                switch state {
                case .wetherUpdated(let humidity, let temperature, let date):
                    self?.geoSettingButtonView.isHidden = true
                    self?.humidityView.isHidden = false
                    self?.temperatureView.isHidden = false
                    
                    self?.humidityView.text = humidity
                    self?.temperatureView.text = temperature
                    if let school = Preferences.userInfo?.school.schulNm {
                        self?.regionDateLabel.text = school + date
                    }
                case .externalFineUpdate(let state):
                    self?.externalStackView.isHidden = false
                    self?.externalDescriptionLabel.isHidden = true
                    self?.externalDustLabel.text = state.description
                    self?.externalImageView.image = state == .bad ? .imgBad : .imgGood
                case .internalFineUpdate(let state):
                    self?.internalStackView.isHidden = false
                    self?.internalDescriptionLabel.isHidden = true
                    self?.internalDustLabel.text = state.description
                    self?.internalImageView.image = state == .bad ? .imgBad : .imgGood
                default:
                    break
                }
            }
            .store(in: &cancellable)
    }
    
    @objc private func geoSettingButtonViewTapped(_ sender: UITapGestureRecognizer) {
        showRequestLocationServiceAlert()
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정'에서 '위치'를 허용해주세요.", preferredStyle: .alert)
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
            geoSettingButtonView.isHidden = true
            humidityView.isHidden = false
            temperatureView.isHidden = false
            
            locationManager.startUpdatingLocation()
        default:
            print("Default")
        }
        viewModel.isChecked = true
    }
}

extension HomeBottomDustViewController: CLLocationManagerDelegate {
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
