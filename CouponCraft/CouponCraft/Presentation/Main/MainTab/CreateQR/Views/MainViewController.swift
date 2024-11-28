//
//  MainViewController.swift
//  CouponCraft
//
//  Created by 김미진 on 10/8/24.
//

import Foundation
import UIKit

class MainViewController: UITabBarController, StoryboardInstantiable {
    
    private var viewModel: MainViewModel!
    
    
    // MARK: - Lifecycle

    static func create(
        with viewModel: MainViewModel
    ) -> MainViewController {
        let view = MainViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupBehaviours()
        self.bind(to: self.viewModel)
        self.viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: MainViewModel) {
        viewModel.typeItems.observe(on: self) { [weak self] _ in self?.updateItems() }
    }
    
    // MARK: - Private

    private func setupViews() {
        // 각 ViewController를 xib에서 불러오기
        let firstVC = CCHomeTabViewController.instantiateViewController(from: UIStoryboard(name: "MainViewController", bundle: nil))
        firstVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Home", comment: "Home탭"), image: UIImage(systemName: "house.fill"), tag: 0)
        firstVC.viewModel = viewModel
        
        let secondVC = ScanQRTabViewController.instantiateViewController(from: UIStoryboard(name: "MainViewController", bundle: nil))
        secondVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Community", comment: "Community탭"), image: UIImage(systemName: "ticket"), tag: 1)
        secondVC.viewModel = viewModel
        
        let fifthVC = MypageTabViewController.instantiateViewController(from: UIStoryboard(name: "MainViewController", bundle: nil))
        fifthVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Scan", comment: "Scan탭"), image: UIImage(systemName: "barcode.viewfinder"), tag: 5)
        fifthVC.viewModel = viewModel
        
        let thirdVC = MypageTabViewController.instantiateViewController(from: UIStoryboard(name: "MainViewController", bundle: nil))
        thirdVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Create", comment: "Create탭"), image: UIImage(systemName: "plus.diamond.fill"), tag: 2)
        thirdVC.viewModel = viewModel
        
        let fourthVC = AppSettingTabViewController.instantiateViewController(from: UIStoryboard(name: "MainViewController", bundle: nil))
        fourthVC.tabBarItem = UITabBarItem(title: NSLocalizedString("My", comment: "My탭"), image: UIImage(systemName: "person.fill"), tag: 3)
        fourthVC.viewModel = viewModel
        
        // 뷰 컨트롤러들을 탭 바에 추가
        self.viewControllers = [firstVC, secondVC, thirdVC, fifthVC, fourthVC]
        self.tabBar.tintColor = .speedMain0
        self.tabBar.backgroundColor = .speedMain4
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    // 키보드 내리기
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupBehaviours() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
    
    private func updateItems() {
        
    }
}
