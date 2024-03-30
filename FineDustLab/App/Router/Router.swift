//
//  Router.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

public protocol Route {}

public protocol Router {
    associatedtype RouteType: Route
    
    func route(to type: RouteType)
}
