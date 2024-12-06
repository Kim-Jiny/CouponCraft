//
//  MainPageData.swift
//  CouponCraft
//
//  Created by 김미진 on 12/4/24.
//

import Foundation
struct CCHomeData: Codable {
    let myCoupons: [CouponItem]
    let myCoins: Int
    let myIssuedCoupons: [CouponItem]
    let notifications: [NotificationItem]
}
