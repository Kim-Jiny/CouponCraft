//
//  UIStackView+Extensions.swift
//  CouponCraft
//
//  Created by 김미진 on 11/27/24.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        // 스택 뷰의 모든 arrangedSubviews를 순회하여 제거
        for subview in arrangedSubviews {
            removeArrangedSubview(subview)
            subview.removeFromSuperview() // 뷰 계층에서 서브뷰 제거
        }
    }
}
