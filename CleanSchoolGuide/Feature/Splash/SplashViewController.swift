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
        return imageView
    }()
    private let appNameImageView: UIImageView = {
        let imageView = UIImageView(image: .appName)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.distribution = .fillProportionally
        stackView.spacing = 17
        return stackView
    }()
    private let company1ImageView: UIImageView = {
        let imageView = UIImageView(image: .company1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let company2ImageView: UIImageView = {
        let imageView = UIImageView(image: .company2)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let company3ImageView: UIImageView = {
        let imageView = UIImageView(image: .company3)
        imageView.contentMode = .scaleAspectFill
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
        bottomStackView.addArrangedSubViews([company1ImageView, company2ImageView, company3ImageView])
        
        
        view.addSubViews([centerStackView, bottomStackView])
        
        centerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        bottomStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
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
