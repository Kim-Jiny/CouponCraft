//
//  UserTextFieldView.swift
//  CouponCraft
//
//  Created by 김미진 on 11/27/24.
//

import Foundation
import UIKit

struct UserTextFieldData {
    let title: String
    let placeholder: String
    let type: UserTextFiledType
}

enum UserTextFiledType {
    case email, password
}

protocol UserTextFieldDelegate: AnyObject {
    func textChanged()
}

class UserTextFieldView: UIView {
    weak var delegate: UserTextFieldDelegate?
    @IBOutlet weak var textFieldTitle: PaddedLabel!
    @IBOutlet weak var text: UITextField!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - XIB 로드 및 설정
    
    private func commonInit() {
        // XIB 로드
        let nib = UINib(nibName: String(describing: Self.self), bundle: Bundle(for: type(of: self)))
        guard let loadedView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        // XIB에서 로드된 뷰를 현재 뷰에 추가
        loadedView.frame = self.bounds
        loadedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(loadedView)
        setupUI()
    }
    
    private func setupUI() {
        textFieldTitle.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        text.layer.cornerRadius = 10
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func fill(
        with item: UserTextFieldData
    ) {
        self.textFieldTitle.text = item.title
        self.text.placeholder = item.placeholder
        
        if item.type == .password {
            self.text.textContentType = .password
        }
        text.attributedPlaceholder = NSAttributedString(
            string: text.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
    }
}
