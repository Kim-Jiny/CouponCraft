//
//  CommunityTabViewController.swift
//  CouponCraft
//
//  Created by 김미진 on 11/29/24.
//

import UIKit

class CommunityTabViewController: UIViewController, StoryboardInstantiable {
    var viewModel: MainViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCV()
        if let viewModel = viewModel {
            bind(to: viewModel)
        }
    }
    
    private func setupCV() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
         
    private func bind(to viewModel: MainViewModel) {
        
    }
}
