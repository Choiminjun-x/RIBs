//
//  TodoListRouter.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/5/25.
//

import Foundation
import RIBs

protocol TodoListInteractable: Interactable {
    var router: TodoListRouting? { get set }
    var listener: TodoListListener? { get set }
}

protocol TodoListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TodoListRouter: ViewableRouter<TodoListInteractable, TodoListViewControllable>, TodoListRouting {

    override init(interactor: TodoListInteractable,
                  viewController: TodoListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTodoListDetail() {
        
    }
    
    func detachTodoListDetail() {
        
    }
}
