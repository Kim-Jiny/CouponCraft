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
        
        
        viewModel.photoLibraryOnlyAddPermission.observe(on: self) { [weak self] hasPermission in
            guard let hasPermission = hasPermission, let imgData = self?.viewModel?.CouponCraftItem.value?.qrImageData, let img = UIImage(data: imgData) else { return }
            guard hasPermission else {
                DispatchQueue.main.async {
                    self?.showPermissionAlert()
                }
                return
            }
            
            viewModel.downloadImage(image: img, completion: { _ in 
                DispatchQueue.main.async {
                    self?.showSaveAlert()
                }
            })
        }
        viewModel.CouponCraftItem.observe(on: self) { ccItems in
            
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
    
    func getTypeClass(_ type: CreateType) -> CouponCraftTypeView {
        switch type {
        case .url:
            return CouponCraftURLType()
        case .card:
            return CouponCraftCardType()
        case .menu:
            return CouponCraftBetaType()
        case .other:
            return CouponCraftCardType()
        }
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


extension CCHomeTabViewController: QRTypeDelegate {
    func shareImage() {
        
        guard let imageData = self.viewModel?.CouponCraftItem.value?.qrImageData, let qrImage = UIImage(data: imageData) else {
            print("공유할 이미지가 없습니다.")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [qrImage], applicationActivities: nil)
        
        // iPad에서의 팝오버 설정 (iPad에서는 이 설정이 없으면 앱이 충돌할 수 있음)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view // 공유 버튼이 있는 뷰를 기준으로 팝오버 표시
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func saveImage() {
        // TODO: - 권한을 체크하기전에 앱에 저장할지 디바이스 이미지로 저장할지를 선택하는 액션시트 구현
        let actionSheet = UIAlertController(title: nil, message: NSLocalizedString("Choose how to save the QR.", comment:"Choose how to save the QR."), preferredStyle: .actionSheet)
        
        let option1 = UIAlertAction(title: NSLocalizedString("Save QR Image to Gallery", comment:"Save QR Image to Gallery"), style: .default) { action in
            self.viewModel?.checkPhotoLibraryOnlyAddPermission()
        }
        let option2 = UIAlertAction(title: NSLocalizedString("Save to My QR", comment:"Save to My QR"), style: .default) { action in
            self.viewModel?.addMyQR(nil)
            self.typeView?.imageSaveCompleted()
            // TODO: - 저장완료된 이펙트 개발필요
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment:"Cancel"), style: .cancel) { action in
            self.typeView?.imageSaveCompleted()
        }
        
        actionSheet.addAction(option1)
        actionSheet.addAction(option2)
        actionSheet.addAction(cancel)
        
        // iPad에서 Action Sheet가 팝오버로 나타나도록 설정 (iPad에서는 필수)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view // 액션시트가 나타날 뷰 설정
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 1, height: 1) // 팝오버의 위치를 화면 중앙으로 설정
            popoverController.permittedArrowDirections = [] // 화살표 방향을 없애는 설정 (선택 사항)
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func generateQR(url: String) {
        let qrImg = self.viewModel?.generateQR(from: url, color: .black, backgroundColor: .white, logo: nil, logoStyle: .square)
        let item = QRItem(title: NSLocalizedString("Untitled", comment:"Untitled"), qrImageData: qrImg?.pngData(), qrType: .url, qrData: url, qrColor: UIColor.black.toHex() ?? "000000FF", backColor: UIColor.white.toHex() ?? "FFFFFFFF", logo: nil, logoStyle: .square)
        
        viewModel?.CouponCraftItem.value = item
    }
    
    func colorPicker() {
        
        let actionSheet = UIAlertController(title: nil, message: NSLocalizedString("Select the part where you want to change the color.", comment:"컬러를 변경할 부분을 선택하세요."), preferredStyle: .actionSheet)
        
        let option1 = UIAlertAction(title: NSLocalizedString("QR code", comment:"QR code"), style: .default) { action in
            self.colorPickerManager.showColorPicker(self) { selectedColor in
                if let color = selectedColor {
                    if let createdItem = self.viewModel?.CouponCraftItem.value {
                        let qrImg = self.viewModel?.generateQR(from: createdItem.title, color: color, backgroundColor: UIColor(hex: createdItem.backColor) ?? .white , logo: UIImage(data: createdItem.logo ?? Data()), logoStyle: createdItem.logoStyle)
                        let item = QRItem(title: NSLocalizedString("Untitled", comment:"Untitled"), qrImageData: qrImg?.pngData(), qrType: .url, qrData: createdItem.qrData, qrColor: color.toHex() ?? createdItem.qrColor, backColor: createdItem.backColor, logo: createdItem.logo, logoStyle: createdItem.logoStyle)
                        print("qr color : \(color.toHex())  //  back color : \(createdItem.backColor)")
                        print("qr color : \(item.qrColor)  //  back color : \(item.backColor)")
                        self.viewModel?.CouponCraftItem.value = item
                    }
                }else {
                    print("유저 컬러 선택 취소")
                }
            }
        }
        let option2 = UIAlertAction(title: NSLocalizedString("Background", comment:"Background"), style: .default) { action in
            self.colorPickerManager.showColorPicker(self) { selectedColor in
                if let color = selectedColor {
                    if let createdItem = self.viewModel?.CouponCraftItem.value {
                        let qrImg = self.viewModel?.generateQR(from: createdItem.title, color: UIColor(hex: createdItem.qrColor) ?? .black, backgroundColor: color, logo: UIImage(data: createdItem.logo ?? Data()), logoStyle: createdItem.logoStyle)
                        let item = QRItem(title: NSLocalizedString("Untitled", comment:"Untitled"), qrImageData: qrImg?.pngData(), qrType: .url, qrData: createdItem.qrData, qrColor: createdItem.qrColor, backColor: color.toHex() ?? createdItem.backColor, logo: createdItem.logo, logoStyle: createdItem.logoStyle)
                        print("qr color : \(createdItem.qrColor)  //  back color : \(color.toHex())")
                        print("qr color : \(item.qrColor)  //  back color : \(item.backColor)")
                        self.viewModel?.CouponCraftItem.value = item
                    }
                }else {
                    print("유저 컬러 선택 취소")
                }
            }
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment:"Cancel"), style: .cancel) { action in
            print("컬러 선택 안함")
        }
        
        actionSheet.addAction(option1)
        actionSheet.addAction(option2)
        actionSheet.addAction(cancel)
        
        // iPad에서 Action Sheet가 팝오버로 나타나도록 설정 (iPad에서는 필수)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view // 액션시트가 나타날 뷰 설정
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 1, height: 1) // 팝오버의 위치를 화면 중앙으로 설정
            popoverController.permittedArrowDirections = [] // 화살표 방향을 없애는 설정 (선택 사항)
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func addLogo() {
        
        
        let actionSheet = UIAlertController(title: nil, message: NSLocalizedString("Please choose the shape of the logo to add.", comment:"추가할 로고의 모양을 선택해주세요."), preferredStyle: .actionSheet)
        
        let option1 = UIAlertAction(title: NSLocalizedString("Circle", comment:"Circle"), style: .default) { action in
            
            self.viewModel?.CouponCraftItem.value?.logoStyle = .circle
            self.openImagePicker()
        }
        let option2 = UIAlertAction(title: NSLocalizedString("Square", comment:"Square"), style: .default) { action in
            
            self.viewModel?.CouponCraftItem.value?.logoStyle = .square
            self.openImagePicker()
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment:"Cancel"), style: .cancel) { action in
            print("로고 추가 취소")
        }
        
        actionSheet.addAction(option1)
        actionSheet.addAction(option2)
        actionSheet.addAction(cancel)
        
        // iPad에서 Action Sheet가 팝오버로 나타나도록 설정 (iPad에서는 필수)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view // 액션시트가 나타날 뷰 설정
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 1, height: 1) // 팝오버의 위치를 화면 중앙으로 설정
            popoverController.permittedArrowDirections = [] // 화살표 방향을 없애는 설정 (선택 사항)
        }
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    private func openImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension CCHomeTabViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // 이미지가 선택되었을 때 호출되는 델리게이트 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            if let createdItem = self.viewModel?.CouponCraftItem.value {
                let qrImg = self.viewModel?.generateQR(from: createdItem.title, color: UIColor(hex: createdItem.qrColor) ?? .black, backgroundColor: UIColor(hex: createdItem.backColor) ?? .white, logo: selectedImage, logoStyle: createdItem.logoStyle)
                let item = QRItem(title: NSLocalizedString("Untitled", comment:"Untitled"), qrImageData: qrImg?.pngData(), qrType: .url, qrData: createdItem.qrData, qrColor: createdItem.qrColor, backColor: createdItem.backColor, logo: selectedImage.pngData(), logoStyle: createdItem.logoStyle)
                
                self.viewModel?.CouponCraftItem.value = item
            }
        }else {
            print("유저가 이미지 선택을 취소함")
        }
    }
}
