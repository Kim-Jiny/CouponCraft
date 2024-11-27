//
//  PaddingLabel.swift
//  CouponCraft
//
//  Created by 김미진 on 11/27/24.
//

import Foundation
import UIKit

class PaddedLabel: UILabel {
    var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: padding)
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        let width = superSize.width + padding.left + padding.right
        let height = superSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: height)
    }
}
