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
        
        view.addSubViews([searchStackView, mainSurveyView])
        searchStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        mainSurveyView.snp.makeConstraints {
            $0.top.equalTo(searchStackView.snp.bottom).offset(16)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        view.backgroundColor = .blue100

    }
    
    @objc private func manualButtonTapped(_ sender: UITapGestureRecognizer) {
        print("manual button tapped")
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
