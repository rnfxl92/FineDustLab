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
        case manualList
        case manualDetail(title: String, fileName: String, searchWords: String?)
        case surveyStart
        case surveyDetail(currentIndex: Int)
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
                if Preferences.selectedUserType == nil {
                    AppRouter.shared.route(to: .selectGroup)
                } else {
                    AppRouter.shared.route(to: .home)
                }
            }
            splashView.setRoot(for: presenter)
        case .home:
            let vc = HomeViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.setRoot(for: presenter)
        case .selectGroup:
            let vc = SelectGroupViewController()
            
            vc.setRoot(for: presenter)
        case .surveyStart:
            let vc = SurveyStartViewController()
            
            presenter?.push(vc, animated: true)
        case .surveyDetail(let currentIndex):
            let vc = SurveyDetailViewController(viewModel: .init(currentIndex: currentIndex))
            
            presenter?.push(vc, animated: true)
        case .login:
            break
        case .manualList:
            let vc = ManualListViewController()
            
            presenter?.push(vc, animated: true)
        case .manualDetail(let title, let fileName, let searchWords):
            let vc = ManualDetailViewController(title: title, fileName: fileName, searchWords: searchWords)
            
            presenter?.push(vc, animated: true)
        case .setting:
            let vc = SettingsViewController()
            
            presenter?.push(vc, animated: true)
        default:
            break
        }
    }
}
