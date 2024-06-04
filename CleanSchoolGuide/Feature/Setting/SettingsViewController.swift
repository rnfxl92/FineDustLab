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
    
    private let saveButton = CustomNavigationButton(.attributedText( "저장".foregroundColor(.green400).addAttributes("저장", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)])))
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SettingsGroupCell.self)
        tableView.register(SettingsSchoolInfoCell.self)
        tableView.register(SettingsNameCell.self)
        tableView.register(SettingsInquiryCell.self)
        tableView.register(SettingsUpdateInfoCell.self)
        tableView.register(DividerCell.self)
        tableView.register(SettingsExcelDownloadCell.self)
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
                self?.viewModel.saveButtonTapped()
            }
            .store(in: &cancellable)
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                state.isLoading ? CSGIndicator.shared.show() : CSGIndicator.shared.hide()
                switch state {
                case .saveFailed:
                    let vc = PopupViewController(type: .single, description: "정보 저장에 실패하였습니다.\n정보를 모두 입력해주세요", defualtTitle: "확인")
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self?.present(vc: vc, animated: true)
                case .saveSuccess:
                    let vc = PopupViewController(type: .single, description: "정보가 저장되었습니다.", defualtTitle: "확인")
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self?.present(vc: vc, animated: true)
                default:
                    break
                }
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
            cell.setSchool(viewModel.school)
            cell.setGrade(viewModel.grade)
            cell.setClassNum(viewModel.classNum)
            cell.setStudentNum(viewModel.studentNum)
            cell.delegate = self
            return cell
        case .name:
            let cell: SettingsNameCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.setName(viewModel.name)
            return cell
        case .divider:
            let cell: DividerCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .excelDownload:
            let cell: SettingsExcelDownloadCell = tableView.dequeueReusableCell(for: indexPath)
            cell.isHidden = !(Preferences.selectedUserType == .teacher)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch SettingsViewModel.Items(rawValue: indexPath.row) {
        case .excelDownload:
            viewModel.downloadExcel()
        default:
            break
        }
    }
}

extension SettingsViewController: SettingsGroupCellDelegate {
    func changeButtonTapped() {
    
        let vc = PopupViewController(type: .dual, description: "학습자를 다시 선택하면\n저장된 정보가 사라집니다.", defualtTitle: "다시 선택", cancelTitle: "취소", completion: {
            Preferences.clearUserDefault()
            AppRouter.shared.route(to: .selectGroup)
        })
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc: vc, animated: true)
    }
}

extension SettingsViewController: SettingsSchoolInfoCellDelegate {
    func gradeUpdated(_ grade: Int) {
        viewModel.setGrade(grade)
    }
    
    func classNumUpdated(_ classNum: Int) {
        viewModel.setClassNum(classNum)
    }
    
    func studentNumUpdated(_ studentNum: Int) {
        viewModel.setStudentNum(studentNum)
    }
    
    func schoolChangeButtonTapped() {
        let vc = SchoolSearchBottomSheetController { [weak self] school in
            guard let self else { return }
            self.viewModel.setSchool(school)
            
            if let cell = self.tableView.cellForRow(at: IndexPath(item: SettingsViewModel.Items.schoolInfo.rawValue, section: 0)) as? SettingsSchoolInfoCell {
                cell.setSchool(school)
            }
        }
        
        presentBottomSheet(vc)
    }
}

extension SettingsViewController: SettingsNameCellDelegate {
    func nameUpdated(_ name: String) {
        viewModel.setName(name)
    }
}
