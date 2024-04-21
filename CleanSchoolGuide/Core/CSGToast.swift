//
//  CSGToast.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/21/24.
//

import UIKit
import SnapKit

final class CSGToast {
    private static let duration: TimeInterval = 3
    private static var currentToast: CSGToastView?

    static func show(_ string: String, view: UIView) {
        currentToast?.removeFromSuperview()

        let toast = CSGToastView(string)
        view.addSubview(toast)
        
        toast.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(56)
            make.left.right.equalToSuperview().inset(16)
        }

        currentToast = toast

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 0.3) {
                toast.alpha = 0
            } completion: { _ in
                toast.removeFromSuperview()
                currentToast = nil
            }
        }
    }
}

class CSGToastView: UIView {
    private let label = UILabel()

    init(_ string: String) {
        super.init(frame: .zero)

        backgroundColor = .gray800.withAlphaComponent(0.8)
        layer.cornerRadius = 20
        clipsToBounds = true

        label.text = string
        label.textColor = .gray0
        label.numberOfLines = 0
        label.textAlignment = .center
        addSubview(label)

        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIViewController {
    func showToast(_ string: String) {
        CSGToast.show(string, view: view)
    }
}

