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
    private let searchBar = TopSearchTextFieldView()
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
        label.textColor = .gray1000
        label.text = Preferences.selectedUserType == .teacher ? "오늘의 미세먼지 정보를": "오늘도 등교했다면?"
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.textColor = .gray1000
        label.numberOfLines = 2
        label.text = Preferences.selectedUserType == .teacher ? "입력하고 학생들과 공유해요." : "미세먼지 상태를 체크해 보세요!"
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
        collectionView.decelerationRate = .fast
        
        return collectionView
    }()
    
    private lazy var ultraFineDustView = HomeFineDustView(type: .ultraFineDust, selectedIndex: Preferences.ultraFineData?.selectedIndex)
    private lazy var fineDustView = HomeFineDustView(type: .fineDust, selectedIndex: Preferences.fineData?.selectedIndex)
    
    private lazy var surveyButtonView = HomeSurveyButtonView { [weak self] in
        self?.surveyStartButtonTapped()
    }
    
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
    private var bottomDustViewController = HomeBottomDustViewController()
    
    private var viewModel = HomeViewModel()
    private let postFineDustPublisher = PassthroughSubject<(Int, Int), Never>() // 개선 필요
    private let postUltraFineDustPublisher = PassthroughSubject<(Int, Int), Never>() // 개선 필요
    private var isFirstAppear: Bool = true
    private var cancellable = Set<AnyCancellable>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bottomDustViewController.updateBottomDust()
        surveyButtonView.updateState(isHoliday: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 1) { [weak self] in
            guard let self else { return }
            if self.viewModel.checkSurvey() {
                self.showResumPopup()
            }
        }
    }
    
    override func setUserInterface() {
        self.addChild(bottomDustViewController)
        hideKeyboardWhenTappedAround()
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
        
        if Preferences.selectedUserType == .teacher {
            mainSurveyView.addSubViews([titleStackView, fineDustView, ultraFineDustView, surveyButtonView, manualButtonView])
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
            fineDustView.snp.makeConstraints {
                $0.top.greaterThanOrEqualTo(titleStackView.snp.bottom).offset(12)
                $0.top.lessThanOrEqualTo(titleStackView.snp.bottom).offset(24)
                $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            }
            ultraFineDustView.snp.makeConstraints {
                $0.top.greaterThanOrEqualTo(fineDustView.snp.bottom)
                $0.top.lessThanOrEqualTo(fineDustView.snp.bottom).offset(12)
                $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            }
            surveyButtonView.snp.makeConstraints {
                $0.top.greaterThanOrEqualTo(ultraFineDustView.snp.bottom)
                $0.top.lessThanOrEqualTo(ultraFineDustView.snp.bottom).offset(28)
                $0.directionalHorizontalEdges.equalToSuperview().inset(24)
                $0.height.equalTo(56)
            }
            
            manualButtonView.snp.makeConstraints {
                $0.height.equalTo(56)
                $0.top.greaterThanOrEqualTo(surveyButtonView.snp.bottom).offset(6)
                $0.top.lessThanOrEqualTo(surveyButtonView.snp.bottom).offset(12)
                $0.bottom.equalToSuperview().inset(24)
                $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            }
        } else {
            cardCollectionView.snp.makeConstraints {
                $0.top.equalTo(titleStackView.snp.bottom).offset(24)
                $0.directionalHorizontalEdges.equalToSuperview()
                $0.height.equalTo(floor(floor((UIScreen.main.bounds.width * 0.52)) * 1.22))
            }
            
            manualButtonView.snp.makeConstraints {
                $0.height.equalTo(56)
                $0.top.equalTo(cardCollectionView.snp.bottom).offset(20)
                $0.bottom.equalToSuperview().inset(24)
                $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            }
        }
        
        todayWeatherView.addSubview(bottomDustViewController.view)
        
        bottomDustViewController.view.snp.makeConstraints {
            $0.directionalEdges.equalTo(todayWeatherView.safeAreaLayoutGuide)
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
            $0.top.equalTo(mainSurveyView.snp.bottom).offset(5)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        view.backgroundColor = .blue100
        
    }
    
    @objc private func manualButtonTapped(_ sender: UITapGestureRecognizer) {
        AppRouter.shared.route(to: .manualList)
    }
    
    @objc private func settingButtonTapped(_ sender: UITapGestureRecognizer) {
        AppRouter.shared.route(to: .setting)
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
    
    override func bind() {
        viewModel.bind(
            .init(
                postFineDust: postFineDustPublisher.eraseToAnyPublisher(),
                postUltraFineDust: postUltraFineDustPublisher.eraseToAnyPublisher()
            )
        )
        
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                state.isLoading ? CSGIndicator.shared.show() : CSGIndicator.shared.hide()
                
                switch state {
                case .fineDustPosted:
                    self?.bottomDustViewController.updateBottomDust()
                    break
                default:
                    break
                }
            }
            .store(in: &cancellable)
        
        searchBar
            .searchButtonTapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                if self.viewModel.checkPdf(self.searchBar.searchText) {
                    AppRouter.shared.route(to: .manualDetail(title: "미세먼지 매뉴얼", fileName: Preferences.selectedUserType?.rawValue ?? "", searchWords: self.searchBar.searchText))
                } else {
                    CSGToast.show("'\(self.searchBar.searchText)' 검색자료가 없습니다.", view: UIApplication.shared.keyWindows?.last ?? view)
                }
            }
            .store(in: &cancellable)
    }
    
    private func showResumPopup(needCancelAction: Bool = false) {
        var vc: PopupViewController
        if needCancelAction {
            vc = PopupViewController(
                type: .dual,
                description: "이전에 작성중이던\n설문조사를 이어서 할까요?",
                defualtTitle: "이어하기",
                cancelTitle: "아니요",
                completion: {
                    AppRouter.shared.route(to: .surveyDetail(currentIndex: 0, isResumed: true))
                },
                cancelCompletion:  {
                    Preferences.surveyTemp = nil
                    AppRouter.shared.route(to: .surveyStart)
                }
            )
        } else {
            vc = PopupViewController(type: .dual, description: "이전에 작성중이던\n설문조사를 이어서 할까요?", defualtTitle: "이어하기", cancelTitle: "아니요", completion: {
                AppRouter.shared.route(to: .surveyDetail(currentIndex: 0, isResumed: true))
            })
        }
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc: vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isFirstAppear {
            isFirstAppear = false
            collectionView.contentOffset = CGPoint(x: 16 + floor((UIScreen.main.bounds.width * 0.52)), y: 0)
        }
        guard let uiModel = viewModel.dataSource[safe: indexPath.item]  else {
            return .init()
        }
        let cell: CardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        cell.setUIModel(uiModel)
        DispatchQueue.main.async {
            cell.alpha = indexPath.item == 1 ? 1 : 0.7
        }
        
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        cardCollectionView.visibleCells.forEach { cell in
            cell.alpha = 1
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        targetContentOffset.pointee = CGPoint(x: 16 + floor((UIScreen.main.bounds.width * 0.52)), y: 0)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        cardCollectionView.visibleCells.forEach { cell in
            cell.alpha = 0.7
        }
        
        if let cell = cardCollectionView.cellForItem(at: IndexPath(item: 1, section: 0)) {
            cell.alpha = 1.0
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((UIScreen.main.bounds.width * 0.52))
        
        return .init(width: width, height: floor(width * 1.22))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 24, bottom: 0, right: 24)
    }
}

extension HomeViewController: CardCollectionViewCellDelegate {
    func surveyStartButtonTapped() {
        if viewModel.checkSurvey() {
            showResumPopup(needCancelAction: true)
        } else {
            AppRouter.shared.route(to: .surveyStart)
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
