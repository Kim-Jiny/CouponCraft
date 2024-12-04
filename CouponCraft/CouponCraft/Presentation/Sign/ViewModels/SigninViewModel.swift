//
//  SigninViewModel.swift
//  CouponCraft
//
//  Created by 김미진 on 11/27/24.
//

import Foundation
import AVFoundation
import UIKit

// MARK: - Actions (ViewModel에서 호출될 액션 정의)
struct SigninViewModelActions {
    let showMainVC: () -> Void  // 로그인 성공 시 MainViewController를 보여주는 액션
}

// MARK: - MainViewModel의 Input, Output 정의

// Input 프로토콜: 뷰에서 호출되는 메서드들
protocol SigninViewModelInput {
    func viewDidLoad()
    func successLogin()
    func googleLogin(_ presenter: UIViewController)
    func appleLogin(_ presenter: UIViewController)
    func kakaoLogin(_ presenter: UIViewController)
    func localLogin(_ presenter: UIViewController)
}

// Output 프로토콜: 뷰모델에서 뷰로 전달될 데이터들
protocol SigninViewModelOutput {
    var error: Observable<String> { get }
}

// MainViewModel 타입: Input과 Output을 모두 결합한 타입
typealias SigninViewModel = SigninViewModelInput & SigninViewModelOutput

// MARK: - MainViewModel 구현 (ViewModel)
// MARK: - DefaultSigninViewModel (로그인 처리 추가)

final class DefaultSigninViewModel: SigninViewModel {
    
    // MARK: - Dependencies
    private let permissionUseCase: PermissionUseCase
    private let fetchAppVersionUseCase: FetchAppVersionUseCase
    private let actions: SigninViewModelActions?
    private let socialLoginUseCase: SocialLoginUseCase // 로그인 유스케이스 추가
    private let mainQueue: DispatchQueueType
    
    // MARK: - Output (출력 프로퍼티)
    let error: Observable<String> = Observable("") // 오류 메시지
    
    // MARK: - Init (초기화)
    init(
        permissionUseCase: PermissionUseCase,
        fetchAppVersionUseCase: FetchAppVersionUseCase,
        socialLoginUseCase: SocialLoginUseCase, // 로그인 유스케이스 의존성 추가
        actions: SigninViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.permissionUseCase = permissionUseCase
        self.fetchAppVersionUseCase = fetchAppVersionUseCase
        self.socialLoginUseCase = socialLoginUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }

    // MARK: - Private Methods (비공개 메서드)

    // 오류 처리
    private func handle(error: Error) {
        self.error.value = error.localizedDescription
    }
}

// MARK: - Input (뷰 이벤트 처리)

extension DefaultSigninViewModel {
    
    // 뷰 로드 시 호출
    func viewDidLoad() {
        // 추가 초기화 작업이 필요하면 여기서 처리
    }
    
    // 로그인 성공
    func successLogin() {
        self.actions?.showMainVC()
        //TODO: 전달 받은 유저데이터 처리
    }
    
    // Google 로그인
    func googleLogin(_ presenter: UIViewController) {
        socialLoginUseCase.googleLogin(presenter: presenter) { [weak self] result in
            switch result {
            case .success(_):
                self?.successLogin()
            case .failure(let error):
                self?.handle(error: error)
            }
        }
    }

    // Apple 로그인
    func appleLogin(_ presenter: UIViewController) {
        socialLoginUseCase.appleLogin(presenter: presenter) { [weak self] result in
            switch result {
            case .success(_):
                self?.successLogin()
            case .failure(let error):
                self?.handle(error: error)
            }
        }
    }

    // Kakao 로그인
    func kakaoLogin(_ presenter: UIViewController) {
        socialLoginUseCase.kakaoLogin(presenter: presenter) { [weak self] result in
            switch result {
            case .success(_):
                self?.successLogin()
            case .failure(let error):
                self?.handle(error: error)
            }
        }
    }
    
    func localLogin(_ presenter: UIViewController) {
        
    }
}
