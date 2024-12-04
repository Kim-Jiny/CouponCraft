//
//  AppleLoginRepository.swift
//  CouponCraft
//
//  Created by 김미진 on 12/4/24.
//

import Foundation
import AuthenticationServices

protocol AppleLoginRepository {
    func performAppleLogin(completion: @escaping (Result<ASAuthorizationAppleIDCredential, Error>) -> Void)
}

final class DefaultAppleLoginRepository: AppleLoginRepository {
    
    func performAppleLogin(completion: @escaping (Result<ASAuthorizationAppleIDCredential, Error>) -> Void) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        let delegate = AppleLoginControllerDelegate(completion: completion)
        authorizationController.delegate = delegate
        authorizationController.presentationContextProvider = delegate
        authorizationController.performRequests()
    }
}

// AppleLoginControllerDelegate.swift
final class AppleLoginControllerDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private let completion: (Result<ASAuthorizationAppleIDCredential, Error>) -> Void

    init(completion: @escaping (Result<ASAuthorizationAppleIDCredential, Error>) -> Void) {
        self.completion = completion
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            completion(.success(appleIDCredential))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion(.failure(error))
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}
