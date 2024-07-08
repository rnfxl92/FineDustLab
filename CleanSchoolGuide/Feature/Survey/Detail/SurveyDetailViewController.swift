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
    private let closeButton = CustomNavigationButton(.close)
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
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        return tableView
    }()
    
    private let expandImageView: UIImageView = {
        let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFit
         return imageView
     }()
    
    private lazy var imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 0.8
        scrollView.bouncesZoom = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .black.withAlphaComponent(0.3)
        scrollView.addSubview(expandImageView)
        
        return scrollView
    }()
    
    private lazy var nextButton = LargeFloatingButtonView(.dual, defaultTitle: viewModel.isEnd ? "설문조사 완료" : "다음", cancelTitle: "이전")
        
    private let viewModel: SurveyDetailViewModel
    private let isResumed: Bool
    
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: SurveyDetailViewModel, isResumed: Bool) {
        self.viewModel = viewModel
        self.isResumed = isResumed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isResumed, viewModel.currentIndex < Preferences.surveyTemp?.lastIndex ?? 0 {
            AppRouter.shared.route(to: .surveyDetail(currentIndex: viewModel.currentIndex + 1, isResumed: true))
        }
        nextButton.isEnable = viewModel.isAllAnswered
    }
    
    override func setUserInterface() {
        hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SurveySubQuestionOXCell.self)
        tableView.register(SurveySubQuestionChoiceCell.self)
        tableView.register(SurveySubQuestionNumberPickerCell.self)
        tableView.register(SurveySubQuestionCheckboxCell.self)
        tableView.register(SurveySubQuestionSliderCell.self)
        tableView.register(SurveySubQuestionTextCell.self)
        tableView.register(SurveyHelpCell.self)
        tableView.register(SurveySubTextCell.self)
        
        var str = NSAttributedString("")
        if viewModel.totalCount > 0 {
            str = NSAttributedString(string: "\(viewModel.currentIndex + 1)/\(viewModel.totalCount)", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
                .addAttributes("\(viewModel.currentIndex + 1)", attributes: [.foregroundColor: UIColor.blue300])
                .addAttributes("/\(viewModel.totalCount)", attributes: [.foregroundColor: UIColor.gray400])
                
        }
        let totalButton = CustomNavigationButton(.attributedText(str))
        
        navigationBar.setNavigation(title: "설문조사", titleAlwaysVisible: true, leftItems: [closeButton], rightItems: [totalButton])
        
        categoryLabel.text = viewModel.survey?.categoryName
        categoryLabel.textColor = UIColor(hex: viewModel.survey?.categoryColor ?? "")
        questionLabel.text = viewModel.survey?.question
        
        titleStackView.addArrangedSubViews([categoryLabel, questionLabel])
        
        view.backgroundColor = .gray0
        view.addSubViews([imageScrollView, tableView, navigationBar, titleStackView, nextButton])
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        imageScrollView.addGestureRecognizer(tapGestureRecognizer)
        imageScrollView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        expandImageView.snp.makeConstraints {
            $0.directionalEdges.equalTo(imageScrollView.contentLayoutGuide)
            $0.center.equalToSuperview()
        }
        
        imageScrollView.isHidden = true
    }
    
    override func bind() {
        closeButton.tapPublisher.sink {
            AppRouter.shared.route(to: .home)
        }
        .store(in: &cancellable)
        
        nextButton.defaultTapPublisher.sink { [weak self] in
            guard let self else { return }
            if self.viewModel.isEnd {
                showEndAlert()
            } else {
                self.viewModel.postAnswer()
            }
        }
        .store(in: &cancellable)
        
        nextButton.cancelTapPublisher.sink { [weak self] in
            self?.pop(animated: true)
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
                        Preferences.surveyCompletedDates.append(Date())
                        AppRouter.shared.route(to: .home)
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
    
    private func showEndAlert() {
        let vc = PopupViewController(type: .dual, description: "설문조사를 완료하면 수정이 어렵습니다.\n설문조사를 완료할까요?", defualtTitle: "완료!", cancelTitle: "다시 확인", completion: { [weak self] in
            self?.viewModel.postAnswer()
        })
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc: vc, animated: true)
    }
    
}

extension SurveyDetailViewController: UITableViewDelegate {
    
}

