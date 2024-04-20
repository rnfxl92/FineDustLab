//
//  SchoolSearchBottomSheetController.swift
//  FineDustLab
//
//  Created by 박성민 on 4/6/24.
//

import UIKit
import Combine
import CombineCocoa

final class SchoolSearchBottomSheetController: BaseViewController, BottomSheetPresentable {
    
    private let searchBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.cornerRadius = 14
        return view
    }()
    
    private let searchImageView: UIImageView = {
        let imageView = UIImageView(image: .search)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray900
        
        return imageView
    }()

    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.attributedPlaceholder = NSAttributedString(string: "학교를 검색해 주세요", attributes: [.foregroundColor: UIColor.gray500])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.addHideKeyboardButton(title: "완료")
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SchoolListTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        return tableView
    }()
    private let viewModel = SchoolSearchBottomSheetViewModel()
    private var completion: ((SchoolModel) -> Void)?
    private var dataSource: [SchoolModel] = []
    private let namePublisher = PassthroughSubject<String, Never>()
    private var cancellable = Set<AnyCancellable>()
    
    init(completion: ((SchoolModel) -> Void)? = nil) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUserInterface() {
        hideKeyboardWhenTappedAround()
        searchTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = .gray0
        searchBackground.addSubViews([searchImageView, searchTextField])
        searchImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(searchImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubViews([tableView, searchBackground])
        
        searchBackground.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBackground.snp.bottom).offset(24)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(floor(UIScreen.main.bounds.height * 0.7))
            $0.bottom.equalToSuperview()
        }
    }
    
    override func bind() {
        let output = viewModel.bind(
            .init(
                name: searchTextField.textPublisher.eraseToAnyPublisher()
            )
        )
        
        output.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loading:
                    CSGIndicator.shared.show()
                case .searched(let data):
                    CSGIndicator.shared.hide()
                    self?.dataSource = data
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellable)
    }
}

extension SchoolSearchBottomSheetController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 10
    }
}

extension SchoolSearchBottomSheetController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = dataSource[safe: indexPath.item] else { return .init() }
        let cell: SchoolListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setUIModel(.init(name: data.schulNm, address: data.orgRdnma))
        return cell
    }
    
}

extension SchoolSearchBottomSheetController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = dataSource[safe: indexPath.item] else { return }
        completion?(data)
        dismiss(animated: true)
    }
}
