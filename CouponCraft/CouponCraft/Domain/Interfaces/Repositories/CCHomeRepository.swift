//
//  CCHomeRepository.swift
//  CouponCraft
//
//  Created by 김미진 on 12/4/24.
//

import Foundation
protocol CCHomeRepository {
    func fetchData(userToken: String, completion: @escaping (Result<CCHomeData, Error>) -> Void)
}

final class DefaultCCHomeRepository: CCHomeRepository {
    private let networkManager: NetworkManager // 서버 통신을 담당하는 매니저
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchData(userToken: String, completion: @escaping (Result<CCHomeData, Error>) -> Void) {
        // 서버 API 호출 예시 (네트워크 코드)
        // URLSession, Alamofire 등을 사용하여 실제 API 호출을 진행
        
        // 서버에서 메인 페이지 데이터를 받아오는 API 호출
//        let url = URL(string: "https://yourapi.com/mainPageData")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        
//        networkManager.performRequest(request: request) { (result: Result<MainPageData, Error>) in
//            switch result {
//            case .success(let data):
//                // 데이터를 성공적으로 받았을 때
//                completion(.success(data))
//            case .failure(let error):
//                // 실패했을 때
//                completion(.failure(error))
//            }
//        }
        let jsonString = """
        {
            "myCoupons": [
                {
                    "id": "1",
                    "brand": "스타벅스",
                    "brandImg": "https://cdn.hankyung.com/photo/201809/01.17860979.1.jpg",
                    "title": "아메리카노 10% 할인",
                    "contents": "이 쿠폰을 사용하여 아메리카노를 10% 할인받으세요.",
                    "providerName": "스타벅스 코리아",
                    "providerID": "0101",
                    "couponTitle": "아메리카노 10% 할인 쿠폰",
                    "createdDate": 1672531200.0,
                    "expirationDate": 1704067200.0,
                    "couponData": "https://example.com/coupon/starbucks/discount10",
                    "isEnable": true
                },
                {
                    "id": "2",
                    "brand": "맥도날드",
                    "brandImg": "https://blog.kakaocdn.net/dn/cJuNJY/btsCLq9Dfu8/RNf9oLkvPjnLEhcfbodYfK/img.png",
                    "title": "버거 구매 시 무료 감자튀김",
                    "contents": "버거를 구매하시면 무료 감자튀김을 제공합니다.",
                    "providerName": "맥도날드 코리아",
                    "providerID": "0201",
                    "couponTitle": "버거+감자튀김 무료 쿠폰",
                    "createdDate": 1675132800.0,
                    "expirationDate": 1706659200.0,
                    "couponData": "https://example.com/coupon/mcdonalds/freefry",
                    "isEnable": false
                },
                {
                    "id": "3",
                    "brand": "배스킨라빈스",
                    "brandImg": "https://cdn.hankyung.com/photo/201809/01.17872120.1.jpg",
                    "title": "싱글 레귤러 1+1 쿠폰",
                    "contents": "싱글 레귤러를 구매하시면 하나를 더 드립니다.",
                    "providerName": "배스킨라빈스 코리아",
                    "providerID": "0301",
                    "couponTitle": "싱글 레귤러 1+1",
                    "createdDate": 1677724800.0,
                    "expirationDate": 1712438400.0,
                    "couponData": "https://example.com/coupon/baskinrobbins/1plus1",
                    "isEnable": true
                },
                {
                    "id": "4",
                    "brand": "지니네",
                    "brandImg": "https://img.extmovie.com/files/attach/images/174/568/769/007/132ce600bf22b42431c67f0673fa05a6.jpg",
                    "title": "실링왁스 체험권",
                    "contents": "지니네 집에서 지니네 장비로 실링왁스를 마음껏 체험하게 해드립니다.",
                    "providerName": "지니",
                    "providerID": "0001",
                    "couponTitle": "실링왁스 체험권",
                    "createdDate": 1677724800.0,
                    "expirationDate": 1712438400.0,
                    "couponData": "https://example.com/coupon/baskinrobbins/1plus1",
                    "isEnable": true
                }
            ],
            "myCoins": 500,
            "myIssuedCoupons": [
                {
                    "id": "5",
                    "brand": "던킨도너츠",
                    "brandImg": "https://cdn.dunkindonuts.com/images/dunkin-logo.png",
                    "title": "도너츠 1개 무료 쿠폰",
                    "contents": "도너츠 1개를 무료로 제공합니다.",
                    "providerName": "던킨도너츠",
                    "providerID": "0401",
                    "couponTitle": "도너츠 1개 무료 쿠폰",
                    "createdDate": 1678953600.0,
                    "expirationDate": 1714070400.0,
                    "couponData": "https://example.com/coupon/dunkin/1free",
                    "isEnable": true
                }
            ],
            "notifications": [
                {
                    "id": "n1",
                    "title": "새로운 쿠폰이 발급되었습니다.",
                    "content": "스타벅스에서 아메리카노 10% 할인 쿠폰을 받으셨습니다.",
                    "date": "2024-12-01T10:00:00Z",
                    "isRead": false
                },
                {
                    "id": "n2",
                    "title": "쿠폰 만료 알림",
                    "content": "배스킨라빈스 1+1 쿠폰이 곧 만료됩니다.",
                    "date": "2024-12-02T14:30:00Z",
                    "isRead": true
                }
            ]
        }
        """


        
        func decodeUserInfo(from jsonData: Data, completion: @escaping (Result<CCHomeData, Error>) -> Void) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601 // ISO 8601 형식의 날짜를 처리하기 위한 설정
            
            do {
                let data = try decoder.decode(CCHomeData.self, from: jsonData)
                print("디코딩 성공: \(data)")
                completion(.success(data))
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
