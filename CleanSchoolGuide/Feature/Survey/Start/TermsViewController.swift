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
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 0.9
        scrollView.bouncesZoom = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .black.withAlphaComponent(0.3)
        scrollView.addSubview(termsImageView)
        
        return scrollView
    }()
    
    private var cancellable = Set<AnyCancellable>()
    
    override func setUserInterface() {
        navigationBar.setNavigation(leftItems: [backButton])
        view.backgroundColor = .white
        view.addSubViews([navigationBar, scrollView])
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        termsImageView.snp.makeConstraints {
            $0.directionalEdges.equalTo(scrollView.contentLayoutGuide)
            $0.center.equalToSuperview()
        }
        
        termsImageView.contentMode = .scaleAspectFit
        backButton.tapPublisher.sink { [weak self] in
            self?.pop(animated: true)
        }
        .store(in: &cancellable)
    }

}

extension TermsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return termsImageView
    }
}
