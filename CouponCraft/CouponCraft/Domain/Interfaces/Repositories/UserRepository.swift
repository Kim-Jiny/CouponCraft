//
//  UserRepository.swift
//  CouponCraft
//
//  Created by 김미진 on 12/4/24.
//

import Foundation
protocol UserRepository {
    func fetchUserData(authToken: String, loginType: LoginType, completion: @escaping (Result<UserInfoDTO, Error>) -> Void)
    func fetchUserData(id: String, pw: String, completion: @escaping (Result<UserInfoDTO, Error>) -> Void)
}

final class DefaultUserRepository: UserRepository {
    func fetchUserData(authToken: String, loginType: LoginType, completion: @escaping (Result<UserInfoDTO, Error>) -> Void) {
        // 서버 API 호출 예시 (네트워크 코드)
        // URLSession, Alamofire 등을 사용하여 실제 API 호출을 진행
//        let url = URL(string: "https://yourserver.com/api/user")!
//        var request = URLRequest(url: url)
//        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error)) // 실패 시 에러 반환
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError())) // 데이터 없으면 실패
//                return
//            }
//            
//            do {
//                // 서버에서 받은 데이터를 UserData 모델로 디코딩
//                let userData = try JSONDecoder().decode(UserInfoDTO.self, from: data)
//                completion(.success(userData)) // 유저 데이터 반환
//            } catch {
//                completion(.failure(error)) // 디코딩 실패 시 에러 반환
//            }
//        }.resume()
        
        // 위 JSON 데이터를 Data로 변환하여 디코딩
        let jsonString = """
        {
          "id": "12345-abcd-67890-efgh",
          "token": "12345",
          "username": "Jiny",
          "email": "kjinyz@naver.com",
          "loginType": "\(loginType.rawValue)",
          "phoneNumber": "010-1234-5678",
          "profileImageUrl": "https://mydaily.co.kr/photos/2019/02/11/2019021112332125251_l.jpg",
          "lastLoginDate": "2024-12-04T00:00:00Z",
          "isVerified": true,
          "dateOfBirth": "1990-01-01T00:00:00Z",
          "permissions": {
            "pushNotifications": true
          },
          "language": "kr",
          "timeZone": "Asia/Seoul",
          "createdAt": "2021-01-01T00:00:00Z",
          "updatedAt": "2024-12-04T00:00:00Z",
          "coins": 150,
          "accessLevel": 2,
          "appLevel": 3
        }
        """
        
        func decodeUserInfo(from jsonData: Data, completion: @escaping (Result<UserInfoDTO, Error>) -> Void) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601 // ISO 8601 형식의 날짜를 처리하기 위한 설정
            
            do {
                let userInfo = try decoder.decode(UserInfoDTO.self, from: jsonData)
                print("디코딩 성공: \(userInfo)")
                completion(.success(userInfo))
            } catch {
                print("디코딩 실패: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        if let jsonData = jsonString.data(using: .utf8) {
            decodeUserInfo(from: jsonData, completion: completion)
        }
    }
    
    
    func fetchUserData(id: String, pw: String, completion: @escaping (Result<UserInfoDTO, Error>) -> Void) {
        let jsonString = """
        {
          "id": "12345-abcd-67890-efgh",
          "token": "12345",
          "username": "Jiny",
          "email": "kjinyz@naver.com",
          "loginType": "\(LoginType.email)",
          "phoneNumber": "010-1234-5678",
          "profileImageUrl": "https://mydaily.co.kr/photos/2019/02/11/2019021112332125251_l.jpg",
          "lastLoginDate": "2024-12-04T00:00:00Z",
          "isVerified": true,
          "dateOfBirth": "1990-01-01T00:00:00Z",
          "permissions": {
            "pushNotifications": true
          },
          "language": "kr",
          "timeZone": "Asia/Seoul",
          "createdAt": "2021-01-01T00:00:00Z",
          "updatedAt": "2024-12-04T00:00:00Z",
          "coins": 150,
          "accessLevel": 2,
          "appLevel": 3
        }
        """
        
        func decodeUserInfo(from jsonData: Data, completion: @escaping (Result<UserInfoDTO, Error>) -> Void) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601 // ISO 8601 형식의 날짜를 처리하기 위한 설정
            
            do {
                let userInfo = try decoder.decode(UserInfoDTO.self, from: jsonData)
                print("디코딩 성공: \(userInfo)")
                completion(.success(userInfo))
            } catch {
                print("디코딩 실패: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        if let jsonData = jsonString.data(using: .utf8) {
            decodeUserInfo(from: jsonData, completion: completion)
        }
    }
}
