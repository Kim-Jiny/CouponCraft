//
//  QRTypeCollectionViewCell.swift
//  CouponCraft
//
//  Created by 김미진 on 11/8/24.
//

import UIKit

class MyTicketCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var brandLB: UILabel!
    @IBOutlet weak var typeLB: UILabel!
    @IBOutlet weak var expireLB: UILabel!
    
    static var id: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    private var viewModel: CouponDataViewModel!

    func fill(
        with viewModel: CouponDataViewModel
    ) {
        self.viewModel = viewModel
        self.typeLB.text = viewModel.title
        self.brandLB.text = viewModel.providerName
        self.expireLB.text = "~ \(viewModel.expirationDate)"
        self.layer.cornerRadius = 5
        self.backgroundColor = .speedMain4
    }
}
