//
//  SignInCoordinator.swift
//  CouponCraft
//
//  Created by 김미진 on 11/27/24.
//
import Foundation
import UIKit

protocol SignInCoordinatorDependencies {
    func makeSigninViewController(actions: SigninViewModelActions) -> SignInMainViewController
    func makeMainViewController(actions: MainViewModelActions) -> MainViewController
    func makeQRDetailsViewController(qr: CouponDataViewModel) -> QRDetailViewController
}

final class SignInCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: SignInCoordinatorDependencies
    
    private weak var mainVC: MainViewController?
    
    init(navigationController: UINavigationController,
         dependencies: SignInCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        // 로그인 화면을 보여주기 위한 SignInVC 시작
        let actions = SigninViewModelActions(showMainVC: showMainVC)
        let vc = dependencies.makeSigninViewController(actions: actions)
        
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func showMainVC() {
        // 로그인 후 네비게이션 컨트롤러를 새로 생성하여 기존 네비게이션 컨트롤러를 대체
        let actions = MainViewModelActions(showDetail: showQRDetailsVC)
        let mainVC = dependencies.makeMainViewController(actions: actions)
        
        // 새로운 네비게이션 컨트롤러 생성
        
        // 새로운 네비게이션 컨트롤러로 화면 전환
        navigationController?.setViewControllers([mainVC], animated: false)
    }
    
    private func showQRDetailsVC(qr: CouponDataViewModel) {
        let qrDetailVC = dependencies.makeQRDetailsViewController(qr: qr)
        navigationController?.pushViewController(qrDetailVC, animated: true)
    }
}
