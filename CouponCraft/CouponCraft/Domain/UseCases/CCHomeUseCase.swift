//
//  CCHomeUseCase.swift
//  CouponCraft
//
//  Created by 김미진 on 12/4/24.
//

import Foundation

protocol CCHomeUseCase {
    func fetchCCHomeData(token: String, completion: @escaping (Result<CCHomeData, Error>) -> Void)
}


class DefaultCCHomeUseCase: CCHomeUseCase {
    
    private let ccHomeRepository: CCHomeRepository
    
    init(ccHomeRepository: CCHomeRepository) {
        self.ccHomeRepository = ccHomeRepository
    }
    
    func fetchCCHomeData(token: String, completion: @escaping (Result<CCHomeData, Error>) -> Void) {
        ccHomeRepository.fetchData(userToken: token, completion: completion)
    }
}
