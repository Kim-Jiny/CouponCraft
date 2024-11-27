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
}

// Output 프로토콜: 뷰모델에서 뷰로 전달될 데이터들
protocol SigninViewModelOutput {
    var error: Observable<String> { get }
}

// MainViewModel 타입: Input과 Output을 모두 결합한 타입
typealias SigninViewModel = SigninViewModelInput & SigninViewModelOutput

// MARK: - MainViewModel 구현 (ViewModel)

final class DefaultSigninViewModel: SigninViewModel {
    
    // MARK: - Dependencies (필수 의존성들)
    private let permissionUseCase: PermissionUseCase
    private let fetchAppVersionUseCase: FetchAppVersionUseCase
    private let actions: SigninViewModelActions?
    private let mainQueue: DispatchQueueType
    
    private var ListLoadTask: Cancellable? { willSet { ListLoadTask?.cancel() } } // QR 항목 로딩을 위한 Cancellable 객체
    
    // MARK: - Output (출력 프로퍼티)
    let error: Observable<String> = Observable("") // 오류 메시지
    
    // MARK: - Init (초기화)
    init(
        permissionUseCase: PermissionUseCase,
        fetchAppVersionUseCase: FetchAppVersionUseCase,
        actions: SigninViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.permissionUseCase = permissionUseCase
        self.fetchAppVersionUseCase = fetchAppVersionUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }

    // MARK: - Private Methods (비공개 메서드)

    
    // 오류 처리
    private func handle(error: Error) {
        
    }
    
}

// MARK: - Input (뷰 이벤트 처리)

extension DefaultSigninViewModel {
    
    // 뷰 로드 시 호출
    func viewDidLoad() {
        
    }
    
    // 로그인 성공
    func successLogin() {
        self.actions?.showMainVC()
    }
}
