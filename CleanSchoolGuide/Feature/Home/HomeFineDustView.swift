//
//  HomeFineDustView.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/21/24.
//

import UIKit

protocol HomeFineDustViewDelegate: AnyObject {
    func buttonTapped(type: HomeFineDustView.ViewType, value: Int, selectedIndex: Int)
}

final class HomeFineDustView: UIView {
    enum ViewType {
        case fineDust
        case ultraFineDust
        
        var title: String {
            switch self {
            case .fineDust:
                return "미세먼지"
            case .ultraFineDust:
                return "초미세먼지"
            }
        }
        
        func selectedColor(index: Int) -> UIColor {
            switch index {
            case 0:
                return .blue300
            case 1:
                return .green300
            case 2:
                return .orange300
            case 3:
                return .red300
            default:
                return .gray0
            }
        }
        
        var values: [Int] {
            switch self {
            case .fineDust:
                return [15, 60, 110, 190]
            case .ultraFineDust:
                return [5, 30, 70, 100]
            }
        }
        
        var valueTitle: [String] {
            switch self {
            case .fineDust:
                return ["0-15", "16-35", "36-80", "80 이상"]
            case .ultraFineDust:
                return ["0-31", "31-80", "81-150", "150 이상"]
            }
        }
    }
    private var selectedIndex: Int?
    private let type: ViewType
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .gray700
        label.textAlignment = .left
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(FineDustCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    weak var delegate: HomeFineDustViewDelegate?
    
    init(type: ViewType, selectedIndex: Int?) {
        self.selectedIndex = selectedIndex
        self.type = type
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func initialize() {
        titleLabel.text = type.title
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubViews([titleLabel, collectionView])
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
            $0.bottom.lessThanOrEqualToSuperview().inset(6)
        }
    }
}

extension HomeFineDustView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        type.values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FineDustCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.setUIModel(indexPath.item, isSelected: indexPath.item == selectedIndex, viewType: type)
        return cell
    }
}

extension HomeFineDustView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
        delegate?.buttonTapped(type: type, value: type.values[safe: indexPath.item] ?? 0, selectedIndex: indexPath.item)
    }
}

extension HomeFineDustView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.width - 24) / 4)
        
        return .init(width: width, height: 40)
    }
}
