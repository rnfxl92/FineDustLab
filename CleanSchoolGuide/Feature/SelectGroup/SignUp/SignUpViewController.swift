//
//  SignUpViewController.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/20/24.
//

import UIKit
import Combine

final class SignUpViewController: BaseViewController {
    private let navigationBar = CustomNavigationBar()
    private let backButton = CustomNavigationButton(.back)
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SignUpSchoolCell.self)
        tableView.register(SignUpNameCell.self)
        tableView.register(SignUpEmailCell.self)
        tableView.register(SignUpPasswordCell.self)
        tableView.register(SignUpButtonCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        tableView.tableHeaderView = nil
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        return tableView
    }()
    
    private let viewModel = SignUpViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func setUserInterface() {
        hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .gray0
        
        navigationBar.setNavigation(title: "회원가입", titleAlwaysVisible: true, leftItems: [backButton])
        
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
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                state.isLoading ? CSGIndicator.shared.show() : CSGIndicator.shared.hide()
                
                switch state {
                case .schoolUpated(let school):
                    if let cell = self?.tableView.cellForRow(at: IndexPath(item: SignUpViewModel.Items.school.rawValue, section: 0)) as? SignUpSchoolCell {
                        cell.setSchool(school)
                    }
                case .none:
                    break
                case .error(let errorStr):
                    let vc = PopupViewController(type: .single, description: errorStr, defualtTitle: "확인")
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self?.present(vc: vc, animated: true)
                case .signUpSuccessed:
                    Preferences.selectedUserType = .teacher
                    AppRouter.shared.route(to: .home)
                default:
                    self?.updateSignAble()
                }
            }
            .store(in: &cancellable)
    }
    private func updateSignAble() {
        if let cell = tableView.cellForRow(at: IndexPath(item: SignUpViewModel.Items.signUpButton.rawValue, section: 0)) as? SignUpButtonCell {
            
            cell.setUIModel(viewModel.isSignable, isTermsAgreed: viewModel.termsAgree)
            
        }
    }
}

extension SignUpViewController: UITableViewDelegate {
    
}

extension SignUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SignUpViewModel.Items.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = SignUpViewModel.Items.allCases[safe: indexPath.item] else { return .init() }
        switch item {
            
        case .school:
            let cell: SignUpSchoolCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            if let school = viewModel.school {
                cell.setSchool(school)
            }
            return cell
        case .name:
            let cell: SignUpNameCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case .email:
            let cell: SignUpEmailCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case .password:
            let cell: SignUpPasswordCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case .signUpButton:
            let cell: SignUpButtonCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        }
        return .init()
    }
    
    
}

extension SignUpViewController: SignUpSchoolCellDelegate {
    func schoolTextFieldTapped() {
        let vc = SchoolSearchBottomSheetController { [weak self] school in
            self?.viewModel.setSchool(school)
        }
        presentBottomSheet(vc)
    }
}

extension SignUpViewController: SignUpNameCellDelegate {
    func nameChanged(_ name: String) {
        viewModel.setName(name)
    }
}

extension SignUpViewController: SignUpEmailCellDelegate {
    func emailChanged(_ email: String) {
        viewModel.setEmail(email)

        DispatchQueue.main.async { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.layoutIfNeeded()
            self?.tableView.endUpdates()
        }
    }
}

extension SignUpViewController: SignUpPasswordCellDelegate {
    func passwordBeginFirstResponder() {
        tableView.scrollToRow(at: IndexPath(item: SignUpViewModel.Items.password.rawValue, section: 0), at: .top, animated: true)
    }
    
    func passwordChanged(_ password: String) {
        viewModel.setPassword(password)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.layoutIfNeeded()
            self?.tableView.endUpdates()
        }
    }
    
    func passwordCheckChanged(_ passwordCheck: String) {
        viewModel.setPasswordCheck(passwordCheck)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.layoutIfNeeded()
            self?.tableView.endUpdates()
        }
    }
    
}

extension SignUpViewController: SignUpButtonCellDelegate {
    func termsAgreeTapped() {
        viewModel.termAgreed()
    }
    
    func signUpButtonTapped() {
        viewModel.requestSignUp()
    }
}