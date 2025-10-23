//
//  UserInfoInteractor.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/5/25.
//

import UIKit
import RIBs

protocol UserInfoPresentable: Presentable {
    var listener: UserInfoPresentableListener? { get set }

    // 정보 업데이트 -> ViewController 전달
    func updateUsers(_ users: [User])
    func showError(_ message: String)
}

public protocol UserInfoListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class UserInfoInteractor: PresentableInteractor<UserInfoPresentable>, UserInfoInteractable, UserInfoPresentableListener {
  
    var router: UserInfoRouting?
    var listener: UserInfoListener? // Router로 이벤트를 전달하기 위함

    private var userService = UserInfoService()
    private var users: [User] = []
    
    override init(presenter: UserInfoPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self // 전달 받은 ViewController와 연결
    }
    
    // RIB이 활성화될 때 자동으로 호출
    override func didBecomeActive() {
        super.didBecomeActive()
        // 최초 데이터 로드
        self.requestUserInfo()
    }
    
    // 최초 데이터 호출
    func requestPageInfo() {
        self.requestUserInfo()
    }
    
    func didTapRefreshButton() {
        self.requestUserInfo()
    }
    
    // API
    private func requestUserInfo() {
        userService.fetchUserInfos(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let users):
                self.users = users
                self.presenter.updateUsers(users)
                
            case .failure(let error):
                self.presenter.showError("사용자 정보를 불러오는데 실패했습니다: \(error.localizedDescription)")
            }
            
        })
    }
    
    
    // MARK: Routing
    
    func didTapUserInfoDetailButton(user: User?) {
        self.router?.attachUserInfoDetil(user: user)
    }
}


// MARK: UserInfoDetailListener -> 자식(UserInfoDetail) RIB과의 연결점

extension UserInfoInteractor: UserInfoDetailListener {
    
    func didTapCloseButton() {
        self.router?.detachUserInfoDetail()
    }
}
