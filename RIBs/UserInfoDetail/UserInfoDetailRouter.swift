//
//  UserInfoDetailRouter.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/8/25.
//

import Foundation
import RIBs

protocol UserInfoDetailInteractable: Interactable {
    var router: UserInfoDetailRouting? { get set }
    var listener: UserInfoDetailListener? { get set }
}

protocol UserInfoDetailViewControllable: ViewControllable {
    
}

protocol UserInfoDetailRouting: ViewableRouting {
    func attach()
    func detach()
}

final class UserInfoDetailRouter: ViewableRouter<UserInfoDetailInteractable, UserInfoDetailViewControllable>, UserInfoDetailRouting {
   
    private var currentChild: ViewableRouting?
    
    override init(interactor: UserInfoDetailInteractable,
                  viewController: UserInfoDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attach() {
        
    }
    
    func detach() {
    }
}
