//
//  MainViewModel.swift
//  CouponCraft
//
//  Created by 김미진 on 10/8/24.
//

import Foundation
import AVFoundation
import UIKit

// MARK: - Actions (ViewModel에서 호출될 액션 정의)
struct MainViewModelActions {
    let showDetail: (CouponDataViewModel) -> Void // QR 항목 세부 사항을 보여주는 액션
}

// MARK: - MainViewModel의 Input, Output 정의

// Input 프로토콜: 뷰에서 호출되는 메서드들
protocol MainViewModelInput {
    func viewDidLoad()
    func didSelectItem(at index: Int)
    func openAppSettings()
    func checkCameraPermission()
    func checkPhotoLibraryOnlyAddPermission()
    func checkPhotoLibraryPermission()
    func startScanning(previewLayer: AVCaptureVideoPreviewLayer)
    func stopScanning()
    func saveMyQRList()
    func fetchMyQRList()
    func loadLatestVersion(completion: @escaping (String?) -> Void)
}

// Output 프로토콜: 뷰모델에서 뷰로 전달될 데이터들
protocol MainViewModelOutput {
    var userCouponItems: Observable<[CouponDataViewModel]> { get }
    var error: Observable<String> { get }
    var scannedResult: Observable<String> { get }
    var cameraPermission: Observable<Bool?> { get }
    var photoLibraryPermission: Observable<Bool?> { get }
    var photoLibraryOnlyAddPermission: Observable<Bool?> { get }
}

// MainViewModel 타입: Input과 Output을 모두 결합한 타입
typealias MainViewModel = MainViewModelInput & MainViewModelOutput

// MARK: - MainViewModel 구현 (ViewModel)

final class DefaultMainViewModel: MainViewModel {
    
    // MARK: - Dependencies (필수 의존성들)
    private let loginUseCase: LoginUseCase
    private let permissionUseCase: PermissionUseCase
    private let getQRListUseCase: GetQRListUseCase
    private let qrScannerUseCase: QRScannerUseCase
    private let fetchAppVersionUseCase: FetchAppVersionUseCase
    private let ccHomeUseCase: CCHomeUseCase
    private let actions: MainViewModelActions?
    private let mainQueue: DispatchQueueType
    
//    private var ListLoadTask: Cancellable? { willSet { ListLoadTask?.cancel() } } // QR 항목 로딩을 위한 Cancellable 객체
    
    // MARK: - Output (출력 프로퍼티)
    let userCouponItems: Observable<[CouponDataViewModel]> = Observable([]) // QR 항목 뷰모델 리스트
    let homeData: Observable<CCHomeData?> = Observable(nil) // QR 항목 뷰모델 리스트
    let error: Observable<String> = Observable("") // 오류 메시지
    let scannedResult: Observable<String> = Observable("") // 스캔된 결과
    let cameraPermission: Observable<Bool?> = Observable(nil) // 카메라 권한 상태
    let photoLibraryPermission: Observable<Bool?> = Observable(nil) // 사진 라이브러리 권한 상태
    let photoLibraryOnlyAddPermission: Observable<Bool?> = Observable(nil) // 사진 라이브러리 추가 권한 상태
    
    // MARK: - Init (초기화)
    init(
        loginUseCase: LoginUseCase,
        permissionUseCase: PermissionUseCase,
        getQRListUseCase: GetQRListUseCase,
        qrScannerUseCase: QRScannerUseCase,
        fetchAppVersionUseCase: FetchAppVersionUseCase,
        ccHomeUseCase: CCHomeUseCase,
        actions: MainViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.loginUseCase = loginUseCase
        self.permissionUseCase = permissionUseCase
        self.getQRListUseCase = getQRListUseCase
        self.qrScannerUseCase = qrScannerUseCase
        self.fetchAppVersionUseCase = fetchAppVersionUseCase
        self.ccHomeUseCase = ccHomeUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }

    // MARK: - Private Methods (비공개 메서드)

