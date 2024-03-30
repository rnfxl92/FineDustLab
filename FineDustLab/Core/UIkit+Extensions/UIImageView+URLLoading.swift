//
//  UIImageView+URLLoading.swift
//  FineDustLab
//
//  Created by 박성민 on 2023/07/13.
//  
//

import UIKit
import Nuke
import NukeExtensions
import Combine

public typealias ImageLoaddingCompletion = (Result<UIImage, Error>) -> Void

extension UIImageView {
    public func loadImage(url: URL?,
                          isHighPriority: Bool = false,
                          placeholder: UIImage? = nil,
                          failureImage: UIImage? = nil,
                          duration: TimeInterval = 0.0,
                          completion: ImageLoaddingCompletion? = nil) {

        let request = ImageRequest(url: url,
                                   priority: isHighPriority ? .high : .normal)
        let options = ImageLoadingOptions(placeholder: placeholder,
                                          transition: .fadeIn(duration: duration),
                                          failureImage: failureImage)
        loadImage(request, options, completion)
    }
}

extension UIImageView {
    private func loadImage(_ imageRequest: ImageRequest,
                           _ options: ImageLoadingOptions,
                           _ completion: ImageLoaddingCompletion? = nil) {
        
        NukeExtensions.loadImage(with: imageRequest,
                       options: options,
                       into: self) { result in
            switch result {
            case .success(let response):
                completion?(.success(response.image))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
