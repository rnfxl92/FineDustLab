//
//  AppRouter.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Combine
import UIKit

public final class AppRouter: Router {
    public static let shared = AppRouter()
    
    public enum RouteType: Route, Equatable {
        //        case deeplink(DeeplinkValue)
        case splash
        case home
        case login
        case selectGroup
        case setting
        case manual
        case survey
    }
    
    private var presenter: UIWindow?
    private var loginViewController: UIViewController?
    private var currentRouteType: RouteType?
    
    public func start(_ presenter: Presentable?) {
        self.presenter = presenter as? UIWindow

        route(to: .splash)
    }
 
    public func route(to type: RouteType) {
        currentRouteType = type
        switch type {
        case .splash:
            let splashView = SplashViewController {
                AppRouter.shared.route(to: .selectGroup)
            }
            splashView.setRoot(for: presenter)
        case .home:
            let vc = HomeViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.setRoot(for: presenter)
        case .selectGroup:
            let vc = SelectGroupViewController()
            
            vc.setRoot(for: presenter)
        case .login:
            break
        default:
            break
        }
    }
}
