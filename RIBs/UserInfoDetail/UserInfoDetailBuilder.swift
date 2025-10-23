//
//  UserInfoDetailBuilder.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/8/25.
//

import Foundation
import RIBs

protocol UserInfoDetailDependency: Dependency {
}

final class UserInfoDetailComponent: Component<UserInfoDetailDependency> {
}

protocol UserInfoDetailBuildable: Buildable {
    func build(withListener listener: UserInfoDetailListener, user: User?) -> ViewableRouting
}

final class UserInfoDetailBuilder: Builder<UserInfoDetailDependency>, UserInfoDetailBuildable {
    
    public override init(dependency: UserInfoDetailDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: UserInfoDetailListener, user: User?) -> ViewableRouting {
        let component = UserInfoDetailComponent(dependency: dependency)
        let viewController = UserInfoDetailViewController()
        let interactor = UserInfoDetailInteractor(presenter: viewController, user: user)
        interactor.listener = listener
        
        return UserInfoDetailRouter(interactor: interactor,
                                    viewController: viewController)
    }
}
