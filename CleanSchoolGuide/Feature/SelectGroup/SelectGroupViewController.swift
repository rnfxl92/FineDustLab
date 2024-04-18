//
//  SelectGroupViewController.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit
import Combine
import CombineCocoa

final class SelectGroupViewController: BaseViewController {
    private let titleStackView = UIStackView(axis: .vertical)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .gray900
        label.text = "반가워요!\n누구로 접속할까요?"
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray700
        label.numberOfLines = 2
        label.text = "학습자에 따라 매뉴얼과 설문 내용이 달라요!"
        label.textAlignment = .left
        return label
    }()
    
    private let backgoundImageView: UIImageView = {
       let imageView = UIImageView(image: .imgMainBg)
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let mainImageView: UIImageView = {
       let imageView = UIImageView(image: .imgMain)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let buttonStackView = UIStackView(axis: .vertical)
    private let elementaryButton: LargeFilledButton = LargeFilledButton(title: "초등학생", defaultTitleColor: UIColor.gray900, defaultColor: UIColor.gray100, font: UIFont.systemFont(ofSize: 16))
    
    private let middleButton: LargeFilledButton = LargeFilledButton(title: "중학생", defaultTitleColor: UIColor.gray900, defaultColor: UIColor.gray100, font: UIFont.systemFont(ofSize: 16))
    
    private let highButton: LargeFilledButton = LargeFilledButton(title: "고등학생", defaultTitleColor: UIColor.gray900, defaultColor: UIColor.gray100, font: UIFont.systemFont(ofSize: 16))
    
    private let teacherButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitle("선생님으로 로그인", for: .normal)
        button.setTitleColor(.gray700, for: .normal)
        
        button.setUnderlined()
        
        return button
    }()
    
    private let viewModel = SelectGroupViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func setUserInterface() {
        view.backgroundColor = .blue100
        titleStackView.spacing = 12
        titleStackView.addArrangedSubViews([titleLabel, descriptionLabel])
        
        buttonStackView.spacing = 12
        elementaryButton.borderColor = .gray200
        elementaryButton.borderWidth = 1
        middleButton.borderColor = .gray200
        middleButton.borderWidth = 1
        highButton.borderColor = .gray200
        highButton.borderWidth = 1
        buttonStackView.addArrangedSubViews([elementaryButton, middleButton, highButton])
        
        view.addSubViews([backgoundImageView, mainImageView, titleStackView, buttonStackView, teacherButton])
        
        backgoundImageView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().dividedBy(1.3)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(52)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        teacherButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalTo(teacherButton.snp.top).inset(-72)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    override func bind() {
        
        viewModel.$state
            .sink { state in
                state.isLoading ? CSGIndicator.shared.show() : CSGIndicator.shared.hide()
                switch state {
                case .complete:
                    AppRouter.shared.route(to: .home)
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        elementaryButton.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.setUserType(.elementary)
            }.store(in: &cancellables)
        
        middleButton.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.setUserType(.middle)
            }.store(in: &cancellables)
        
        highButton.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.setUserType(.high)
            }.store(in: &cancellables)
        
        teacherButton.tapPublisher
            .sink { [weak self] _ in
                let vc = LoginBottomSheetController()
                self?.presentBottomSheet(vc)
            }
            .store(in: &cancellables)
    }
}
