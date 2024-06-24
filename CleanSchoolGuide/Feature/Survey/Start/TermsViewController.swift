//
//  TermsViewController.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/24/24.
//

import UIKit
import Combine

final class TermsViewController: BaseViewController {
    
    private let navigationBar = CustomNavigationBar()
    private let backButton = CustomNavigationButton(.back)
    private let termsImageView = UIImageView(image: .imgTerms)
    
    private var cancellable = Set<AnyCancellable>()
    
    override func setUserInterface() {
        navigationBar.setNavigation(leftItems: [backButton])
        view.backgroundColor = .white
        view.addSubViews([navigationBar, termsImageView])
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        termsImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        termsImageView.contentMode = .scaleAspectFill
        backButton.tapPublisher.sink { [weak self] in
            self?.pop(animated: true)
        }
        .store(in: &cancellable)
    }

}
