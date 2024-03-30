//
//  UIApplication+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit

extension UIApplication {

    public var keyWindows: [UIWindow]? {
        self.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
    }
}
