//
//  SurveyDetailViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 4/10/24.
//

import UIKit
import Combine
import CombineCocoa

final class SurveyDetailViewController: BaseViewController {
    private let navigationBar = CustomNavigationBar()
    private let backButton = CustomNavigationButton(.back)
    private let titleStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 12
        
        return stackView
    }()
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .gray900
        label.numberOfLines = 0
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SchoolListTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.clipsToBounds = false
        tableView.backgroundColor = .clear
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        return tableView
    }()
    
    private lazy var nextButton = LargeFloatingButtonView(.single, defaultTitle: "다음")
        
    private let viewModel: SurveyDetailViewModel
    
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: SurveyDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUserInterface() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SurveySubQuestionOXCell.self)
        nextButton.isEnable = false
        var str = NSAttributedString("")
        if viewModel.totalCount > 0 {
            str = NSAttributedString(string: "\(viewModel.currentIndex + 1)/\(viewModel.totalCount)", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
                .addAttributes("\(viewModel.currentIndex + 1)", attributes: [.foregroundColor: UIColor.blue300])
                .addAttributes("/\(viewModel.totalCount)", attributes: [.foregroundColor: UIColor.gray400])
                
        }
        let totalButton = CustomNavigationButton(.attributedText(str))
        
        navigationBar.setNavigation(title: "설문조사", titleAlwaysVisible: true, leftItems: [backButton], rightItems: [totalButton])
        
        categoryLabel.text = viewModel.survey?.categoryName
        categoryLabel.textColor = UIColor(hex: viewModel.survey?.categoryColor ?? "")
        questionLabel.text = viewModel.survey?.question
        
        titleStackView.addArrangedSubViews([categoryLabel, questionLabel])
        
        view.backgroundColor = .gray0
        view.addSubViews([navigationBar, titleStackView, tableView, nextButton])
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(24)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
    }
    
    override func bind() {
        backButton.tapPublisher.sink { [weak self] in
            self?.pop(animated: true)
        }
        .store(in: &cancellable)
        
        nextButton.defaultTapPublisher.sink { [weak self] in
            self?.viewModel.postAnswer()
        }
        .store(in: &cancellable)
        
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .postAnswerSuccess:
                    if self.viewModel.isEnd {
                    
                    } else {
                        AppRouter.shared.route(to: .surveyDetail(currentIndex: viewModel.currentIndex + 1))
                    }
                default:
                    break
                }
                self.nextButton.isEnable = self.viewModel.isAllAnswered
            }
            .store(in: &cancellable)
    }
    
}

extension SurveyDetailViewController: UITableViewDelegate {
    
}

extension SurveyDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.survey?.subQuestions.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let subQuestion = viewModel.survey?.subQuestions[safe: indexPath.item] else { return .init() }
        switch subQuestion.type {
        case .ox:
            let cell: SurveySubQuestionOXCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUIModel(subQuestion, delegate: self)
            return cell
        default:
            return .init()
        }
    }
    
}

extension SurveyDetailViewController: SurveySubQuestionOXCellDelegate {
    func oxSelectedId(subQuestionId: Int, optionId: Int) {
        viewModel.answerSelected(subQuestionId: subQuestionId, optionId: optionId)
    }
}
