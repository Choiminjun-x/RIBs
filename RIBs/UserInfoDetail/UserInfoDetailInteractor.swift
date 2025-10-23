//
//  UserInfoDetailInteractor.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/8/25.
//

import Foundation
import RIBs

protocol UserInfoDetailPresentable: Presentable {
    var listener: UserInfoDetailPresentableListener? { get set }
    
    // 정보 업데이트 -> ViewController 전달
    func displayPageInfo(_ user: User?)
}

public protocol UserInfoDetailListener: AnyObject {
    func didTapCloseButton()
}

final class UserInfoDetailInteractor: PresentableInteractor<UserInfoDetailPresentable>, UserInfoDetailInteractable, UserInfoDetailPresentableListener {
    
    var router: UserInfoDetailRouting?
    var listener: UserInfoDetailListener? // 부모(UserInfo) RIB과의 연결점
    
    private let user: User? // User 데이터 저장
    
    init(presenter: UserInfoDetailPresentable, user: User?) {
        self.user = user
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        // User Data -> ViewController
        self.presenter.displayPageInfo(self.user)
    }
    
    func didTapCloseButton() {
        self.listener?.didTapCloseButton()
    }
}
