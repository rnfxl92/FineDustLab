//
//  SplashViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit
import SnapKit

final class SplashViewController: BaseViewController {
    private let testLabel = {
       let label = UILabel()
        label.text = "스플래쉬 뷰 입니다."
        
        return label
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.completion?()
        }
    }
    
    override func setUserInterface() {
        view.backgroundColor = .blue100
        view.addSubview(testLabel)
        
        testLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
