//
//  CouponItem.swift
//  CouponCraft
//
//  Created by 김미진 on 10/11/24.
//

import Foundation
import UIKit

struct CouponItem: Equatable, Identifiable, Codable {
    typealias Identifier = String
    let id: Identifier
    // 쿠폰을 발급한 사람의 브랜드
    let brand: String
    // 쿠폰을 발급한 사람의 브랜드 이미지
    let brandImg: String
    
    // 쿠폰의 타이틀과 내용  - 쿠폰 디테일에서 사용
    let title: String
    let contents: String
    // 쿠폰을 발급한사람
    let providerName: String
    let providerID: String
    
    // 쿠폰 리스트에서 보여줄 쿠폰이름 ( 예) 아메리카노 10% 할인권 )
    let couponTitle: String
    
    // 쿠폰이 생성된 날짜
    let createdDate: Double
    // 쿠폰의 만료 날짜
    let expirationDate: Double
    
    // 유니버셜, 딥링크로 통하는 URL이 담긴 데이터
    let couponData: String
    
    // 사용 가능 여부
    let isEnable: Bool
}
