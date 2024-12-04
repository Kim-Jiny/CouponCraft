//
//  QRTypeItemViewModel.swift
//  CouponCraft
//
//  Created by 김미진 on 10/8/24.
//

import Foundation
import UIKit

struct CouponDataViewModel: Equatable {
    
    let id: String
    let brand: String
    let brandImageURL: URL?
    let title: String
    let contents: String
    let providerName: String
    let providerID: String
    let couponTitle: String
    let createdDate: String
    let expirationDate: String
    let couponData: String
    let isEnable: Bool

    init(from coupon: CouponItem) {
        self.id = coupon.id
        self.brand = coupon.brand
        self.title = coupon.title
        self.contents = coupon.contents
        self.providerName = coupon.providerName
        self.providerID = coupon.providerID
        self.couponTitle = coupon.couponTitle
        self.couponData = coupon.couponData
        self.isEnable = coupon.isEnable

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        self.createdDate = dateFormatter.string(from: Date(timeIntervalSince1970: coupon.createdDate))
        self.expirationDate = dateFormatter.string(from: Date(timeIntervalSince1970: coupon.expirationDate))

        // URL만 전달
        self.brandImageURL = URL(string: coupon.brandImg)
    }
}
