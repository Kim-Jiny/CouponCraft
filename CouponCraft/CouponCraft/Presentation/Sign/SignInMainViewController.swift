//
//  SignInMainViewController.swift
//  CouponCraft
//
//  Created by 김미진 on 11/27/24.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

class SignInMainViewController: UIViewController, XibInstantiable {
    
    private var viewModel: SigninViewModel!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var signInMainView: UIView!
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var socialLine: PaddedLabel!
    @IBOutlet weak var socialStackView: UIStackView!
    @IBOutlet weak var signUpLB: UILabel!
    @IBOutlet weak var signInBottomConstraints: NSLayoutConstraint!
    
    // MARK: - Lifecycle

    static func create(
        with viewModel: SigninViewModel
    ) -> SignInMainViewController {
        let view = SignInMainViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
//        self.setupBehaviours()
        self.bind(to: self.viewModel)
        self.viewModel.viewDidLoad()
        self.keyboardSetting()
    }

    override func viewDidAppear(_ animated: Bool) {
        signInMainView.roundTopCorners(cornerRadius: 35)
    }
    
    private func setupViews() {
        textFieldStackView.removeAllArrangedSubviews()
        mainStackView.setCustomSpacing(30, after: textFieldStackView)
        
        let emailView = UserTextFieldView()
        let emailViewData = UserTextFieldData(title: "Email", placeholder: "your@email.com", type: .email)
        emailView.fill(with: emailViewData)
        textFieldStackView.addArrangedSubview(emailView)
        
        let pwView = UserTextFieldView()
        let pwViewData = UserTextFieldData(title: "Password", placeholder: "password", type: .password)
        pwView.fill(with: pwViewData)
        textFieldStackView.addArrangedSubview(pwView)
        
        enterBtn.layer.cornerRadius = 20
        socialLine.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // 전체 문자열
        let fullText = "Don't have an account? Sign up"
        let blueBoldText = "Sign up"

        // NSAttributedString 생성
        let attributedString = NSMutableAttributedString(string: fullText)

        // 특정 텍스트에 색상 및 볼드 폰트 적용
        if let range = fullText.range(of: blueBoldText) {
            let nsRange = NSRange(range, in: fullText)
            let boldFont = UIFont.boldSystemFont(ofSize: 16)
            attributedString.addAttributes([
                .foregroundColor: UIColor.speedMain0,
                .font: boldFont
            ], range: nsRange)
        }

        // UILabel에 적용
        signUpLB.attributedText = attributedString
        
        setupSocialLogin()
    }
    
    private func bind(to viewModel: SigninViewModel) {
        
    }
    
    private func keyboardSetting() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false  // 다른 터치 이벤트가 막히지 않게 설정
        view.addGestureRecognizer(tapGesture)
        
        
        // 키보드 상태 감지 노티피케이션 등록
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    deinit {
        // 노티피케이션 해제
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)  // 키보드를 닫는다
    }
    
    // 키보드가 올라올 때
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            // 하단 Constraint 업데이트
            signInBottomConstraints.constant = keyboardHeight + 16 // 필요하면 여백 추가
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // 키보드가 내려갈 때
    @objc private func keyboardWillHide(_ notification: Notification) {
        // 하단 Constraint 초기화
        signInBottomConstraints.constant = 30 // 기본 여백으로 복원
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupSocialLogin() {
        let ggBtn = GIDSignInButton()
        ggBtn.style = .standard
        ggBtn.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
        socialStackView.addArrangedSubview(ggBtn)
        
        let appleBtn = ASAuthorizationAppleIDButton()
        appleBtn.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
        socialStackView.addArrangedSubview(appleBtn)
        
        let kakaoBtn = UIButton()
        kakaoBtn.imageView?.contentMode = .scaleAspectFill
        kakaoBtn.imageView?.layer.cornerRadius = 8
        kakaoBtn.setImage(UIImage(named: "kakao_login_medium_wide"), for: .normal)
        kakaoBtn.addTarget(self, action: #selector(kakaoLogin), for: .touchUpInside)
        socialStackView.addArrangedSubview(kakaoBtn)
    }
    
    @objc private func googleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
          guard error == nil else { return }

          // If sign in succeeded, display the app's main content View.
        }
    }
    @objc private func appleLogin() {
        print("Start sign in")
        
        let provider = ASAuthorizationAppleIDProvider()
        let requset = provider.createRequest()
        
        // 사용자에게 제공받을 정보를 선택 (이름 및 이메일) -- 아래 이미지 참고
        requset.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [requset])
        // 로그인 정보 관련 대리자 설정
        controller.delegate = self
        // 인증창을 보여주기 위해 대리자 설정
        controller.presentationContextProvider = self
        // 요청
        controller.performRequests()
    }
    
    @objc private func kakaoLogin() {
        // 카카오톡 실행 가능 여부 확인
//        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("loginWithKakaoAccount() success.")
                            
                            //do something
                            _ = oauthToken
                            
                            self.viewModel.successLogin()
                        }
                    }
                } else {
                    print("loginWithKakaoTalk() success.")

                    // 성공 시 동작 구현
                    _ = oauthToken
                    self.viewModel.successLogin()
                }
            }
//        }
    }
}


extension SignInMainViewController: ASAuthorizationControllerPresentationContextProviding {
    // 인증창을 보여주기 위한 메서드 (인증창을 보여 줄 화면을 설정)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
}

extension SignInMainViewController: ASAuthorizationControllerDelegate {
    
    // 로그인 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("로그인 실패", error.localizedDescription)
    }
    
    // Apple ID 로그인에 성공한 경우, 사용자의 인증 정보를 확인하고 필요한 작업을 수행합니다
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIdCredential.user
            let fullName = appleIdCredential.fullName
            let email = appleIdCredential.email
            
            let identityToken = appleIdCredential.identityToken
            let authorizationCode = appleIdCredential.authorizationCode
            
            print("Apple ID 로그인에 성공하였습니다.")
            print("사용자 ID: \(userIdentifier)")
            print("전체 이름: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
            print("이메일: \(email ?? "")")
            print("Token: \(identityToken!)")
            print("authorizationCode: \(authorizationCode!)")
            
            // 로그인 성공
            self.viewModel.successLogin()
            
        // 암호 기반 인증에 성공한 경우(iCloud), 사용자의 인증 정보를 확인하고 필요한 작업을 수행합니다
        case let passwordCredential as ASPasswordCredential:
            let userIdentifier = passwordCredential.user
            let password = passwordCredential.password
            
            print("암호 기반 인증에 성공하였습니다.")
            print("사용자 이름: \(userIdentifier)")
            print("비밀번호: \(password)")
            
            // 여기에 로그인 성공 후 수행할 작업을 추가하세요.
            let mainVC = MainViewController()
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true)
            
        default: break
            
        }
    }
}
