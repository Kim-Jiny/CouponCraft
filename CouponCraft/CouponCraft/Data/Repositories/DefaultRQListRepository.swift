//
//  DefaultRQListRepository.swift
//  CouponCraft
//
//  Created by 김미진 on 10/11/24.
//

import Foundation
import UIKit

final class DefaultRQListRepository {
    init() { }
}

extension DefaultRQListRepository: QRListRepository {
    
    func fetchQRTypeList(
        completion: @escaping (Result<[QRTypeItem], Error>) -> Void
    ) -> Cancellable? {
        
        let task = RepositoryTask()
        
        //  MARK: - 추후 통신이 추가해야함.
        
        let urlType = QRTypeItem(id: "type1", title: "안마권", titleImage: UIImage(systemName: "safari"), detailImage: nil, type: .url)
        let cardType = QRTypeItem(id: "type2", title: "커피한잔 쏜다", titleImage: UIImage(systemName: "person.crop.square.filled.and.at.rectangle"), detailImage: nil, type: .card)
        let item3 = QRTypeItem(id: "type3", title: "실링왁스 무료체험권", titleImage: UIImage(systemName: "person.crop.square.filled.and.at.rectangle"), detailImage: nil, type: .card)
        let item4 = QRTypeItem(id: "type4", title: "소원권", titleImage: UIImage(systemName: "person.crop.square.filled.and.at.rectangle"), detailImage: nil, type: .card)
        let item5 = QRTypeItem(id: "type5", title: "설거지권", titleImage: UIImage(systemName: "person.crop.square.filled.and.at.rectangle"), detailImage: nil, type: .card)
//        let menuType = QRTypeItem(id: "type3", title: "Menu", titleImage: UIImage(systemName: "doc.text.below.ecg"), detailImage: nil, type: .menu)
        completion(.success([urlType, cardType, item3, item4, item5]))
        
        return task
    }
}
