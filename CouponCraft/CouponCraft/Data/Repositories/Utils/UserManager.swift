//
//  UserManager.swift
//  CouponCraft
//
//  Created by 김미진 on 12/4/24.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    var userInfo: UserInfoDTO?
    //TODO: - 추후 각 계정 자동로그인 확인 후 이 부분 업데이트 해 줘야함.
    var loginType: LoginType = .email
    var userAuthToken: String = ""
    
    private init() {}
    
    func saveUserInfo(_ userInfo: UserInfoDTO) {
        self.userInfo = userInfo
    }
    
    func getUserInfo() -> UserInfoDTO? {
        return self.userInfo
    }
    
    func getAuthToken() -> String? {
        let token: String? = UserDefaultsManager.shared.getData(forKey: "userAuthToken")
        return token
    }
    
    func updateAuthToken(_ token: String) {
        UserDefaultsManager.shared.setData(token, forKey: "userAuthToken")
    }
}
