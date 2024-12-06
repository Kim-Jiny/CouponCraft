//
//  AppFlowCoordinator.swift
//  CouponCraft
//
//  Created by 김미진 on 10/8/24.
//

import Foundation
import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }

    func start() {
        if isUserLoggedIn() {
            // 유저가 로그인 되어있으면 MainCoordinator 시작 -> userData는 받아와야하는데,
            let flow = makeMainCoordinator(navigationController: navigationController)
            flow.start()
        } else {
            // 로그인되지 않았다면 SignInCoordinator 시작
            let flow = makeSignInCoordinator(navigationController: navigationController)
            flow.start()
        }
    }
    
    private func isUserLoggedIn() -> Bool {
        // 로그인 여부 확인 로직 추가
        // 예를 들어, UserDefaults, Keychain, 또는 세션 데이터를 확인할 수 있음
        // return UserDefaults.standard.bool(forKey: "isLoggedIn")
        // 자동 로그인이 설정되어있고 실제로 소셜로그인에서 토큰을 받아올수있는지 확인할 수 있는경우, + authToken이 살아있는경우 ( 유저가 앱내에서 로그아웃을 누르면 사라짐 )
        
//        if let authToken = UserManager.shared.getAuthToken() {
//        }
        //테스트를 위해서 authToken 임의 지정
        UserManager.shared.updateAuthToken("임의로 지정한 내 어쓰토큰")
        return true
    }
    
    func makeMainCoordinator(navigationController: UINavigationController) -> MainCoordinator {
        MainCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    func makeSignInCoordinator(navigationController: UINavigationController) -> SignInCoordinator {
        SignInCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension AppFlowCoordinator: MainCoordinatorDependencies {
    
    func makeMainViewController(actions: MainViewModelActions) -> MainViewController {
        MainViewController.create(with: makeMainViewModel(actions: actions))
    }
    
    func makeMainViewModel(actions: MainViewModelActions) -> MainViewModel {
        DefaultMainViewModel(
            loginUseCase: makeLoginUseCase(),
            permissionUseCase: makePermissionUseCase(),
            getQRListUseCase: makeGetQRListUseCase(),
            qrScannerUseCase: makeQRScannerUseCase(),
            fetchAppVersionUseCase: makeFetchAppVersionUseCase(),
            ccHomeUseCase: makeCCHomeUseCase(),
            actions: actions
        )
    }
    
    func makeQRDetailsViewController(qr: CouponDataViewModel) -> QRDetailViewController {
        QRDetailViewController.create(with: makeQRDetailsViewModel(qr: qr))
    }
    
    
    func makeQRDetailsViewModel(qr: CouponDataViewModel) -> QRDetailViewModel {
        DefaultQRDetailViewModel(qrData: qr)
    }
    
    
    // MARK: - Use Cases
    func makePermissionUseCase() -> PermissionUseCase {
        PermissionUseCaseImpl(repository: makePermissionRepository())
    }
    
    func makeGetQRListUseCase() -> GetQRListUseCase {
        DefaultGetQRListUseCase(qrListRepository: makeQRListRepository())
    }
    
    func makeQRScannerUseCase() -> QRScannerUseCase {
        QRScannerUseCaseImpl(repository: makeQRScannerRepository())
    }
    
    func makeFetchAppVersionUseCase() -> FetchAppVersionUseCase {
        DefaultFetchAppVersionUseCase(repository: makeAppVersionRepository())
    }
    
    func makeLoginUseCase() -> LoginUseCase {
        DefaultLoginUseCase(userRepository: makeUserRepository(),
                                  appleLoginRepository: makeAppleLoginRepository())
    }
    
    func makeCCHomeUseCase() -> CCHomeUseCase {
        DefaultCCHomeUseCase(ccHomeRepository: makeCCHomeRepository())
    }
    
    // MARK: - Repositories
    private func makePermissionRepository() -> PermissionRepository {
        PermissionRepositoryImpl(cameraPermissionDataSource: makeCameraPermissionDataSource(),
                                 photoLibraryPermissionDataSource: makePhotoLibraryPermissionDataSource())
    }
    
    private func makeQRListRepository() -> QRListRepository {
        DefaultRQListRepository()
    }
    
    private func makeQRScannerRepository() -> QRScannerRepository {
        QRScannerRepositoryImpl()
    }
    
    private func makeAppVersionRepository() -> AppVersionRepository {
        DefaultAppVersionRepository()
    }
    
    private func makeUserRepository() -> UserRepository {
        DefaultUserRepository()
    }
    
    private func makeAppleLoginRepository() -> AppleLoginRepository {
        DefaultAppleLoginRepository()
    }
    
    private func makeCCHomeRepository() -> CCHomeRepository {
        DefaultCCHomeRepository(networkManager: NetworkManager())
    }
    
    //MARK: - DataSource
    private func makeCameraPermissionDataSource() -> CameraPermissionDataSource {
        CameraPermissionDataSource()
    }
    
    private func makePhotoLibraryPermissionDataSource() -> PhotoLibraryPermissionDataSource {
        PhotoLibraryPermissionDataSource()
    }
}

extension AppFlowCoordinator: SignInCoordinatorDependencies {
    func makeSigninViewController(actions: SigninViewModelActions) -> SignInMainViewController {
        SignInMainViewController.create(with: makeSignViewModel(actions: actions))
    }
    
    func makeSignViewModel(actions: SigninViewModelActions) -> SigninViewModel {
        DefaultSigninViewModel(
            permissionUseCase: makePermissionUseCase(),
            fetchAppVersionUseCase: makeFetchAppVersionUseCase(),
            socialLoginUseCase: makeLoginUseCase(),
            actions: actions
        )
    }
}
