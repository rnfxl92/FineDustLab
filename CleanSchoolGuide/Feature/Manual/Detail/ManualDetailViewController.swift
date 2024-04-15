//
//  ManualDetailViewController.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/14/24.
//

import UIKit
import PDFKit
import Combine
import CombineCocoa

final class ManualDetailViewController: BaseViewController {
    private let navigationBar = CustomNavigationBar()
    private let backButton = CustomNavigationButton(.back)
    private let searchButton = CustomNavigationButton(.search)
    
    private let searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray0
        
        return view
    }()
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
        textField.attributedPlaceholder = NSAttributedString(string: "미세먼지에 대해 검색해 보세요", attributes: [.foregroundColor: UIColor.gray500])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.blue300, for: .normal)
        
        return button
    }()
    
    private lazy var pdfView: PDFView = {
        let view = PDFView()
        if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "pdf") {
            view.document = PDFDocument(url: fileURL)
        }
        view.displayMode = .singlePageContinuous
        view.autoScales = true
        view.displayDirection = .vertical
        return view
    }()
    
    private let searchedWordsView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray900
        
        return view
    }()
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        
        return view
    }()
    private let searchedWordsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray600
        label.text = "찾은 단어"
        return label
    }()
    private let prevButton: UIButton = {
        let button = UIButton()
        button.setImage(.icUp, for: .normal)
        button.tintColor = .gray600
        
        return button
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(.icDown, for: .normal)
        button.tintColor = .gray600
        
        return button
    }()
    private let currentIndexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let navTitle: String
    private let fileName: String
    private var searchWords: String?
    private var searchResults: [PDFSelection] = []
    private var currentIndex: Int = 0
    
    private var cancellable = Set<AnyCancellable>()
    
    init(title: String, fileName: String, searchWords: String?) {
        self.navTitle = title
        self.fileName = fileName
        self.searchWords = searchWords
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUserInterface() {
        view.backgroundColor = .gray0
        searchTextField.delegate = self
        
        navigationBar.setNavigation(title: navTitle, titleAlwaysVisible: true, leftItems: [backButton], rightItems: [searchButton])
        
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
        
        searchContainerView.addSubViews([searchBackground, cancelButton])
        searchBackground.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(48)
        }
        cancelButton.snp.makeConstraints {
            $0.leading.equalTo(searchBackground.snp.trailing).offset(16)
            $0.width.equalTo(30)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        searchedWordsView.addSubViews([searchedWordsLabel, currentIndexLabel, divider, prevButton, nextButton])
        searchedWordsLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.trailing.directionalVerticalEdges.equalToSuperview()
            $0.width.equalTo(48)
        }
        prevButton.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview()
            $0.width.equalTo(48)
            $0.trailing.equalTo(nextButton.snp.leading)
        }
        divider.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.width.equalTo(1)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(prevButton.snp.leading).offset(-4)
        }
        currentIndexLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(divider.snp.leading).offset(-14)
        }
        
        view.addSubViews([navigationBar, searchContainerView, pdfView, searchedWordsView])
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        searchContainerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(navigationBar.snp.height).priority(.high)
        }
        
        pdfView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchedWordsView.snp.makeConstraints {
            $0.height.equalTo(48 + view.safeAreaInsets.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        searchedWordsView.isHidden = true
        searchContainerView.isHidden = true
    }
    
    override func bind() {
        backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.pop(animated: true)
            }
            .store(in: &cancellable)
        
        searchTextField
            .textPublisher
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] word in
                self?.searchForText(word ?? "")
            }
            .store(in: &cancellable)
        
        searchButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.searchContainerView.isHidden = false
                self.view.bringSubviewToFront(self.searchContainerView)
                self.searchedWordsView.isHidden = false
            }
            .store(in: &cancellable)
        
        cancelButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.searchContainerView.isHidden = true
                self?.view.endEditing(true)
                if self?.searchResults.isEmpty ?? true {
                    self?.searchedWordsView.isHidden = true
                }
            }
            .store(in: &cancellable)
        
        nextButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.nextButtonTapped()
            }
            .store(in: &cancellable)
        
        prevButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.prevButtonTapped()
            }
            .store(in: &cancellable)
    }
    private func searchForText(_ text: String) {
        guard let document = pdfView.document else { return }
        removeExistingHighlights()
        
        let searchSelections = document.findString(text, withOptions: .caseInsensitive)
        self.searchResults = searchSelections
        highlightSelections(searchSelections)
        if let firstSelection = searchSelections.first {
            pdfView.go(to: firstSelection)
        }
    }
    
    private func removeExistingHighlights() {
            guard let document = pdfView.document else { return }
            currentIndex = 0
            for pageIndex in 0..<document.pageCount {
                guard let page = document.page(at: pageIndex) else { continue }
                let annotations = page.annotations
                annotations.forEach { annotation in
                    if annotation.type == "Highlight" {
                        page.removeAnnotation(annotation)
                    }
                }
            }
        }
        
    private func highlightSelections(_ selections: [PDFSelection]) {
        for selection in selections {
            guard let pages = selection.pages.first else { continue }
            let highlight = PDFAnnotation(bounds: selection.bounds(for: pages), forType: .highlight, withProperties: nil)
            highlight.color = .yellow
            pages.addAnnotation(highlight)
        }
        updateButton()
    }
    
    private func nextButtonTapped() {
        // 다음 검색 결과로 이동
        if currentIndex < searchResults.count - 1 {
            currentIndex += 1
            let selection = searchResults[currentIndex]
            pdfView.go(to: selection)
            pdfView.setCurrentSelection(selection, animate: true)
            updateButton()
        }
    }
    
    private func prevButtonTapped() {
        // 이전 검색 결과로 이동
        if currentIndex > 0 {
            currentIndex -= 1
            let selection = searchResults[currentIndex]
            pdfView.go(to: selection)
            pdfView.setCurrentSelection(selection, animate: true)
            updateButton()
        }
    }
    
    private func updateButton() {
        var currentIdx: String = "0"
        var totalIdx: String = "/\(searchResults.count)"
        if searchResults.isNotEmpty {
            currentIdx = "\(currentIndex + 1)"
        }
        var str = NSAttributedString(string: currentIdx + totalIdx, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)])
            .addAttributes(currentIdx, attributes: [.foregroundColor: UIColor.blue300])
            .addAttributes(totalIdx, attributes: [.foregroundColor: UIColor.gray400])
        currentIndexLabel.attributedText = str
        
        prevButton.isEnabled = currentIndex > 0
        prevButton.tintColor = prevButton.isEnabled ? .gray600 : .gray800
        nextButton.isEnabled = searchResults.count > 0 && currentIndex < searchResults.count - 1
        nextButton.tintColor = nextButton.isEnabled ? .gray600 : .gray800
        
    }
}

extension ManualDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 10
    }
}
