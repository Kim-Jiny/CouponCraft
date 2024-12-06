//
//  UserInfo.swift
//  CouponCraft
//
//  Created by 김미진 on 12/4/24.
//

import Foundation

struct UserInfoDTO: Codable, Identifiable {
    let id: String  // UUID 또는 서버에서 제공하는 고유 ID
    let token: String  // 서버 통신에 사용되는 token
    let username: String // 유저가 등록한 닉네임
    let email: String // 이메일 - 로그인할때 필요.
    let loginType: LoginType // "Google", "Apple", "Kakao", "Email" 등
    let phoneNumber: String? // 휴대폰 번호
    let profileImageUrl: String? // 프로필 사진 이미지 url
    let lastLoginDate: Date? // 마지막 로그인 시간
    let isVerified: Bool // 이메일 인증을 받은 유저인가?
    let dateOfBirth: Date? // 유저가 등록한 생일
    let permissions: UserPermissions? // 예: ["pushNotifications": true, "darkMode": false]
    let language: String // ISO 코드 예: "en", "ko"
    let timeZone: String // 예: "Asia/Seoul"
    let createdAt: Date // - 유저가 가입한 시간
    let updatedAt: Date // - 유저 정보가 업데이트되면 업데이트됨
    var coins: Int // 광고를 보고 생기는 코인 - 앱에서 쿠폰 발급시 사용
    let accessLevel: Int // 앱의 권한 등급
    let appLevel: Int // 앱 내에서 유저 등급 ( 코인사용량에 따라 달라짐 )
    
    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        token = try container.decode(String.self, forKey: .token)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        loginType = try container.decode(LoginType.self, forKey: .loginType)
        phoneNumber = try? container.decode(String.self, forKey: .phoneNumber)
        profileImageUrl = try? container.decode(String.self, forKey: .profileImageUrl)
        lastLoginDate = try? container.decode(Date.self, forKey: .lastLoginDate)
        isVerified = try container.decode(Bool.self, forKey: .isVerified)
        dateOfBirth = try? container.decode(Date.self, forKey: .dateOfBirth)
        permissions = try? container.decode(UserPermissions.self, forKey: .permissions)
        language = try container.decode(String.self, forKey: .language)
        timeZone = try container.decode(String.self, forKey: .timeZone)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        coins = (try? container.decode(Int.self, forKey: .coins)) ?? 0 // 기본값 0
        accessLevel = try container.decode(Int.self, forKey: .accessLevel)
        appLevel = try container.decode(Int.self, forKey: .appLevel)
    }
}


enum LoginType: String, Codable {
    case google = "Google"
    case apple = "Apple"
    case kakao = "Kakao"
    case email = "Email"
}

struct UserPermissions: Codable {
    let pushNotifications: Bool
}
