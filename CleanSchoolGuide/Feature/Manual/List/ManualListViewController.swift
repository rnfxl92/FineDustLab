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
    private let searchBarContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .gray0
        return view
    }()
    private let searchBar = TopSearchTextFieldView()
    private let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.blue300, for: .normal)
        
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
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
    private let viewModel = ManualListViewModel()
    
    override func setUserInterface() {
        hideKeyboardWhenTappedAround()
        tableView.register(ManualListCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationBar.setNavigation(title: "미세먼지 매뉴얼", titleAlwaysVisible: true, leftItems: [backButton], rightItems: [searhButton])
        
        searchBarContainerView.addSubViews([searchBar, cancelButton])
        searchBar.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(48)
        }
        cancelButton.snp.makeConstraints {
            $0.leading.equalTo(searchBar.snp.trailing).offset(16)
            $0.width.equalTo(30)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        view.backgroundColor = .gray0
        view.addSubViews([navigationBar, searchBarContainerView, tableView])
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        searchBarContainerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(navigationBar.snp.height).priority(.high)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        searchBarContainerView.isHidden = true
    }
    
    override func bind() {
        backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.pop(animated: true)
            }
            .store(in: &cancellable)
        searhButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.searchBarContainerView.isHidden = false
            }
            .store(in: &cancellable)
        
        cancelButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.searchBarContainerView.isHidden = true
            }
            .store(in: &cancellable)
        searchBar.searchButtonTapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self, self.searchBar.searchText.isNotEmpty else { return }
                if self.viewModel.checkPdf(self.searchBar.searchText) {
                    AppRouter.shared.route(to: .manualDetail(title: "미세먼지 매뉴얼", fileName: Preferences.selectedUserType?.rawValue ?? "", searchWords: self.searchBar.searchText))
                } else {
                    CSGToast.show("'\(self.searchBar.searchText)' 검색자료가 없습니다.", view: UIApplication.shared.keyWindows?.last ?? view)
                }
            }
            .store(in: &cancellable)
    }
}

extension ManualListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Preferences.selectedUserType  {
        case .elementary:
            let chapter = ManualCategory.Elementary.allCases
            guard let section = chapter[safe: indexPath.section],
                  let row = section.subChapters[safe: indexPath.row] else { break }
            AppRouter.shared.route(to: .manualDetail(title: row.title, fileName: row.fileName, searchWords: nil))
        case .middle, .high:
            let chapter = ManualCategory.Middle.allCases
            
            guard let section = chapter[safe: indexPath.section],
                  let row = section.subChapters[safe: indexPath.row]
            else { break }
            AppRouter.shared.route(to: .manualDetail(title: row.title, fileName: row.fileName, searchWords: nil))

        case .teacher:
            let chapter = ManualCategory.Teacher.allCases
            
            guard let section = chapter[safe: indexPath.section],
                  let row = section.subChapters[safe: indexPath.row]
            else { break }
            AppRouter.shared.route(to: .manualDetail(title: row.title, fileName: row.fileName, searchWords: nil))
        default:
            let chapter = ManualCategory.Elementary.allCases
            
            guard let section = chapter[safe: indexPath.section],
                  let row = section.subChapters[safe: indexPath.row]
            else { break }
            AppRouter.shared.route(to: .manualDetail(title: row.title, fileName: row.fileName, searchWords: nil))
        }
    }
}

extension ManualListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch Preferences.selectedUserType {
        case .elementary:
            ManualCategory.Elementary.allCases.count
        case .middle, .high:
            ManualCategory.Middle.allCases.count
        case .teacher:
            ManualCategory.Teacher.allCases.count
        default:
            ManualCategory.Elementary.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Preferences.selectedUserType {
        case .elementary:
            ManualCategory.Elementary.allCases[safe: section]?.subChapters.count ?? 0
        case .middle, .high:
            ManualCategory.Middle.allCases[safe: section]?.subChapters.count ?? 0
        case .teacher:
            ManualCategory.Teacher.allCases[safe: section]?.subChapters.count ?? 0
        default:
            ManualCategory.Elementary.allCases[safe: section]?.subChapters.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Preferences.selectedUserType {
        case .elementary:
            let chapter = ManualCategory.Elementary.allCases
            guard let section = chapter[safe: indexPath.section],
                  let row = section.subChapters[safe: indexPath.row]
            else { return .init() }
            let cell: ManualListCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUIModel(row.title)
            
            return cell
        case .middle, .high:
            let chapter = ManualCategory.Middle.allCases
            
            guard let section = chapter[safe: indexPath.section],
                  let row = section.subChapters[safe: indexPath.row]
            else { return .init() }
            let cell: ManualListCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUIModel(row.title)
            
            return cell
        case .teacher:
            let chapter = ManualCategory.Teacher.allCases
            
            guard let section = chapter[safe: indexPath.section],
                  let row = section.subChapters[safe: indexPath.row]
            else { return .init() }
            let cell: ManualListCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUIModel(row.title)
            
            return cell
        default:
            let chapter = ManualCategory.Elementary.allCases
            
            guard let section = chapter[safe: indexPath.section],
                  let row = section.subChapters[safe: indexPath.row]
            else { return .init() }
            let cell: ManualListCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUIModel(row.title)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var chapter: String = ""
        var title: String = ""
        switch Preferences.selectedUserType {
        case .elementary:
            guard let category = ManualCategory.Elementary.allCases[safe: section] else { return .init() }
            chapter = category.rawValue
            title = category.title
        case .middle, .high:
            guard let category = ManualCategory.Middle.allCases[safe: section] else { return .init() }
            chapter = category.rawValue
            title = category.title
        case .teacher:
            guard let category = ManualCategory.Teacher.allCases[safe: section] else { return .init() }
            chapter = category.rawValue
            title = category.title
        default:
            guard let category = ManualCategory.Elementary.allCases[safe: section] else { return .init() }
            chapter = category.rawValue
            title = category.title
        }
        
        let headerView = ManualListHeaderView()
        headerView.setUIModel(chapter: chapter, title: title)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 24
    }
}
