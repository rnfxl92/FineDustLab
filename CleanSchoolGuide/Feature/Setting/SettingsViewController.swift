//
//  SettingViewController.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/17/24.
//

import UIKit
import Combine

final class SettingsViewController: BaseViewController {
   
    private let navigationBar = CustomNavigationBar()
    private let backButton = CustomNavigationButton(.back)
    private let saveButton = CustomNavigationButton(.text("저장"))
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SettingsGroupCell.self)
        tableView.register(SettingsSchoolInfoCell.self)
        tableView.register(SettingsNameCell.self)
        tableView.register(SettingsInquiryCell.self)
        tableView.register(SettingsUpdateInfoCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        tableView.tableHeaderView = nil
        tableView.contentInset = .init(top: 0, left: 0, bottom: 50, right: 0)
        return tableView
    }()
    
    private let viewModel = SettingsViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func setUserInterface() {
        hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .gray0
        
        navigationBar.setNavigation(title: "설정", titleAlwaysVisible: true, leftItems: [backButton], rightItems: [saveButton])
        
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.pop(animated: true)
            }
            .store(in: &cancellable)
        saveButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.pop(animated: true)
            }
            .store(in: &cancellable)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingsViewModel.Items.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = SettingsViewModel.Items(rawValue: indexPath.row) else { return .init() }
        switch item {
        case .group:
            let cell: SettingsGroupCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case .schoolInfo:
            let cell: SettingsSchoolInfoCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case .name:
            let cell: SettingsNameCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .inquiry:
            let cell: SettingsInquiryCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .updateInfo:
            let cell: SettingsUpdateInfoCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    
}

extension SettingsViewController: UITableViewDelegate {
    
}

extension SettingsViewController: SettingsGroupCellDelegate {
    func changeButtonTapped() {
//    
//        let vc = PopupViewController(type: .dual, description: errorStr, defualtTitle: "확인")
        
        Preferences.selectedUserType = nil
        Preferences.userInfo = nil
        AppRouter.shared.route(to: .selectGroup)
    }
}

extension SettingsViewController: SettingsSchoolInfoCellDelegate {
    func schoolChangeButtonTapped() {
        let vc = SchoolSearchBottomSheetController { [weak self] school in
            // TODO: school update
        }
        
        presentBottomSheet(vc)
        
    }
}
