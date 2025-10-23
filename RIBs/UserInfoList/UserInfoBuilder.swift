//
//  UserInfoBuilder.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/5/25.
//

import Foundation
import RIBs

public protocol UserInfoDependency: Dependency {
}

final class UserInfoComponent: Component<UserInfoDependency>, UserInfoDetailDependency {
}

public protocol UserInfoBuildable: Buildable {
    func build(withListener listener: UserInfoListener) -> ViewableRouting
}

final class UserInfoBuilder: Builder<UserInfoDependency>, UserInfoBuildable {
    
    public func build(withListener listener: UserInfoListener) -> ViewableRouting {
        let component = UserInfoComponent(dependency: dependency)
        let viewController = UserInfoViewController()
        let interactor = UserInfoInteractor(presenter: viewController)
        interactor.listener = listener
        
        let userInfoDetailBuilder = UserInfoDetailBuilder(dependency: component)
        
        return UserInfoRouter(interactor: interactor,
                              viewController: viewController,
                              userInfoDetailBuildable: userInfoDetailBuilder)
    }
}
