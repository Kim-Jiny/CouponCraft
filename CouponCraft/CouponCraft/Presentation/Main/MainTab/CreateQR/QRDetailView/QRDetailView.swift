//
//  QRDetailView.swift
//  CouponCraft
//
//  Created by 김미진 on 11/13/24.
//

import UIKit
protocol QRDetailDelegate: AnyObject {
    func backTab()
}

class QRDetailView: UIView {
    weak var delegate: QRDetailDelegate?
    var data: CouponDataViewModel? = nil
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var qrImg: UIImageView!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var readBtn: UIButton!
    @IBOutlet weak var backDarkView: UIView!
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }

    func viewInit() {
        // XIB 로드
        let nib = UINib(nibName: String(describing: Self.self), bundle: Bundle(for: type(of: self)))
        guard let loadedView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        // XIB에서 로드된 뷰를 현재 뷰에 추가
        loadedView.frame = self.bounds
        loadedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(loadedView)
        
        backView.layer.cornerRadius = 20
        backView.backgroundColor = .speedMain4
        
        saveBtn.setTitle(NSLocalizedString("Save", comment:"Save"), for: .normal)
        saveBtn.layer.cornerRadius = 10
        saveBtn.layer.borderWidth = 2
        saveBtn.layer.borderColor = UIColor.speedMain2.cgColor
        
        shareBtn.setTitle(NSLocalizedString("Share", comment:"Share"), for: .normal)
        shareBtn.layer.cornerRadius = 10
        shareBtn.layer.borderWidth = 2
        shareBtn.layer.borderColor = UIColor.speedMain2.cgColor
        
        readBtn.setTitle(NSLocalizedString("Read QR", comment:"Read QR"), for: .normal)
        readBtn.layer.cornerRadius = 10
        readBtn.layer.borderWidth = 2
        readBtn.layer.borderColor = UIColor.speedMain2.cgColor
        
        removeBtn.setTitle(NSLocalizedString("Remove", comment:"Remove"), for: .normal)
        removeBtn.layer.cornerRadius = 10
        removeBtn.layer.borderWidth = 2
        removeBtn.layer.borderColor = UIColor.speedMain2.cgColor
        
        qrImg.layer.borderWidth = 5
        qrImg.layer.borderColor = UIColor.speedMain3.cgColor
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backDarkViewTapped))
        backDarkView.isUserInteractionEnabled = true // 터치 이벤트를 받을 수 있게 설정
        backDarkView.addGestureRecognizer(tapGesture)
        
    }
    
    func fill(
        with item: CouponDataViewModel
    ) {
        self.data = item
        self.titleTextView.text = item.title
    }
    
    
    @objc private func backDarkViewTapped() {
        self.delegate?.backTab()
    }
}

