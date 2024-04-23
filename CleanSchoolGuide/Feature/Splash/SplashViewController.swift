//
//  SplashViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit
import SnapKit

final class SplashViewController: BaseViewController {
    private let centerStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 20
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: .mainAppIcon)
        imageView.contentMode = .scaleAspectFit
        imageView.cornerRadius = 36
        return imageView
    }()
    private let appNameImageView: UIImageView = {
        let imageView = UIImageView(image: .appName)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let bottomStackView1: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.distribution = .fillProportionally
        stackView.spacing = 17
        return stackView
    }()
    private let bottomStackView2: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.distribution = .fillProportionally
        stackView.spacing = 17
        return stackView
    }()
    private let sponsor1ImageView: UIImageView = {
        let imageView = UIImageView(image: .sponsor1)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let sponsor2ImageView: UIImageView = {
        let imageView = UIImageView(image: .sponsor2)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let sponsor3ImageView: UIImageView = {
        let imageView = UIImageView(image: .sponsor3)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let sponsor4ImageView: UIImageView = {
        let imageView = UIImageView(image: .sponsor4)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private var completion: (() -> Void)?
    
    init(completion: (() -> Void)?
    ) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        checkDatas()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.completion?()
        }
    }
    
    override func setUserInterface() {
        view.backgroundColor = .gray0
        centerStackView.addArrangedSubViews([iconImageView, appNameImageView])
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(72)
        }
        appNameImageView.snp.makeConstraints {
            $0.width.equalTo(160)
            $0.height.equalTo(30)
        }
        bottomStackView1.addArrangedSubViews([sponsor1ImageView, sponsor2ImageView])
        bottomStackView2.addArrangedSubViews([sponsor3ImageView, sponsor4ImageView])
        
        view.addSubViews([centerStackView, bottomStackView1, bottomStackView2])
        
        centerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        bottomStackView1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(bottomStackView2.snp.top).offset(-20)
            $0.leading.greaterThanOrEqualToSuperview().inset(24)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
        }
        
        bottomStackView2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.leading.greaterThanOrEqualToSuperview().inset(24)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
        }
    }
    
    private func checkDatas() {
        if let fine = Preferences.fineData {
            if !fine.time.isToday {
                Preferences.fineData = nil
            }
        }
        
        if let fine = Preferences.ultraFineData {
            if !fine.time.isToday {
                Preferences.ultraFineData = nil
            }
        }
    }
}
