//
//  UserInfoRouter.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/5/25.
//

import UIKit
import RIBs

protocol UserInfoInteractable: Interactable, UserInfoDetailListener {
    var router: UserInfoRouting? { get set }
    var listener: UserInfoListener? { get set }
}

protocol UserInfoRouting: ViewableRouting {
    func attachUserInfoDetil(user: User?)
    func detachUserInfoDetail()
}

protocol UserInfoViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class UserInfoRouter: ViewableRouter<UserInfoInteractable, UserInfoViewControllable>, UserInfoRouting {
    
    private let userInfoDetailBuildable: UserInfoDetailBuildable
    private var userInfoDetailRouting: Routing?
    
    init(interactor: UserInfoInteractable,
         viewController: UserInfoViewControllable,
         userInfoDetailBuildable: UserInfoDetailBuildable) {
        self.userInfoDetailBuildable = userInfoDetailBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachUserInfoDetil(user: User?) {
        guard self.userInfoDetailRouting == nil else {
            return
        }
            
        let router = self.userInfoDetailBuildable.build(withListener: interactor, user: user)
        
        self.attachChild(router)
        self.userInfoDetailRouting = router
        self.presentWithPushTransition(router.viewControllable, animated: true)
    }
    
    func detachUserInfoDetail() {
        guard let router = userInfoDetailRouting else {
            return
        }
        
        self.viewController.uiviewController.dismiss(animated: true)
        self.userInfoDetailRouting = nil
        self.detachChild(router)
    }
    
    private func presentWithPushTransition(_ viewControllable: ViewControllable, animated: Bool) {
        viewControllable.uiviewController.modalPresentationStyle = .custom
        
        self.viewController.uiviewController.present(viewControllable.uiviewController, animated: true)
    }
}
