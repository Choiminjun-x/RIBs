//
//  TodoListBuilder.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/5/25.
//

import Foundation
import RIBs

public protocol TodoListDependency: Dependency {
}

final class TodoListComponent: Component<TodoListDependency> {
}

public protocol TodoListBuildable: Buildable {
    func build(withListener listener: TodoListListener) -> ViewableRouting
}

public final class TodoListBuilder: Builder<TodoListDependency>, TodoListBuildable {

    public override init(dependency: TodoListDependency) {
      super.init(dependency: dependency)
    }
    
    public func build(withListener listener: TodoListListener) -> ViewableRouting {
        let component = TodoListComponent(dependency: dependency)
        let viewController = TodoListViewController()
        let interactor = TodoListInteractor(presenter: viewController)
        interactor.listener = listener
        
        return TodoListRouter(interactor: interactor,
                              viewController: viewController)
    }
}
