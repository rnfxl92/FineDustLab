//
//  CustomNavigationBar.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit
import SnapKit

class CustomNavigationBar: UIView {
    private let contentView: UIView = UIView()
    private let stackView: UIStackView = UIStackView(axis: .horizontal)
    private var titleLabel: UILabel?
    private var largeTitleLabel: UILabel?
    private var centerView: UIView = UIView()
    private let bottomLine: UIView = UIView()
    private var fadeInItems: [UIView] = []
    
    private var largeTitleTopConstraint: Constraint?
    private var largeTitleBottomConstraint: Constraint?
    private var contentViewBottomConstraint: Constraint?
    
    private var prefersLargeTitles: Bool = true
    private var titleAlwaysVisible: Bool = false
    
    let barHeight: CGFloat = 56
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = .clear
        
        contentView.embed(in: self)
        contentView.snp.makeConstraints { make in
            make.height.equalTo(barHeight)
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            contentViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }
        contentViewBottomConstraint?.deactivate()

        contentView.addSubview(stackView)
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
        }

        contentView.addSubview(bottomLine)
        bottomLine.alpha = 0
        bottomLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.bottom.equalToSuperview()
        }
        fadeInItems.append(bottomLine)
    }
}

extension CustomNavigationBar {
    func setNavigation(title: String? = nil,
                       largeTitleFont: UIFont = .title1.fixedBold,
                       prefersLargeTitles: Bool = true,
                       titleAlwaysVisible: Bool = false,
                       leftItems: [UIView] = [],
                       centerView: UIView? = nil,
                       centerViewInsets: UIEdgeInsets = .zero,
                       rightItems: [UIView] = [],
                       backgroundColor: UIColor = .gray0,
                       bottomLineColor: UIColor = .gray100) {
        self.prefersLargeTitles = prefersLargeTitles
        self.titleAlwaysVisible = titleAlwaysVisible
        contentView.backgroundColor = backgroundColor
        bottomLine.backgroundColor = bottomLineColor
        
        stackView.addArrangedSubViews(leftItems)

        if let title = title {
            setTitleView(title, largeTitleFont: largeTitleFont)
        }
        if let centerView = centerView {
            setCenterView(centerView, insets: centerViewInsets)
        }
        stackView.addArrangedSubview(self.centerView)
        stackView.addArrangedSubViews(rightItems)
        setPrefersLargeTitles()
    }
    
    func update(with scrollView: UIScrollView) {
        let offsetY = max(0, scrollView.contentOffset.y)
        updateAlpha(max(0, min(1, (offsetY - 20) / 20)))
        largeTitleTopConstraint?.update(offset: max(barHeight - (largeTitleLabel?.height ?? 0), barHeight - offsetY))
    }
}

extension CustomNavigationBar {
    private func setPrefersLargeTitles() {
        if prefersLargeTitles && largeTitleLabel != nil {
            largeTitleBottomConstraint?.activate()
            contentViewBottomConstraint?.deactivate()
        } else {
            largeTitleBottomConstraint?.deactivate()
            contentViewBottomConstraint?.activate()
        }
    }
    
    private func setTitleView(_ title: String?, largeTitleFont: UIFont = .title1.fixedBold) {
        titleLabel = UILabel()
        titleLabel?.alpha = titleAlwaysVisible ? 1 : 0
        titleLabel?.font = .title3.regular
        titleLabel?.text = title
        titleLabel?.textColor = .gray100
        if let label = titleLabel {
            setCenterView(label)
            if prefersLargeTitles {
                fadeInItems.append(label)
            }
        }
        
        if prefersLargeTitles {
            largeTitleLabel = UILabel()
            largeTitleLabel?.text = title
            largeTitleLabel?.font = largeTitleFont
            largeTitleLabel?.textColor = .gray100
            
            largeTitleLabel?.embed(in: self)
            largeTitleLabel?.snp.makeConstraints { make in
                largeTitleTopConstraint = make.top.equalTo(safeAreaLayoutGuide).offset(barHeight).constraint
                make.left.right.equalToSuperview().inset(16)
                largeTitleBottomConstraint = make.bottom.equalToSuperview().constraint
            }
            bringSubviewToFront(contentView)
        }
    }
    
    private func setCenterView(_ view: UIView?, insets: UIEdgeInsets = .zero) {
        view?.embed(in: centerView)
        view?.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(insets.top)
            make.left.equalToSuperview().inset(insets.left)
            make.right.equalToSuperview().inset(insets.right)
            make.bottom.equalToSuperview().inset(insets.bottom)
        }
    }
    
    private func updateAlpha(_ alpha: CGFloat) {
        guard !titleAlwaysVisible else { return }
        
        fadeInItems.forEach {
            $0.alpha = alpha
        }
        
        if prefersLargeTitles {
            largeTitleLabel?.alpha = 1 - alpha
        }
    }
}

