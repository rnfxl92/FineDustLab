//
//  LargeFloatingButton.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/11/24.
//

import Combine
import UIKit

protocol LargeFloatingButtonViewDelegate: AnyObject {
    func defaultButtonTouched()
    func cancelButtonTouched()
}

final class LargeFloatingButtonView: UIView {
    static let noneContentHeight = 94.0

    enum ViewType {
        case single
        case dual
    }
    
    private let containerStackView = UIStackView(axis: .vertical)
    private let gradientView = UIView()
    private let contentContainerView = UIView()
    private let contentsStackView = UIStackView(axis: .vertical)
    private let defaultButton = UIButton(type: .custom)
    private let cancelButton = UIButton(type: .custom)
    private let defaultColor: UIColor
    
    var cancelTapPublisher: AnyPublisher<Void, Never> { cancelButton.tapPublisher }
    var defaultTapPublisher: AnyPublisher<Void, Never> { defaultButton.tapPublisher }
    
    weak var delegate: LargeFloatingButtonViewDelegate?
    var isEnable: Bool = true {
        didSet {
            defaultButton.isEnabled = isEnable
        }
    }
    
    init(_ type: ViewType,
         defaultTitle: String,
         defaultTitleColor: UIColor = .gray0,
         defaultColor: UIColor = .green400,
         disabledTitleColor: UIColor = .gray400,
         disabledColor: UIColor = .gray200,
         cancelTitle: String? = nil,
         backgroundColor: UIColor = .gray0,
         contentsView: UIView? = nil) {
        self.defaultColor = defaultColor

        super.init(frame: .zero)

        let buttonStackView = UIStackView()
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10

        if type == .dual {
            buttonStackView.addArrangedSubview(cancelButton)
            cancelButton.titleLabel?.font = .body.bold
            cancelButton.titleLabel?.lineBreakMode = .byTruncatingTail
            cancelButton.setTitle(cancelTitle, for: .normal)
            cancelButton.setTitleColor(.gray700, for: .normal)
            cancelButton.setBackgroundColor(color: .gray200, forState: .normal)
            cancelButton.cornerRadius = 14
        }
        
        buttonStackView.addArrangedSubview(defaultButton)
        defaultButton.titleLabel?.font = .body.bold
        defaultButton.titleLabel?.lineBreakMode = .byTruncatingTail
        defaultButton.setTitle(defaultTitle, for: .normal)
        defaultButton.setTitleColor(defaultTitleColor, for: .normal)
        defaultButton.setBackgroundColor(color: defaultColor, forState: .normal)
        defaultButton.setTitleColor(disabledTitleColor, for: .disabled)
        defaultButton.setBackgroundColor(color: disabledColor, forState: .disabled)
        defaultButton.cornerRadius = 14
        
        buttonStackView.layer.borderColor = UIColor.line.withAlphaComponent(0.16).cgColor
        
        buttonStackView.layer.borderWidth = 1
        buttonStackView.layer.masksToBounds = true

        gradientView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            self.gradientView.setVerticalGradient(startColor: backgroundColor.withAlphaComponent(0),
                                                  endColor: backgroundColor.withAlphaComponent(1))
        }

        contentContainerView.backgroundColor = backgroundColor

        contentsStackView.addArrangedSubViews([buttonStackView])
        contentsStackView.spacing = 24

        if let contentsView = contentsView {
            contentsStackView.insertArrangedSubview(contentsView, aboveArrangedSubview: buttonStackView)
        }
        contentContainerView.addSubViews([contentsStackView])
        containerStackView.addArrangedSubViews([gradientView, contentContainerView])

        addSubview(containerStackView)

        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        contentsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDefaultTitle(_ title: String) {
        defaultButton.setTitle(title, for: .normal)
    }
}

