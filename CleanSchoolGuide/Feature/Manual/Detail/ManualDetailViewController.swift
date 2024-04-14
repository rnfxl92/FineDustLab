//
//  ManualDetailViewController.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/14/24.
//

import UIKit
import PDFKit
import Combine

final class ManualDetailViewController: BaseViewController {
    private let navTitle: String
    private let fileName: String
    private var searchWords: String?
    
    private let navigationBar = CustomNavigationBar()
    private let backButton = CustomNavigationButton(.back)
    private let searhButton = CustomNavigationButton(.search)
    
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
        
        navigationBar.setNavigation(title: navTitle, titleAlwaysVisible: true, leftItems: [backButton], rightItems: [searhButton])
        
        view.addSubViews([navigationBar, pdfView])
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        pdfView.snp.makeConstraints {
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
