//
//  HomeViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit

final class HomeViewController: BaseViewController {
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
    
    private var viewModel = HomeViewModel()
    
    override func setUserInterface() {
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        
        titleStackView.spacing = 4
        titleStackView.addArrangedSubViews([titleLabel, descriptionLabel])
        
        mainSurveyView.addSubViews([titleStackView, cardCollectionView])
        mainSurveyView.backgroundColor = .gray0
        mainSurveyView.layer.cornerRadius = 20
        
        titleStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalToSuperview().inset(24)
        }
        
        cardCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).inset(-32)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(floor((UIScreen.main.bounds.width - 16) / 2) * 1.2)
            $0.bottom.equalToSuperview()
        }
        
        view.addSubViews([mainSurveyView])
        
        mainSurveyView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        view.backgroundColor = .blue100

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
