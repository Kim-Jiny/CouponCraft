//
//  MypageTabViewController.swift
//  CouponCraft
//
//  Created by 김미진 on 10/8/24.
//
import UIKit

// MypageTabViewController는 마이 페이지에서 QR 목록을 보여주는 역할을 함
class MypageTabViewController: UIViewController, StoryboardInstantiable {
    
    // MainViewModel과 연동하기 위한 뷰모델 속성
    var viewModel: MainViewModel?
    
    // QR 목록을 보여줄 테이블 뷰 아웃렛
    @IBOutlet weak var myQRTableView: UITableView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLB: UILabel!
    private var isKeyboardVisible = false
    @IBOutlet weak var adViewHeightConstraints: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupAdView()
        // 뷰모델이 설정되어 있으면 바인딩 설정
        if let viewModel = viewModel {
            bind(to: viewModel)
        }
        // 키보드 알림 설정
        setupKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchMyQRList()
    }
    
    private func setupView() {
        // 배경 색상 설정
        view.backgroundColor = .speedMain3
        emptyLB.text = NSLocalizedString("There are no saved QR's.\nPlease generate or scan a QR.", comment: "")
    }
    
    private func setupAdView() {
        AdmobManager.shared.setMainBanner(adView, self, .list)
    }
    
    // 테이블 뷰 초기 설정 및 등록 메서드
    private func setupTableView() {
        myQRTableView.dragInteractionEnabled = true
        myQRTableView.delegate = self
        myQRTableView.dataSource = self
//        myQRTableView.register(UINib(nibName: MyQRTableViewCell.id, bundle: nil), forCellReuseIdentifier: MyQRTableViewCell.id)
        
    }
    
    // 뷰모델의 데이터와 뷰를 바인딩
    private func bind(to viewModel: MainViewModel) {
        
    }
    
    // 테이블 뷰의 데이터를 업데이트
    private func updateItems() {
        myQRTableView.reloadData()
    }
    
    // 키보드 등장 및 사라짐에 대한 알림 처리
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 키보드가 나타날 때 호출
    @objc private func keyboardWillShow(_ notification: Notification) {
        // 키보드 높이 가져오기
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            isKeyboardVisible = true // 키보드 상태 업데이트
            // 필요한 UI 업데이트 수행
            
            for subview in view.subviews {
                if let qrDetailView = subview as? QRDetailView {
                    qrDetailView.snp.updateConstraints {
                        $0.bottom.equalToSuperview().inset(keyboardHeight)
                    }
                    UIView.animate(withDuration: 5) { [weak self] in
                        self?.view.layoutIfNeeded()
                    }
                    
                    return
                }
            }
        }
    }

    // 키보드가 사라질 때 호출
    @objc private func keyboardWillHide(_ notification: Notification) {
        isKeyboardVisible = false // 키보드 상태 업데이트
        for subview in view.subviews {
            if let qrDetailView = subview as? QRDetailView {
                qrDetailView.snp.updateConstraints {
                    $0.bottom.equalToSuperview()
                }
                UIView.animate(withDuration: 5) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
                
                return
            }
        }
    }
}

// 테이블 뷰 데이터 소스 및 델리게이트 구현
extension MypageTabViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    // 테이블 셀 클릭 시 QR 상세 뷰를 표시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

