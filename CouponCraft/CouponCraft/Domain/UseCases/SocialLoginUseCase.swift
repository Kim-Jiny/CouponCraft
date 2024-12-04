//
//  SocialLoginUseCase.swift
//  CouponCraft
//
//  Created by 김미진 on 12/4/24.
//
import GoogleSignIn
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

// 로그인 관련 유스케이스 정의
protocol SocialLoginUseCase: AnyObject {
    func googleLogin(presenter: UIViewController, completion: @escaping (Result<UserInfoDTO, Error>) -> Void)
    func appleLogin(presenter: UIViewController, completion: @escaping (Result<UserInfoDTO, Error>) -> Void)
    func kakaoLogin(presenter: UIViewController, completion: @escaping (Result<UserInfoDTO, Error>) -> Void)
}

class DefaultSocialLoginUseCase: SocialLoginUseCase {
    
    private let userRepository: UserRepository // 유저 데이터를 받아오는 리포지토리
    private let appleLoginRepository: AppleLoginRepository // 애플 로그인 로직을 담당하는 리포지토리 리포지토리
    
    init(userRepository: UserRepository,
         appleLoginRepository: AppleLoginRepository) {
        self.userRepository = userRepository
        self.appleLoginRepository = appleLoginRepository
    }
    
    // Google 로그인
    func googleLogin(presenter: UIViewController, completion: @escaping (Result<UserInfoDTO, Error>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presenter) { signInResult, error in
            guard error == nil, let user = signInResult?.user, let token = user.idToken?.tokenString else {
                completion(.failure(error ?? NSError()))
                return
            }
            // 성공적으로 로그인되면 서버에서 유저 데이터를 받아옴
            self.fetchUserDataFromServer(authToken: token, loginType: .google, completion: completion)
        }
    }

    // Apple 로그인
    func appleLogin(presenter: UIViewController, completion: @escaping (Result<UserInfoDTO, Error>) -> Void) {
        appleLoginRepository.performAppleLogin() { result in
            switch result {
            case .success(let appleIDCredential):
                // 애플 로그인 성공 후 서버에서 유저 데이터를 받아옴
                self.fetchUserDataFromServer(authToken: appleIDCredential.user, loginType: .apple, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Kakao 로그인
    func kakaoLogin(presenter: UIViewController, completion: @escaping (Result<UserInfoDTO, Error>) -> Void) {
        
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                        completion(.failure(error))
                    } else {
                        print("loginWithKakaoAccount() success. \(oauthToken)")
                        // TODO: oauthToken?.idToken 이 null일때 어떻게할까???
                        self.fetchUserDataFromServer(authToken: oauthToken?.idToken ?? "", loginType: .kakao, completion: completion)
                    }
                }
            } else {
                print("loginWithKakaoAccount() success. \(oauthToken)")

                self.fetchUserDataFromServer(authToken: oauthToken?.idToken ?? "", loginType: .kakao, completion: completion)
            }
        }
    }
    
    // 서버에서 유저 정보를 받아오는 메서드
    private func fetchUserDataFromServer(authToken: String, loginType: LoginType, completion: @escaping (Result<UserInfoDTO, Error>) -> Void) {
        userRepository.fetchUserData(authToken: authToken, loginType: loginType) { result in
            switch result {
            case .success(let userData):
                completion(.success(userData)) // 유저 데이터 반환
            case .failure(let error):
                completion(.failure(error)) // 실패 시 에러 반환
            }
        }
    }
}
