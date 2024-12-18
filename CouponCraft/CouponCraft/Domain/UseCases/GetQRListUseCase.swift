//
//  GetQRListUseCase.swift
//  CouponCraft
//
//  Created by 김미진 on 10/11/24.
//

import Foundation

protocol GetQRListUseCase {
    func execute(
        completion: @escaping (Result<[CouponItem], Error>) -> Void
    ) -> Cancellable?
}

final class DefaultGetQRListUseCase: GetQRListUseCase {

    private let qrListRepository: QRListRepository

    init(
        qrListRepository: QRListRepository
    ) {

        self.qrListRepository = qrListRepository
    }

    func execute(
        completion: @escaping (Result<[CouponItem], Error>) -> Void
    ) -> Cancellable? {

        return qrListRepository.fetchQRTypeList(completion: { result in
            completion(result)
        })
    }
}
