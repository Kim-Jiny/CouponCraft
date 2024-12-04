//
//  DefaultRQListRepository.swift
//  CouponCraft
//
//  Created by 김미진 on 10/11/24.
//

import Foundation
import UIKit

final class DefaultRQListRepository {
    init() { }
}

extension DefaultRQListRepository: QRListRepository {
    
    func fetchQRTypeList(
        completion: @escaping (Result<[CouponItem], Error>) -> Void
    ) -> Cancellable? {
        
        let task = RepositoryTask()
        
        //  MARK: - 추후 통신이 추가해야함.
        let testCouponItems: [CouponItem] = [
        CouponItem(
                id: "1",
                brand: "스타벅스",
                brandImg: "https://cdn.hankyung.com/photo/201809/01.17860979.1.jpg",
                title: "아메리카노 10% 할인",
                contents: "이 쿠폰을 사용하여 아메리카노를 10% 할인받으세요.",
                providerName: "스타벅스 코리아",
                providerID: "0101",
                couponTitle: "아메리카노 10% 할인 쿠폰",
                createdDate: 1672531200.0, // 2023-01-01 00:00:00 UTC
                expirationDate: 1704067200.0, // 2024-01-01 00:00:00 UTC
                couponData: "https://example.com/coupon/starbucks/discount10",
                isEnable: true
            ),
            CouponItem(
                id: "2",
                brand: "맥도날드",
                brandImg: "https://blog.kakaocdn.net/dn/cJuNJY/btsCLq9Dfu8/RNf9oLkvPjnLEhcfbodYfK/img.png",
                title: "버거 구매 시 무료 감자튀김",
                contents: "버거를 구매하시면 무료 감자튀김을 제공합니다.",
                providerName: "맥도날드 코리아",
                providerID: "0201",
                couponTitle: "버거+감자튀김 무료 쿠폰",
                createdDate: 1675132800.0, // 2023-02-01 00:00:00 UTC
                expirationDate: 1706659200.0, // 2024-02-01 00:00:00 UTC
                couponData: "https://example.com/coupon/mcdonalds/freefry",
                isEnable: false
            ),
            CouponItem(
                id: "3",
                brand: "배스킨라빈스",
                brandImg: "https://cdn.hankyung.com/photo/201809/01.17872120.1.jpg",
                title: "싱글 레귤러 1+1 쿠폰",
                contents: "싱글 레귤러를 구매하시면 하나를 더 드립니다.",
                providerName: "배스킨라빈스 코리아",
                providerID: "0301",
                couponTitle: "싱글 레귤러 1+1",
                createdDate: 1677724800.0, // 2023-03-01 00:00:00 UTC
                expirationDate: 1712438400.0, // 2024-03-01 00:00:00 UTC
                couponData: "https://example.com/coupon/baskinrobbins/1plus1",
                isEnable: true
            ),
            CouponItem(
                id: "4",
                brand: "지니네",
                brandImg: "https://img.extmovie.com/files/attach/images/174/568/769/007/132ce600bf22b42431c67f0673fa05a6.jpg",
                title: "실링왁스 체험권",
                contents: "지니네 집에서 지니네 장비로 실링왁스를 마음껏 체험하게 해드립니다.",
                providerName: "지니",
                providerID: "0001",
                couponTitle: "실링왁스 체험권",
                createdDate: 1677724800.0, // 2023-03-01 00:00:00 UTC
                expirationDate: 1712438400.0, // 2024-03-01 00:00:00 UTC
                couponData: "https://example.com/coupon/baskinrobbins/1plus1",
                isEnable: true
            )
        ]

//        let menuType = QRTypeItem(id: "type3", title: "Menu", titleImage: UIImage(systemName: "doc.text.below.ecg"), detailImage: nil, type: .menu)
        completion(.success(testCouponItems))
        
        return task
    }
}
