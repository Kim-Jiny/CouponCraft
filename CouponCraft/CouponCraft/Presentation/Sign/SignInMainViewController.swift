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
    @IBOutlet weak var signInStackView: UIStackView!
    @IBOutlet weak var signUpStackView: UIStackView!
    @IBOutlet weak var signInMainView: UIView!
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var signUpTextFieldStackView: UIStackView!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var socialLine: PaddedLabel!
    @IBOutlet weak var socialStackView: UIStackView!
    @IBOutlet weak var signupSocialStackView: UIStackView!
    @IBOutlet weak var signUpLB: UILabel!
    @IBOutlet weak var signInBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var personalBtn: UIButton!
    @IBOutlet weak var personalImg: UIImageView!
    @IBOutlet weak var personalLB: UILabel!
    @IBOutlet weak var signInLB: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    
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
        signInStackView.setCustomSpacing(30, after: textFieldStackView)
        
        let emailView = UserTextFieldView()
        let emailViewData = UserTextFieldData(title: "Email", placeholder: "your@email.com", type: .email)
        emailView.fill(with: emailViewData)
        textFieldStackView.addArrangedSubview(emailView)
        
        let pwView = UserTextFieldView()
        let pwViewData = UserTextFieldData(title: "Password", placeholder: "password", type: .password)
        pwView.fill(with: pwViewData)
        textFieldStackView.addArrangedSubview(pwView)
        
        enterBtn.layer.cornerRadius = 20
        signUpBtn.layer.cornerRadius = 20
        socialLine.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        setupAttributedString(fullText: "Don't have an account? Sign up", pointText: "Sign up", lb: signUpLB)
        signUpLB.isUserInteractionEnabled = true
        let signUpTapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpTaped))
        signUpLB.addGestureRecognizer(signUpTapGesture)
        setupSocialLogin(socialStackView)
        
        //Sign up
        signUpStackView.setCustomSpacing(30, after: signUpTextFieldStackView)
        
        setupAttributedString(fullText: "I agree to the processing of personal data", pointText: "personal data", lb: personalLB)
        personalLB.isUserInteractionEnabled = true
        let personalLBTapGesture = UITapGestureRecognizer(target: self, action: #selector(personalTaped))
        personalLB.addGestureRecognizer(personalLBTapGesture)
        personalBtn.addTarget(self, action: #selector(personalCheck), for: .touchUpInside)
        
        
        setupAttributedString(fullText: "Already have an account? Sign in", pointText: "Sign in", lb: signInLB)
        signInLB.isUserInteractionEnabled = true
        let signInTapGesture = UITapGestureRecognizer(target: self, action: #selector(signInTaped))
        signInLB.addGestureRecognizer(signInTapGesture)
        
        
        let signUpEmailView = UserTextFieldView()
        let signUpEmailViewData = UserTextFieldData(title: "Email", placeholder: "your@email.com", type: .email)
        signUpEmailView.fill(with: signUpEmailViewData)
        signUpTextFieldStackView.addArrangedSubview(signUpEmailView)
        
        let signUpPwView = UserTextFieldView()
        let signUpPwViewData = UserTextFieldData(title: "Password", placeholder: "password", type: .password)
        signUpPwView.fill(with: signUpPwViewData)
        signUpTextFieldStackView.addArrangedSubview(signUpPwView)
        
        setupSocialLogin(signupSocialStackView)
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
    
    private func setupSocialLogin(_ st: UIStackView) {
        let ggBtn = GIDSignInButton()
        ggBtn.style = .standard
        ggBtn.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
        st.addArrangedSubview(ggBtn)
        
        let appleBtn = ASAuthorizationAppleIDButton()
        appleBtn.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
        st.addArrangedSubview(appleBtn)
        
        let kakaoBtn = UIButton()
        kakaoBtn.imageView?.contentMode = .scaleAspectFill
        kakaoBtn.imageView?.layer.cornerRadius = 8
        kakaoBtn.setImage(UIImage(named: "kakao_login_medium_wide"), for: .normal)
        kakaoBtn.addTarget(self, action: #selector(kakaoLogin), for: .touchUpInside)
        st.addArrangedSubview(kakaoBtn)
    }
    
    @objc private func googleLogin() {
        self.viewModel.googleLogin(self)
    }
    @objc private func appleLogin() {
        self.viewModel.appleLogin(self)
    }
    
    @objc private func kakaoLogin() {
        self.viewModel.kakaoLogin(self)
    }
    
    @objc private func signUpTaped() {
        self.signInStackView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.signInStackView.isHidden = true
        }) { _ in
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.signUpStackView.alpha = 1
                self.signUpStackView.isHidden = false
            }) { _ in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func signInTaped() {
        self.signUpStackView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.signUpStackView.isHidden = true
        }) { _ in
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.signInStackView.alpha = 1
                self.signInStackView.isHidden = false
            }) { _ in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func personalTaped() {
        print("개인정보 처리방침 url 넣고 내부 사파리로 띄워주자")
    }
    
    @objc private func personalCheck() {
        let checked = self.personalBtn.isSelected
        self.personalBtn.isSelected = !checked
        self.personalImg.image = UIImage(systemName: checked ? "checkmark.square.fill" : "checkmark.square")
    }
    
    private func setupAttributedString(fullText: String, pointText: String, lb: UILabel) {
        // NSAttributedString 생성
        let attText = NSMutableAttributedString(string: fullText)

        // 특정 텍스트에 색상 및 볼드 폰트 적용
        if let range = fullText.range(of: pointText) {
            let nsRange = NSRange(range, in: fullText)
            let boldFont = UIFont.boldSystemFont(ofSize: 16)
            attText.addAttributes([
                .foregroundColor: UIColor.speedMain0,
                .font: boldFont
            ], range: nsRange)
        }

        // UILabel에 적용
        lb.attributedText = attText
    }
}

