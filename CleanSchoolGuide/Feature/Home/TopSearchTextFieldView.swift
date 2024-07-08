//
//  TopSearchTextFieldView.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/21/24.
//

import UIKit
import Combine
import CombineCocoa

final class TopSearchTextFieldView: UIView {
    
    private let searchBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray0
        view.cornerRadius = 14
        
        return view
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal)
        stackView.spacing = 0
        return stackView
    }()
    private let searchImageView: UIImageView = {
        let imageView = UIImageView(image: .search)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray900
        
        return imageView
    }()
    
    private let searchButton = SearchFilledButton(title: "검색")
    var searchButtonTapPublisher: AnyPublisher<Void, Never> { searchButton.tapPublisher }
    var searchText: String {
        searchTextField.text ?? ""
    }
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray900
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.attributedPlaceholder = NSAttributedString(string: "미세먼지에 대해 검색해 보세요", attributes: [.foregroundColor: UIColor.gray500, .font: UIFont.systemFont(ofSize: 16, weight: .regular)])
        textField.addHideKeyboardButton(title: "완료")
        return textField
    }()
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        searchBackground.addSubViews([searchImageView, stackView])
        
        stackView.addArrangedSubViews([searchTextField, searchButton])
        searchImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(searchImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(4)
        }
        
        searchButton.snp.makeConstraints {
            $0.width.equalTo(64)
        }
        addSubViews([searchBackground])
        searchBackground.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        searchButton.isHidden = true
        
        searchTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.searchButton.isHidden = text.isNilOrEmpty
            }
            .store(in: &cancellable)
        
    }
}

final class SearchFilledButton: UIButton {
    private let defaultTitleColor: UIColor
    private let defaultColor: UIColor
    private let disabledColor: UIColor
    private let disabledTitleColor: UIColor

    init(title: String,
         defaultTitleColor: UIColor = .gray0,
         defaultColor: UIColor = .green400,
         disabledTitleColor: UIColor = .gray400,
         disabledColor: UIColor = .gray200
    ) {
        self.defaultColor = defaultColor
        self.defaultTitleColor = defaultTitleColor
        self.disabledTitleColor = disabledTitleColor
        self.disabledColor = disabledColor
        
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        setBackgroundColor(color: defaultColor, forState: .normal)
        setBackgroundColor(color: disabledColor, forState: .disabled)
        setTitleColor(defaultTitleColor, for: .normal)
        setTitleColor(disabledColor, for: .disabled)
        
        layer.cornerRadius = 14
        layer.masksToBounds = true
        
        snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.greaterThanOrEqualTo(intrinsicContentSize.width)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

