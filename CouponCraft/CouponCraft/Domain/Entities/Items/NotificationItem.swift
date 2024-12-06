//
//  NotificationItem.swift
//  CouponCraft
//
//  Created by 김미진 on 12/4/24.
//

import Foundation

struct NotificationItem: Codable {
    let id: String
    let title: String
    let content: String
    let date: Date
    let isRead: Bool
}
