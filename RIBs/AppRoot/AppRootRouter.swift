//
//  AppRootRouter.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/5/25.
//

import UIKit
import RIBs

protocol AppRootInteractable: Interactable, TodoListListener, UserInfoListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [UIViewController])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
  
    private let todoList: TodoListBuildable
    private let userInfo: UserInfoBuildable
    
    private var todoListRouting: ViewableRouting?
    private var userInfoRouting: ViewableRouting?
    
    init(
      interactor: AppRootInteractable,
      viewController: AppRootViewControllable,
      todoList: TodoListBuildable,
      userInfo: UserInfoBuildable
    ) {
        self.todoList = todoList
        self.userInfo = userInfo
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        let todoListRouting = todoList.build(withListener: interactor)
        let userInfoRouting = userInfo.build(withListener: interactor)
        
        attachChild(todoListRouting)
        attachChild(userInfoRouting)
        
        let viewControllers = [
            UINavigationController(rootViewController: todoListRouting.viewControllable.uiviewController),
            UINavigationController(rootViewController: userInfoRouting.viewControllable.uiviewController)
        ]
        
        viewController.setViewControllers(viewControllers)
    }
}

// UserInfo
// TodoList
//