extension SurveyDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let survey = viewModel.survey else { return .zero }
        var count = survey.subQuestions.count
        if let subText = survey.subText, subText.isNotEmpty {
            count += 1
        }
        
        if let url = survey.help, url.isNotEmpty {
            count += 1
        }

        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let subText = viewModel.survey?.subText
        
        if indexPath.item == 0, let subText, subText.isNotEmpty {
            let cell: SurveySubTextCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUIModel(subText)
            return cell
        }
        
        guard let subQuestion = viewModel
            .survey?
            .subQuestions[safe: subText.isNotNilOrEmpty ? indexPath.item - 1: indexPath.item] else {
            let cell: SurveyHelpCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.delegate = self
            if let imageUrl = viewModel.survey?.help {
                cell.setUIModel(imageUrl: imageUrl)
            }
            
            return cell
        }
        switch subQuestion.type {
        case .ox:
            let cell: SurveySubQuestionOXCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUIModel(subQuestion, answer: viewModel.anweredQustion?.first(where: { $0.subQuestionId == subQuestion.subQuestionID })?.answer, delegate: self)
            return cell
        case .choice:
            let cell: SurveySubQuestionChoiceCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUIModel(subQuestion, answer: viewModel.anweredQustion?.first(where: { $0.subQuestionId == subQuestion.subQuestionID })?.answer, delegate: self)
            
            if let optional = subQuestion.isOptional,
               optional,
               !viewModel.showOptionalDic.values.contains(subQuestion.subQuestionID) {
                cell.isHidden = true
            } else {
                cell.isHidden = false
            }
            return cell
        case .numberPicker:
            let cell: SurveySubQuestionNumberPickerCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUIModel(subQuestion, answer: viewModel.anweredQustion?.first(where: { $0.subQuestionId == subQuestion.subQuestionID })?.answer, delegate: self)
            return cell
        case .checkbox:
            let cell: SurveySubQuestionCheckboxCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUIModel(subQuestion, answer: viewModel.anweredQustion?.first(where: { $0.subQuestionId == subQuestion.subQuestionID })?.answer, delegate: self)
            return cell
        case .slider:
            let cell: SurveySubQuestionSliderCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUIModel(subQuestion, answer: viewModel.anweredQustion?.first(where: { $0.subQuestionId == subQuestion.subQuestionID })?.answer, delegate: self)
            
            return cell
        case .text:
            let cell: SurveySubQuestionTextCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setUIModel(subQuestion, answer: viewModel.anweredQustion?.first(where: { $0.subQuestionId == subQuestion.subQuestionID })?.answer, delegate: self)
            if let optional = subQuestion.isOptional,
               optional,
               !viewModel.showOptionalDic.values.contains(subQuestion.subQuestionID) {
                cell.isHidden = true
            } else {
                cell.isHidden = false
            }
            return cell
        default:
            return .init()
        }
    }
    func updateCellHidden() {
        guard let subQuestions = viewModel.survey?.subQuestions else { return }
        
        for (index, subQuestion) in subQuestions.enumerated() {
            if subQuestion.isOptional ?? false,
               let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
                cell.isHidden = !viewModel.showOptionalDic.values.contains(subQuestion.subQuestionID)
            }
        }
    }
}

extension SurveyDetailViewController: SurveySubQuestionOXCellDelegate {
    func oxButtonTapped(subQuestionId: Int, optionId: Int, showOptional: Int?) {
        viewModel.answered(subQuestionId: subQuestionId, answer: "\(optionId)", showOptional: showOptional)
        updateCellHidden()
    }
}

extension SurveyDetailViewController: SurveySubQuestionChoiceCellDelegate {
    func textUpdated(subQuestionId: Int, optionId: Int, text: String) {
        viewModel.textUpdate(subQuestionId: subQuestionId, optionId: optionId, text: text)
    }
    
    func choiceButtonTapped(subQuestionId: Int, optionId: Int, showOptional: Int?, needInput: Bool) {
        viewModel.answered(subQuestionId: subQuestionId, answer: "\(optionId)", showOptional: showOptional, needInput: needInput)
        updateCellHidden()
    }
}

extension SurveyDetailViewController: SurveySubQuestionNumberPickerCellDelegate {
    func numberPicked(subQuestionId: Int, answer: String) {
        viewModel.answered(subQuestionId: subQuestionId, answer: answer)
    }
}

extension SurveyDetailViewController: SurveySubQuestionCheckboxCellDelegate {
    func checkboxTapped(subQuestionId: Int, answer: String, needInput: Bool) {
        viewModel.answered(subQuestionId: subQuestionId, answer: answer, needInput: needInput)
    }
}

extension SurveyDetailViewController: SurveySubQuestionSliderCellDelegate {
    func radioButtonTapped(subQuestionId: Int, optionId: Int) {
        viewModel.answered(subQuestionId: subQuestionId, answer: "\(optionId)")
    }
}

extension SurveyDetailViewController: SurveySubQuestionTextCellDelegate {
    func textChanged(subQuestionId: Int, answer: String) {
        viewModel.answered(subQuestionId: subQuestionId, answer: answer)
    }
}
                                            
extension SurveyDetailViewController: SurveyHelpCellDelegate {
    func updateLayout() {
        UIView.performWithoutAnimation { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }
    }
    
    func imageTapped(image: UIImage) {
        
        expandImageView.image = image
        imageScrollView.isHidden = false
        view.bringSubviewToFront(imageScrollView)
    }
    
    
    @objc private func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        imageScrollView.isHidden = true
    }
}

extension SurveyDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return expandImageView
    }
}