    // QR 항목 로딩
    private func load() {
        // 일반 로그인으로 접근 한 경우
        if let userData = UserManager.shared.userInfo {
            //TODO: - userData로 그릴 수 있는건 먼저 여기서 그리자.
            mainDataLoad()
        }else {
            if let authToken = UserManager.shared.getAuthToken() {
                // authToken이 정상으로 살아있는경우 -> 정상 적인 동작
                // 자동 로그인으로 접근한 경우 현재 로그인 데이터가 없어서 로그인데이터부터 받아와야한다.
                loginUseCase.autoLogin(authToken: authToken) {[weak self] result in
                    switch result {
                    case .success(let userData):
                        print("로그인 성공")
                        UserManager.shared.saveUserInfo(userData)
                        // 로그인 로직을 성공한 후 메인 데이터를 로드한다.
                        // TODO: - 유저 데이터가 있으니까 여기서 그릴 수 있는건 그리자
                        self?.mainDataLoad()
                    case .failure(let failure):
                        print("로그인 실패 ")
                        // TODO: - 로그인에 실패했다. 로그인 화면으로 돌려보내는 로직이 필요하다.
                    }
                }
            }else {
                // TODO: - authToken이 없는경우 앞단에서 한번 체크를 하지만 중복체크! -> authToken이 없는경우 여기오면 안됌 로그인으로 돌려보내는 로직 필요.
            }
        }
    }
    
    // Home을 그리기위한 데이터 로드
    private func mainDataLoad() {
        guard let userData = UserManager.shared.userInfo else {
            // TODO: - 상단에서 로그인을 처리 다하고 내려왔지만 userInfo가 누락된 경우. 로그인이 필요하다고 로그인 페이지로 보내야함.
            error.value = "로그인이 필요합니다."
            return
        }
        
        ccHomeUseCase.fetchCCHomeData(token: userData.token) {[weak self] result in
            switch result {
            case .success(let data):
                self?.fetchHomeUI(data)
            case .failure(let failure):
                //TODO: - Home데이터 통신에 실패한경우.
                print("서버와 연결이 불안정합니다.")
            }
        }
    }
    
//    private func fetchList(_ qrTypes: [CouponItem]) {
//        userCouponItems.value = qrTypes.map(CouponDataViewModel.init)
//    }
    
    private func fetchHomeUI(_ homeData: CCHomeData) {
        self.homeData.value = homeData
        self.userCouponItems.value = homeData.myCoupons.map(CouponDataViewModel.init)
    }
    
    
    func saveMyQRList() {
        
    }
    
    // 저장된 내 QRList Fetch
    func fetchMyQRList() {
        
    }
    
    
    // 오류 처리
    private func handle(error: Error) {
        
    }
    
    // MARK: - Permissions Check (권한 확인)

    // 설정 화면으로 이동하는 메서드
    func openAppSettings() {
        permissionUseCase.openAppSettings()
    }
    
    // 사진 라이브러리 권한 확인
    func checkPhotoLibraryPermission() {
        permissionUseCase.checkPhotoLibraryPermission { [weak self] isPermission in
            self?.photoLibraryPermission.value = isPermission
        }
    }

    // 사진 라이브러리 추가 권한 확인
    func checkPhotoLibraryOnlyAddPermission() {
        permissionUseCase.checkPhotoLibraryAddOnlyPermission { [weak self] isPermission in
            self?.photoLibraryOnlyAddPermission.value = isPermission
        }
    }
    
    // 카메라 권한 확인
    func checkCameraPermission() {
        permissionUseCase.checkCameraPermission { [weak self] isPermission in
            self?.cameraPermission.value = isPermission
        }
    }

    // MARK: - Image Download (이미지 다운로드)
    
    // MARK: - QR Scanning (QR 코드 스캔)

    // 카메라로 QR 코드 스캔 시작
    func startScanning(previewLayer: AVCaptureVideoPreviewLayer) {
        qrScannerUseCase.startScanning(previewLayer: previewLayer) { [weak self] result in
            self?.mainQueue.async {
                self?.scannedResult.value = result // 스캔된 결과 업데이트
            }
        }
    }

    // QR 코드 스캔 중지
    func stopScanning() {
        qrScannerUseCase.stopScanning()
    }
    
    // MARK: App Setting
    
    func loadLatestVersion(completion: @escaping (String?) -> Void) {
        fetchAppVersionUseCase.execute { [weak self] latestVersion in
            completion(latestVersion)
        }
    }
    
}

// MARK: - Input (뷰 이벤트 처리)

extension DefaultMainViewModel {
    
    // 뷰 로드 시 호출
    func viewDidLoad() {
        load()
    }
    
    // 항목 선택 시 호출
    func didSelectItem(at index: Int) {
        actions?.showDetail(userCouponItems.value[index]) // 선택된 항목에 대한 세부 정보 표시
    }
}
