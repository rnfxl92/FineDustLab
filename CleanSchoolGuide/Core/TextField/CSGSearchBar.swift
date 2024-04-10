//
//  SearchTextField.swift
//  FineDustLab
//
//  Created by 박성민 on 3/31/24.
//

import UIKit

class CSGSearchBar: UISearchBar {
    
    var textFieldBackgroundColor: UIColor = .gray0 {
        didSet {
            searchTextField.backgroundColor = textFieldBackgroundColor
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDefaultUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setDefaultUserInterface()
    }
    
    func setDefaultUserInterface() {
        self.searchBarStyle = UISearchBar.Style.minimal
        self.placeholder = ""
        let searchField = self.value(forKey: "searchField") as! UITextField
        searchField.textColor = .gray900
    }
    
    private var isSetupView: Bool = false
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard !isSetupView else { return }
        isSetupView = true
        configure()
    }
    
    private func configure() {
        let image = UIImageView(image: .search.withTintColor(.gray700, renderingMode: .alwaysTemplate))
        image.sizeToFit()
        image.frame = CGRect(x: 5, y: 0, width: image.frame.size.width, height: image.frame.size.height)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: image.frame.size.width + 10, height: image.frame.size.height))
        container.addSubview(image)
        setSearchFieldLeftView(container)
        searchBarStyle = .default
        tintColor = .gray900
        searchTextField.font = .systemFont(ofSize: 14, weight: .regular)
        self.setShowsCancelButton(false, animated: false)
        
        searchTextField.backgroundColor = .gray0
        self.setSearchFieldCornerRadius(14)
        layer.cornerRadius = 14
        layer.masksToBounds = true
        self.setImage(UIImage.searchButton, for: .search, state: .normal)
    }
    
    public func updateRadius(radius: CGFloat) {
        self.setSearchFieldCornerRadius(radius)
        self.layer.cornerRadius = radius
    }
    
    public func configureTextAttributes(placeHolder: String) {
        
        let attr = NSAttributedString(string: placeHolder)
            .addAttributes(placeHolder, attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.gray400])

        setAttributedPlaceholder(attr)
        searchTextField.font = .systemFont(ofSize: 14, weight: .regular)
        searchTextField.textColor = .gray900
    }
}
