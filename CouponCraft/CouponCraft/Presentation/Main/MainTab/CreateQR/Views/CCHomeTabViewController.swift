//
//  CouponCraftTabViewController.swift
//  CouponCraft
//
//  Created by 김미진 on 10/8/24.
//

import UIKit
import GoogleMobileAds

class CCHomeTabViewController: UIViewController, StoryboardInstantiable {
    var viewModel: MainViewModel?
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var contentsScrollView: UIScrollView!
    @IBOutlet weak var contentsScrollStackView: UIStackView!
    @IBOutlet weak var userInfoCardView: UIStackView!
    @IBOutlet weak var myCouponStackView: UIStackView!
    @IBOutlet weak var myCouponCollectionView: UICollectionView!
    @IBOutlet weak var expirationCouponStackView: UIStackView!
    @IBOutlet weak var expirationCouponCollectionView: UICollectionView!
    
    var typeView: CouponCraftTypeView? = nil
    private var isFirstSelectionDone = false
    private var colorPickerManager = ColorPickerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCV()
        if let viewModel = viewModel {
            bind(to: viewModel)
        }
        setupAdView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentsScrollStackView.layer.cornerRadius = 30
        userInfoCardView.layer.cornerRadius = 20
    }
    
    
    private func setupCV() {
        self.navigationController?.navigationBar.isHidden = true
        self.myCouponCollectionView.delegate = self
        self.myCouponCollectionView.dataSource = self
        self.expirationCouponCollectionView.delegate = self
        self.expirationCouponCollectionView.dataSource = self
        
        myCouponCollectionView.register(UINib(nibName: MyTicketCollectionViewCell.id, bundle: .main), forCellWithReuseIdentifier: MyTicketCollectionViewCell.id)
        expirationCouponCollectionView.register(UINib(nibName: MyTicketCollectionViewCell.id, bundle: .main), forCellWithReuseIdentifier: MyTicketCollectionViewCell.id)
    }
    
    private func setupAdView() {
        AdmobManager.shared.setMainBanner(adView, self, .main)
    }
         
    private func bind(to viewModel: MainViewModel) {
        viewModel.typeItems.observe(on: self) { [weak self] _ in self?.updateItems() }
        
        viewModel.typeItems.observe(on: self) { ccItems in
            
        }
        
    }
    
    private func updateItems() {
        self.myCouponCollectionView.reloadData()
        self.expirationCouponCollectionView.reloadData()
    }
    
    private func showSaveAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Download Complete", comment: "Download Complete"),
                                      message: NSLocalizedString("The QR image has been saved to the gallery.", comment: "The QR image has been saved to the gallery."),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment:"OK"), style: .default) {_ in
            self.typeView?.imageSaveCompleted()
        })
        present(alert, animated: true)
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Photo Access Permission Required", comment:"Photo Access Permission Required"),
                                      message: NSLocalizedString("Photo access permission is required to save the photo. Please change the permission in Settings.", comment:"Photo access permission is required to save the photo. Please change the permission in Settings."),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:"Cancel"), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Go to Settings", comment:"Go to Settings"), style: .default, handler: { [weak self] _ in
            self?.viewModel?.openAppSettings()
        }))
        present(alert, animated: true)
    }

}


extension CCHomeTabViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) // 원하는 마진 설정
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === myCouponCollectionView {
            return viewModel?.typeItems.value.count ?? 0
        }else if collectionView === expirationCouponCollectionView {
            return viewModel?.typeItems.value.count ?? 0
        }
        return viewModel?.typeItems.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyTicketCollectionViewCell.id, for: indexPath) as? MyTicketCollectionViewCell, let viewModel = viewModel else { return UICollectionViewCell() }
        cell.fill(with: viewModel.typeItems.value[indexPath.row])
        return cell
    }
}
