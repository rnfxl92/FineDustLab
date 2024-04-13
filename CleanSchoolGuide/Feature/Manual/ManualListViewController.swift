//
//  ManualListViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 4/11/24.
//

import UIKit
import Combine

final class ManualListViewController: BaseViewController {
    private let navigationBar = CustomNavigationBar()
    private let backButton = CustomNavigationButton(.back)
    private let searhButton = CustomNavigationButton(.search)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SchoolListTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        tableView.contentInset = .init(top: 30, left: 0, bottom: 100, right: 0)
        return tableView
    }()
    
    private var cancellable = Set<AnyCancellable>()
    
    override func setUserInterface() {
        navigationBar.setNavigation(title: "미세먼지 매뉴얼", titleAlwaysVisible: true, leftItems: [backButton], rightItems: [searhButton])
        
        view.backgroundColor = .gray0
        view.addSubViews([navigationBar, tableView])
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bind() {
        backButton.tapPublisher
            .sink { [weak self] in
                self?.pop(animated: true)
            }
            .store(in: &cancellable)
    }
}
