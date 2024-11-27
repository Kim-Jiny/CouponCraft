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
            // 유저가 로그인 되어있으면 MainCoordinator 시작
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
        return false
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
            permissionUseCase: makePermissionUseCase(),
            getQRListUseCase: makeGetQRListUseCase(),
            qrScannerUseCase: makeQRScannerUseCase(),
            downloadImageUseCase: makeDownloadImageUseCase(),
            qrItemUseCase: makeQRItemUseCase(),
            fetchAppVersionUseCase: makeFetchAppVersionUseCase(),
            actions: actions
        )
    }
    
    func makeQRDetailsViewController(qr: QRItem) -> QRDetailViewController {
        QRDetailViewController.create(with: makeMoviesDetailsViewModel(qr: qr))
    }
    
    
    func makeMoviesDetailsViewModel(qr: QRItem) -> QRDetailViewModel {
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
    
    func makeDownloadImageUseCase() -> DownloadImageUseCase {
        DownloadImageUseCase(repository: makeImageDownloadRepository())
    }
    
    func makeQRItemUseCase() -> QRItemUseCase {
        QRItemUseCase(repository: makeQRItemRepository())
    }
    
    func makeFetchAppVersionUseCase() -> FetchAppVersionUseCase {
        DefaultFetchAppVersionUseCase(repository: makeAppVersionRepository())
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
    
    private func makeImageDownloadRepository() -> ImageDownloadRepository {
        ImageDownloadRepositoryImpl()
    }
    
    private func makeQRItemRepository() -> QRItemRepository {
        QRItemRepository()
    }
    
    private func makeAppVersionRepository() -> AppVersionRepository {
        DefaultAppVersionRepository()
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
            actions: actions
        )
    }
}
