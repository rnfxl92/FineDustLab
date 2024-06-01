//
//  PopupViewController.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/18/24.
//

import UIKit
import Combine
import CombineCocoa

final class PopupViewController: BaseViewController {
    enum ButtonType {
        case single
        case dual
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 12
        
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray900
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray700
        label.numberOfLines = 4
        label.textAlignment = .center
        return label
    }()

    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    private var defaultButton: LargeFilledButton?
    private var cancelButton: LargeFilledButton?

    private var titleText: String?
    private var descriptionText: String?
    private var completion: (() -> Void)?
    private var cancelCompletion: (() -> Void)?
    private var buttonType: ButtonType

    init(type: ButtonType,
         title: String? = nil,
         description: String? = nil,
         defualtTitle: String,
         cancelTitle: String? = nil,
         completion: (() -> Void)? = nil,
         cancelCompletion: (() -> Void)? = nil
    ) {
        self.titleText = title
        self.descriptionText = description
        self.buttonType = type
        self.completion = completion
        self.cancelCompletion = cancelCompletion
        super.init(nibName: nil, bundle: nil)

        defaultButton = LargeFilledButton(title: defualtTitle)
        if type == .dual {
            cancelButton = LargeFilledButton(title: cancelTitle ?? "취소", defaultTitleColor: .gray900, defaultColor: .gray200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUserInterface() {
        view.backgroundColor = .clear
        contentView.backgroundColor = .gray0
        
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
        titleLabel.isHidden = titleText.isNilOrEmpty
        descriptionLabel.isHidden = descriptionText.isNilOrEmpty
        
        setupLayouts()
    }

    private func setupLayouts() {
        
        titleStackView.addArrangedSubViews([titleLabel, descriptionLabel])
        if let cancelButton {
            buttonStackView.addArrangedSubview(cancelButton)
        }
        if let defaultButton {
            buttonStackView.addArrangedSubview(defaultButton)
        }
        contentView.addSubViews([titleStackView, buttonStackView])
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(24)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        view.addSubViews([dimmedView, contentView])

        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview().inset(24)
            make.trailing.lessThanOrEqualToSuperview().inset(24)
            make.width.greaterThanOrEqualTo(280)
            make.center.equalToSuperview()
        }
    }

    override func bind() {
        defaultButton?.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true) {
                    self.completion?()
                }
            }
            .store(in: &cancellables)

        cancelButton?.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true) {
                    self.cancelCompletion?()
                }
            }
            .store(in: &cancellables)
    }
}
