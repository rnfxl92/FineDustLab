//
//  FDIndicator.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit

final class CSGIndicator {
    static let shared = CSGIndicator()
    private let dimmedView = DimmedView()
    private let stackView = UIStackView(axis: .vertical)
    private let indicator = UIActivityIndicatorView()
    private let messageLabel = UILabel()
    private(set) var isWebView = false
    
    var isLoading: Bool {
        indicator.isAnimating
    }

    private init() {
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20

        indicator.color = .gray0

        messageLabel.font = .body.regular
        messageLabel.textColor = .gray0
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        stackView.addArrangedSubViews([indicator, messageLabel])
        
        dimmedView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func show(with message: String? = nil, isWebView: Bool = false, color: UIColor = .gray0) {
        guard let keyWindow = UIApplication.shared.keyWindows?.first else { return }
        keyWindow.addSubViews([dimmedView])

        indicator.color = color
        self.isWebView = isWebView
        
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        indicator.startAnimating()

        if let message {
            messageLabel.isHidden = false
            messageLabel.text = message
            dimmedView.backgroundColor = .gray500
        } else {
            messageLabel.isHidden = true
            messageLabel.text = nil
            dimmedView.backgroundColor = .clear
        }
    }
    
    func hide() {
        indicator.stopAnimating()
        dimmedView.removeFromSuperview()
    }
}

private final class DimmedView: UIView {
    private var isTouched: Bool {
        CSGIndicator.shared.isWebView
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        isTouched ? nil : self
    }
}

