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
    
    private let dustMainHStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    private let dustView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue0
        return view
    }()
    private let dustVstack: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()

    private let dustInfoStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.spacing = 12
        return stackView
    }()
    private let dustInfoImageView: UIImageView = {
        let imageView = UIImageView(image: .imgGood)
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    private let dustInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .gray800
        label.text = "좋아요!"
        return label
    }()
    private let dustTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .gray800
        label.text = "미세먼지"
        return label
    }()
    
    private let fineDustView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange0
        return view
    }()
    private let fineDustVstack: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private let warningDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray500
        label.numberOfLines = 2
        label.text = "아직 등록된 미세먼지 정보가 없어요."
        label.textAlignment = .center
        return label
    }()
    private let fineDustInfoStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.spacing = 12
        return stackView
    }()
    private let fineDustInfoImageView: UIImageView = {
        let imageView = UIImageView(image: .imgBad)
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    private let fineDustInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .gray800
        label.text = "안좋아요"
        return label
    }()
    private let fineDustTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .gray800
        label.text = "초미세먼지"
        return label
    }()
    
    private var locationManager =  CLLocationManager()
    private var viewModel = HomeBottomDustViewModel()
    private let fetchWeatherPublisher = PassthroughSubject<(lat: Double?, lng: Double?), Never>()
    private let fetchInternalPublisher = PassthroughSubject<Void, Never>()
    private let fetchExternalPublisher = PassthroughSubject<Void, Never>()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchExternalPublisher.send()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserCurrentLocationAuthorization()
    }
    
    override func setUserInterface() {
        let geoSettingTapGesture = UITapGestureRecognizer(target: self, action: #selector(geoSettingButtonViewTapped))
        geoSettingButtonView.addGestureRecognizer(geoSettingTapGesture)
        geoSettingButtonView.isUserInteractionEnabled = true
        
        view.addSubViews([todayTitleView, segmentedControl, dustMainHStackView, warningDescriptionLabel])
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
        
        todayTitleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(todayTitleView.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(34)
            $0.height.lessThanOrEqualTo(44)
        }
        
        dustInfoStackView.addArrangedSubViews([dustInfoImageView, dustInfoLabel])
        dustVstack.addArrangedSubViews([dustInfoStackView, dustTitleLabel])
        dustView.addSubview(dustVstack)
        dustVstack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.greaterThanOrEqualToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
        
        fineDustInfoStackView.addArrangedSubViews([fineDustInfoImageView, fineDustInfoLabel])
        fineDustVstack.addArrangedSubViews([fineDustInfoStackView, fineDustTitleLabel])
        fineDustView.addSubview(fineDustVstack)
        fineDustVstack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.greaterThanOrEqualToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
        
        dustMainHStackView.addArrangedSubViews([dustView, fineDustView])
        
        dustMainHStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().priority(750)
        }
        dustMainHStackView.cornerRadius = 18
        warningDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        dustMainHStackView.isHidden = true
        fetchInternalPublisher.send()
    }
    
    override func bind() {
        viewModel.bind(
            .init(
                fetchWeather: fetchWeatherPublisher.eraseToAnyPublisher(),
                fetchInternal: fetchInternalPublisher.eraseToAnyPublisher(),
                fetchExternal: fetchExternalPublisher.eraseToAnyPublisher()
            )
        )
        
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
                case .externalFineUpdate(let state):
                break
//                    "설정에서 학교 정보를\n입력 후 확인 가능해요."
                case .internalFineUpdate(let state):
                break
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
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            fetchInternalPublisher.send()
        } else {
            fetchExternalPublisher.send()
        }
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
